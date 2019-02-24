unit uProcesFinder; 

{$H+}

interface
uses Windows, Classes, SysUtils;
type
 NTSTATUS = Cardinal;
const
 SystemProcessesAndThreadsInformation = 5;
 STATUS_SUCCESS = NTSTATUS($00000000);
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

function FillProcessesList(var slProcesses: TStringList): Boolean;

implementation

function ZwQuerySystemInformation(dwSystemInformationClass: DWORD;
                                  pSystemInformation: Pointer;
                                  dwSystemInformationLength: DWORD;
                                  var iReturnLength:DWORD): NTSTATUS;
                                  stdcall;external 'ntdll.dll';

function FillProcessesList(var slProcesses: TStringList): Boolean;
var
ret: NTSTATUS;
pBuffer, pCur: PSYSTEM_PROCESSES;
ReturnLength: DWORD;
i: Integer;
ProcessName: String;
MemoryInKbyte: integer;
begin
Result := False;
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
if ret = STATUS_SUCCESS then // Проверяем успешность выполнения запроса
begin
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
slProcesses.Add(IntToStr(i) + ' -' +
' Имя: ' + ProcessName +
' PID: ' + IntToStr(pCur^.ProcessId) +
' Приоритет: ' + IntToStr(pCur^.BasePriority) +
' Потоков: ' + IntToStr(pCur^.ThreadCount) +
' Дескрипторов: ' + IntToStr(pCur^.HandleCount) +
' Память: ' + IntToStr(MemoryInKbyte)+ ' Kb');
// Вычисляем указатель на следующую структуру SYSTEM_PROCESSES
// Для этого к адресу этой структуру прибавляем смещение следующей
// из поля NextEntryDelta
pCur := pointer(dword(pCur) + pCur^.NextEntryDelta);
// Крутим цикл, пока есть следующая структура
until pCur^.NextEntryDelta = 0;
Result := True;
end;
FreeMem(pBuffer);
end;

end.

