unit uProcInfo;

{$H+}

interface
uses Windows, Classes, SysUtils, ComCtrls;
type
 NTSTATUS = Cardinal;
const
 SystemProcessesAndThreadsInformation = 5;
 STATUS_SUCCESS = NTSTATUS($00000000);

 KILL_NOERR = 0;
 KILL_NOTSUPPORTED = -1;
 KILL_ERR_OPENPROCESS = -2;
 KILL_ERR_TERMINATEPROCESS = -3;

type

 PClientID = ^TClientID;
 TClientID = packed record
  UniqueProcess:cardinal;
  UniqueThread:cardinal;
 end;

 PUnicodeString = ^TUnicodeString;
 TUnicodeString = packed record
  Length: Word; // Длина строки без терминального нуля
  MaximumLength: Word; // Полная длина буфера
  Buffer: PWideChar; // Указатель на буфер для UNICODE-строки
 end;

 PVM_COUNTERS = ^VM_COUNTERS;
 VM_COUNTERS = packed record
    PeakVirtualSize,
    VirtualSize,
    PageFaultCount,
    PeakWorkingSetSize,
    WorkingSetSize,
    QuotaPeakPagedPoolUsage,
    QuotaPagedPoolUsage,
    QuotaPeakNonPagedPoolUsage,
    QuotaNonPagedPoolUsage,
    PagefileUsage,
    PeakPagefileUsage: dword;
 end;

 PIO_COUNTERS = ^IO_COUNTERS;
 IO_COUNTERS = packed record
   ReadOperationCount,
   WriteOperationCount,
   OtherOperationCount,
   ReadTransferCount,
   WriteTransferCount,
   OtherTransferCount: LARGE_INTEGER;
 end;


 PSYSTEM_THREADS = ^SYSTEM_THREADS;
 SYSTEM_THREADS = packed record
  KernelTime,
  UserTime,
  CreateTime: LARGE_INTEGER;
  WaitTime: dword;
  StartAddress: pointer;
  ClientId: TClientId;
  Priority,
  BasePriority,
  ContextSwitchCount: dword;
  State: dword;
  WaitReason: dword;
 end;


 PSYSTEM_PROCESSES = ^SYSTEM_PROCESSES;
 SYSTEM_PROCESSES = packed record
  NextEntryDelta, // Смещение следующей структуры от начала этой
  ThreadCount: dword; // Количество потоков процесса
  Reserved1 : array [0..5] of dword;
  CreateTime, // Временные характеристики процесса
  UserTime,
  KernelTime: LARGE_INTEGER;
  ProcessName: TUnicodeString; // Имя процесса
  BasePriority: dword; // Базовый приоритет
  ProcessId, // Идентификатор процесса – PID
  InheritedFromProcessId, // PID родителя
  HandleCount: dword; // Открытые дестрипторы
  Reserved2: array [0..1] of dword;
  // Счетчики с инфой об использовании памяти и системы ввода-вывода.
  VmCounters: VM_COUNTERS;
  IoCounters: IO_COUNTERS; // Windows 2000 only
  // Массив структур с инфой о потоках процесса
  Threads: array [0..0] of SYSTEM_THREADS;
 end;

function FillProcessesList(): Boolean;
function ProcessWatcher(ProcName:string):integer;
function ProcessWatcherLog(var OldMemory: Integer; WatcherProcessName: string): string;
function Close_Process_By_Pid(pid : longint) : integer;

implementation

uses UMain;

function ZwQuerySystemInformation(dwSystemInformationClass: DWORD;
                                  pSystemInformation: Pointer;
                                  dwSystemInformationLength: DWORD;
                                  var iReturnLength:DWORD): NTSTATUS;
                                  stdcall;external 'ntdll.dll';

function FillProcessesList(): Boolean;
var ret: NTSTATUS;
    pBuffer, pCur: PSYSTEM_PROCESSES;
    ReturnLength: DWORD;
    i: Integer;
    ProcessName: String;
    MemoryInKbyte: integer;
    ListItem: TListItem;
begin
 Result := False;
 MainForm.ProcesInfoView.Items.Clear;
 //ListItems.Clear;
 ReturnLength := 0;
// Запрашиваем размер требуемого буфера
 ret := ZwQuerySystemInformation(SystemProcessesAndThreadsInformation,
                                 nil,
                                 0,
                                 ReturnLength);
// Резервируем буфер
 pBuffer := AllocMem(ReturnLength);
// Получаем информацию о процессах в буфер
 ret := ZwQuerySystemInformation(SystemProcessesAndThreadsInformation,
                                 pBuffer,
                                 ReturnLength,
                                 ReturnLength);
 if ret = STATUS_SUCCESS then begin// Проверяем успешность выполнения запроса
  pCur := pBuffer; // Инициируем указатель на текущую структуру
  i := 0; // Инициируем счетчик процессов. Его можно и не использовать.
  // Проходим в цикле по всей цепочке структур
  repeat
   inc(i); // Увеличиваем счетчик процессов.
   // Смотрим длину имени процесса и если оно не равно 0,
   // то читаем строку из буфера, иначе – имя = <неизвестно>
   if pCur^.ProcessName.Length = 0 then ProcessName := '<неизвестно>'
   else ProcessName := pCur^.ProcessName.Buffer;

   MemoryInKbyte := pCur^.VmCounters.PagefileUsage;
   MemoryInKbyte := MemoryInKbyte div 1024;
   // Добавляем инфу о процессе в TStringList
   ListItem := MainForm.ProcesInfoView.Items.Add;
   ListItem.Caption := ProcessName;
   ListItem.SubItems.Add(IntToStr(pCur^.ProcessId));
   ListItem.SubItems.Add(IntToStr(MemoryInKbyte));
   ListItem.SubItems.Add(IntToStr(pCur^.BasePriority));
   ListItem.SubItems.Add(IntToStr(pCur^.ThreadCount));
   // Вычисляем указатель на следующую структуру SYSTEM_PROCESSES
   // Для этого к адресу этой структуру прибавляем смещение следующей
   // из поля NextEntryDelta
   pCur := pointer(dword(pCur) + pCur^.NextEntryDelta);
   // Крутим цикл, пока есть следующая структура
  until pCur^.NextEntryDelta = 0;
 end;
 Result := True;
 FreeMem(pBuffer);
end;

function ProcessWatcher(ProcName:string):integer;
var ret: NTSTATUS;
    pBuffer, pCur: PSYSTEM_PROCESSES;
    ReturnLength: DWORD;
    ProcessName: String;
begin
 Result := 0;
 ReturnLength := 0;
// Запрашиваем размер требуемого буфера
 ret := ZwQuerySystemInformation(SystemProcessesAndThreadsInformation,
                                 nil,
                                 0,
                                 ReturnLength);
// Резервируем буфер
 pBuffer := AllocMem(ReturnLength);
// Получаем информацию о процессах в буфер
 ret := ZwQuerySystemInformation(SystemProcessesAndThreadsInformation,
                                 pBuffer,
                                 ReturnLength,
                                 ReturnLength);
 if ret = STATUS_SUCCESS then begin// Проверяем успешность выполнения запроса
  pCur := pBuffer; // Инициируем указатель на текущую структуру

  // Проходим в цикле по всей цепочке структур
  repeat

   // Смотрим длину имени процесса и если оно не равно 0,
   // то читаем строку из буфера, иначе – имя = <неизвестно>
   if pCur^.ProcessName.Length = 0 then ProcessName := '<неизвестно>'
   else ProcessName := pCur^.ProcessName.Buffer;

   if ProcessName = ProcName then begin
    Result := pCur^.VmCounters.PagefileUsage;
    break;
   end;

   // Вычисляем указатель на следующую структуру SYSTEM_PROCESSES
   // Для этого к адресу этой структуру прибавляем смещение следующей
   // из поля NextEntryDelta
   pCur := pointer(dword(pCur) + pCur^.NextEntryDelta);
   // Крутим цикл, пока есть следующая структура
  until pCur^.NextEntryDelta = 0;
 end;
 FreeMem(pBuffer);
end;

function ProcessWatcherLog(var OldMemory: Integer; WatcherProcessName: string): string;
var st_LogWatch: string;
    NewProcessMemory : integer;
begin
 Result := '';
 st_LogWatch := '';
 st_LogWatch := DateTimeToStr(Now) + ': ' + WatcherProcessName;
 NewProcessMemory := ProcessWatcher(WatcherProcessName);
 if NewProcessMemory = 0 then begin
  st_LogWatch := st_LogWatch + ' процес не найден или завершен';
  Result := st_LogWatch;
  exit;
 end;
 if OldMemory < 0 then OldMemory := Abs(OldMemory);
 if OldMemory = NewProcessMemory then exit;
 if (OldMemory = 0) and (NewProcessMemory <> 0) then begin
  st_LogWatch := st_LogWatch + ' Память: '
                 + IntToStr(NewProcessMemory) + ' начало слежения';
  OldMemory := NewProcessMemory;
  Result := st_LogWatch;
  exit;
 end;
 if (OldMemory <> NewProcessMemory) then
 begin
  NewProcessMemory := NewProcessMemory - OldMemory;
  OldMemory := OldMemory + NewProcessMemory;
  if NewProcessMemory > 0 then begin
  st_LogWatch := st_LogWatch + ' Память: '
                 + IntToStr(OldMemory) + ' байт Разница : +'
                 + IntToStr(NewProcessMemory) + ' байт.';
  end else begin
   st_LogWatch := st_LogWatch + ' Память: '
                 + IntToStr(OldMemory) + ' байт Разница : '
                 + IntToStr(NewProcessMemory) + ' байт.';
  end;
  Result := st_LogWatch;
 end;
end;

function Close_Process_By_Pid(pid : longint) : integer;
var hProcess : THANDLE;
    TermSucc : boolean;
begin
  Result := KILL_NOTSUPPORTED;
  hProcess := OpenProcess(PROCESS_ALL_ACCESS, true, pid);
  if (hProcess <> 0) then begin
   TermSucc := TerminateProcess(hProcess, 0);
   if not TermSucc then begin
    Result := KILL_ERR_TERMINATEPROCESS;
   end else begin
     Result := KILL_NOERR;
   end;
  end else begin
   Result := KILL_ERR_OPENPROCESS;
  end;
end;

end.

