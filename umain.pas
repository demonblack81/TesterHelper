unit UMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, StdCtrls, Spin, ExtCtrls, Grids, Buttons, LCLType,

  uGeneration, uProcInfo, uEditStringsParam;

type

  { TMainForm }

  TMainForm = class(TForm)
    AllCheck: TCheckBox;
    BtnWord: TButton;
    BtnFrase: TButton;
    LabelSettings: TLabel;
    OpenGenerationBtn: TButton;
    SaveGenerationBtn: TButton;
    CloseProcessBtn: TButton;
    SaveWatcherLogBtn: TButton;
    ProcessWatchLabel: TLabel;
    ProcessWatcherMemo: TMemo;
    ProcessWatchwerTimer: TTimer;
    StopWatchSBtn: TSpeedButton;
    TabSheet1: TTabSheet;
    UpdateProcessBtn: TButton;
    ProcesInfoGroupBox: TGroupBox;
    ProcesInfoView: TListView;
    ResetTimeBtn: TButton;
    EditBtn1: TButton;
    StartStopBtn: TSpeedButton;
    TimeLabel: TLabel;
    TimerForTime: TTimer;
    TimerSecGroup: TGroupBox;
    MenuEdit: TLabeledEdit;
    SubMenuEdit: TLabeledEdit;
    MenuGroupBox: TGroupBox;
    UncheckBtn1: TRadioButton;
    EditTextEdit: TLabeledEdit;
    EditBtn: TButton;
    ButtonGroupBox: TGroupBox;
    BtnNameEdit: TLabeledEdit;
    CheckRBtn1: TRadioButton;
    CheckGroupBox: TGroupBox;
    TextGroupBox: TGroupBox;
    StringGrid1: TStringGrid;
    TabRaznoe: TTabSheet;
    WindowBtn: TButton;
    ExistsFileCheck: TCheckBox;
    ButtonBtn: TButton;
    OpenRBtn: TRadioButton;
    CloseBtn: TRadioButton;
    ProgramGroupBox: TGroupBox;
    PhonePlusCheck: TCheckBox;
    EnHighRadio: TRadioButton;
    GenerationBtn: TButton;
    GenerationGroup: TGroupBox;
    MaxSymbolLabel: TLabel;
    MaxSymbolSpin: TSpinEdit;
    GenerationMemo: TMemo;
    PhoneRBtn: TRadioButton;
    CheckBtn: TButton;
    ZipRBtn: TRadioButton;
    URLRBtn: TRadioButton;
    StringRBtn: TRadioButton;
    EMailRBtn: TRadioButton;
    PathRBtn: TRadioButton;
    TypeFieldGroup: TGroupBox;
    NumberCheck: TCheckBox;
    SpecCheck: TCheckBox;
    EngSymbolCheck: TCheckBox;
    RuSymbolCheck: TCheckBox;
    EnAllRadio: TRadioButton;
    RuAllRadio: TRadioButton;
    RUSymbolGroup: TGroupBox;
    RuHighRadio: TRadioButton;
    EnLowRadio: TRadioButton;
    EngSymbolGroup: TGroupBox;
    RuLowRadio: TRadioButton;
    SymbolGroup: TGroupBox;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuClose: TMenuItem;
    PageControl: TPageControl;
    MainStatBar: TStatusBar;
    TabGeneration: TTabSheet;
    TabTestCases: TTabSheet;
    procedure AllCheckChange(Sender: TObject);
    procedure BtnWordClick(Sender: TObject);
    procedure CloseProcessBtnClick(Sender: TObject);
    procedure EMailRBtnChange(Sender: TObject);
    procedure EnAllRadioChange(Sender: TObject);
    procedure EngSymbolCheckChange(Sender: TObject);
    procedure EnHighRadioChange(Sender: TObject);
    procedure EnLowRadioChange(Sender: TObject);
    procedure ExistsFileCheckChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GenerationBtnClick(Sender: TObject);
    procedure OpenGenerationBtnClick(Sender: TObject);
    procedure ProcesInfoViewDblClick(Sender: TObject);
    procedure ProcessWatchwerTimerTimer(Sender: TObject);
    procedure ResetTimeBtnClick(Sender: TObject);
    procedure SaveGenerationBtnClick(Sender: TObject);
    procedure SaveWatcherLogBtnClick(Sender: TObject);
    procedure StartStopBtnClick(Sender: TObject);
    procedure StopWatchSBtnClick(Sender: TObject);
    procedure TimerForTimeTimer(Sender: TObject);
    procedure UpdateProcessBtnClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure NumberCheckChange(Sender: TObject);
    procedure PathRBtnChange(Sender: TObject);
    procedure PhonePlusCheckChange(Sender: TObject);
    procedure PhoneRBtnChange(Sender: TObject);
    procedure RuAllRadioChange(Sender: TObject);
    procedure RuHighRadioChange(Sender: TObject);
    procedure RuLowRadioChange(Sender: TObject);
    procedure RuSymbolCheckChange(Sender: TObject);
    procedure SpecCheckChange(Sender: TObject);
    procedure StringRBtnChange(Sender: TObject);
    procedure URLRBtnChange(Sender: TObject);
    procedure ZipRBtnChange(Sender: TObject);
  private
    { private declarations }
    UsingSymbol,
    UsingType         : Byte;
    Secondomer        : TTime;
    HH,MM,SS,MS       : Word;
    WatcherProcessName,
    StartPath         : string;
    LastProcessMemory : integer;
  public
    { public declarations }

  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
 StartPath := ExtractFileDir(ParamStr(0)); // определяем  путь к программе
 if StartPath[Length(StartPath)] <> '\' then begin
   StartPath := StartPath + '\';
 end; // проверяем есть ли на конце строки "\"
 Randomize;
 InitilzationSymbol;
 UsingSymbol := 0;
 UsingType := 1;
 Secondomer := 0;
 TimeLabel.Caption := TimeToStr(Secondomer);
 PageControl.TabIndex := 0;
 WatcherProcessName := '';
 LastProcessMemory := 0;
end;


procedure TMainForm.MenuCloseClick(Sender: TObject);
begin
 FinilazeSymbol;
 Close;
end;

procedure TMainForm.GenerationBtnClick(Sender: TObject);
begin
 GenerationMemo.Lines.Clear;
 SaveGenerationBtn.Enabled := True;
 case (UsingType) of
      1:
       begin
        GenerationMemo.Lines.Add(GenerationString(MaxSymbolSpin.Value, UsingSymbol));
       end;

      2:
       begin
        GenerationMemo.Lines.Add(GenerationEMail(MaxSymbolSpin.Value));
       end;

      3:
       begin
        GenerationMemo.Lines.Add(GenerationUrl(MaxSymbolSpin.Value));
       end;

      4:
       begin
        GenerationMemo.Lines.Add(GenerationZip(MaxSymbolSpin.Value));
       end;

      5:
       begin
        GenerationMemo.Lines.Add(GenerationPhone(MaxSymbolSpin.Value, PhonePlusCheck.Checked));
       end;
      6:
       begin
        GenerationMemo.Lines.Add(GenerationPath(ExistsFileCheck.Checked));
       end;

      else begin
       GenerationMemo.Lines.Add('Неизвестный тип Строки!!!');
      end;
 end;
end;

procedure TMainForm.OpenGenerationBtnClick(Sender: TObject);
begin
  GenerationMemo.Lines.LoadFromFile(StartPath+ '\Generation\genstr.txt');
end;

procedure TMainForm.ProcesInfoViewDblClick(Sender: TObject);
begin
 if ProcesInfoView.Selected <> nil then begin
  WatcherProcessName := ProcesInfoView.Selected.Caption;
  if Application.MessageBox(PChar('Вы уверены что хотите следить за процессом' +
                                    WatcherProcessName + '?'),
                           'Внимание!', MB_YESNO) = IDYES then begin

   ProcessWatcherMemo.Clear;
   StopWatchSBtn.Flat:= False;
   ProcessWatchwerTimer.Enabled := True;
  end;
 end;
end;

procedure TMainForm.ProcessWatchwerTimerTimer(Sender: TObject);
var LogStr: string;
begin
  LogStr := ProcessWatcherLog(LastProcessMemory, WatcherProcessName);
  if LogStr <> '' then ProcessWatcherMemo.Lines.Add(LogStr);
end;

procedure TMainForm.ResetTimeBtnClick(Sender: TObject);
begin
  Secondomer := 0;
  TimeLabel.Caption := TimeToStr(Secondomer);
end;

procedure TMainForm.SaveGenerationBtnClick(Sender: TObject);
begin
  GenerationMemo.Lines.SaveToFile(StartPath+ '\Generation\genstr.txt');
  SaveGenerationBtn.Enabled := False;
end;

procedure TMainForm.SaveWatcherLogBtnClick(Sender: TObject);
begin
 if ProcessWatcherMemo.Lines.Count > 0 then begin
  ProcessWatcherMemo.Lines.SaveToFile(StartPath + '\Watch\' +
                                                WatcherProcessName + '.txt');
  SaveWatcherLogBtn.Enabled := False;
 end;
end;

procedure TMainForm.StartStopBtnClick(Sender: TObject);
begin
 if not StartStopBtn.Flat then begin
  StartStopBtn.Flat  := True;
  StartStopBtn.Caption := 'Стоп';
  TimerForTime.Enabled := True;
 end else begin
  TimerForTime.Enabled := False;
  StartStopBtn.Flat := False;
  StartStopBtn.Caption := 'Старт';
 end;
end;

procedure TMainForm.StopWatchSBtnClick(Sender: TObject);
begin
 if not StopWatchSBtn.Flat then begin
  ProcessWatchwerTimer.Enabled := False;
  StopWatchSBtn.Flat:= True;
  LastProcessMemory := 0;
  ProcessWatcherMemo.Lines.Add('Завершение слежения за процессом: '
                                                    + WatcherProcessName);
  SaveWatcherLogBtn.Enabled := True;
 end;
end;

procedure TMainForm.TimerForTimeTimer(Sender: TObject);
begin
  Secondomer := Secondomer + EncodeTime(00,00,00,TimerForTime.Interval);
  DecodeTime(Secondomer, HH, MM, SS, MS);
  if HH > 0 then begin
   TimeLabel.Caption := Format('%d:%d:%d',[HH, MM, SS]);
  end else begin
   TimeLabel.Caption := Format('%d:%d.%d',[MM, SS, MS]);
  end;
end;

procedure TMainForm.UpdateProcessBtnClick(Sender: TObject);
begin
 if not FillProcessesList() then begin // Заполняем список процессов
  ShowMessage('Ошибка. Не могу получить список процессов.');
 end;
 CloseProcessBtn.Enabled := True;
end;

procedure TMainForm.AllCheckChange(Sender: TObject);
begin
  If AllCheck.Checked then begin
    EngSymbolCheck.Checked := True;
    EnAllRadio.Checked := True;
    EngSymbolCheck.Enabled := False;
    EnAllRadio.Enabled := False;
    EnLowRadio.Enabled := False;
    EnHighRadio.Enabled := False;

    RuSymbolCheck.Checked := True;
    RuAllRadio.Checked := True;
    RuSymbolCheck.Enabled := False;
    RuAllRadio.Enabled := False;
    RuLowRadio.Enabled := False;
    RuHighRadio.Enabled := False;

    SpecCheck.Checked := True;
    SpecCheck.Enabled := False;
    NumberCheck.Checked := True;
    NumberCheck.Enabled := False;
    UsingSymbol := 100;
  end else begin
    EngSymbolCheck.Checked := False;
    EnAllRadio.Checked := False;
    EngSymbolCheck.Enabled := True;
    EnAllRadio.Enabled := True;
    EnLowRadio.Enabled := True;
    EnHighRadio.Enabled := True;

    RuSymbolCheck.Checked := False;
    RuAllRadio.Checked := False;
    RuSymbolCheck.Enabled := True;
    RuAllRadio.Enabled := True;
    RuLowRadio.Enabled := True;
    RuHighRadio.Enabled := True;

    SpecCheck.Checked := False;
    SpecCheck.Enabled := True;
    NumberCheck.Checked := False;
    NumberCheck.Enabled := True;
    UsingSymbol := 0;
  end;
end;

procedure TMainForm.BtnWordClick(Sender: TObject);
begin
  StringsParamForm.ShowModal;
end;

procedure TMainForm.CloseProcessBtnClick(Sender: TObject);
Var iKillErr: integer;
begin
 if ProcesInfoView.Selected <> nil then begin
  if Application.MessageBox(PChar('Вы уверены что хотите завершить процесс' +
                                    ProcesInfoView.Selected.Caption + '?'),
                           'Внимание!', MB_YESNO) = id_Yes then begin
   iKillErr := Close_Process_By_Pid(StrToInt(ProcesInfoView.Selected.SubItems[0]));
   if (iKillErr <> 0) then begin
    ShowMessage('Не могу закрыть процесс нет прав для завершения');
   end else begin
    ShowMessage('Процесс ' + ProcesInfoView.Selected.Caption + ' завершен.')
   end;
   if not FillProcessesList() then begin // Заполняем список процессов
    ShowMessage('Ошибка. Не могу получить список процессов.');
   end;
  end;
 end else begin
  ShowMessage('Не Выбран Процесс!');
 end;
end;

procedure TMainForm.NumberCheckChange(Sender: TObject);
begin
 if NumberCheck.Checked then begin
   UsingSymbol := UsingSymbol + 1;
 end else begin
   UsingSymbol := UsingSymbol - 1;
 end;
end;

procedure TMainForm.SpecCheckChange(Sender: TObject);
begin
 if SpecCheck.Checked then begin
   UsingSymbol := UsingSymbol + 2;
 end else begin
   UsingSymbol := UsingSymbol - 2;
 end;
end;

procedure TMainForm.EngSymbolCheckChange(Sender: TObject);
begin
 if EngSymbolCheck.Checked then begin
  EnAllRadio.Enabled := True;
  EnHighRadio.Enabled := True;
  EnLowRadio.Enabled := True;
  EnAllRadio.Checked := True;
 end else begin
  EnAllRadio.Checked := False;
  EnAllRadio.Enabled := False;
  EnHighRadio.Checked := False;
  EnHighRadio.Enabled := False;
  EnLowRadio.Checked := False;
  EnLowRadio.Enabled := False;
 end;
end;


procedure TMainForm.EnAllRadioChange(Sender: TObject);
begin
 if EnAllRadio.Checked then begin
   UsingSymbol := UsingSymbol + 5;
 end else begin
   UsingSymbol := UsingSymbol - 5;
 end;
end;


procedure TMainForm.EnHighRadioChange(Sender: TObject);
begin
  if EnHighRadio.Checked then begin
   UsingSymbol := UsingSymbol + 20;
 end else begin
   UsingSymbol := UsingSymbol - 20;
 end;
end;

procedure TMainForm.EnLowRadioChange(Sender: TObject);
begin
 if EnLowRadio.Checked then begin
   UsingSymbol := UsingSymbol + 10;
 end else begin
   UsingSymbol := UsingSymbol - 10;
 end;
end;

procedure TMainForm.ExistsFileCheckChange(Sender: TObject);
begin

end;

procedure TMainForm.RuSymbolCheckChange(Sender: TObject);
begin
 if RuSymbolCheck.Checked then begin
  RuAllRadio.Enabled := True;
  RuLowRadio.Enabled := True;
  RuHighRadio.Enabled := True;
  RuAllRadio.Checked := True;
 end else begin
  RuAllRadio.Checked := False;
  RuAllRadio.Enabled := False;
  RuLowRadio.Checked := False;
  RuLowRadio.Enabled := False;
  RuHighRadio.Checked := False;
  RuHighRadio.Enabled := False;
 end;
end;

procedure TMainForm.RuAllRadioChange(Sender: TObject);
begin
 if RuAllRadio.Checked then begin
   UsingSymbol := UsingSymbol + 50;
 end else begin
   UsingSymbol := UsingSymbol - 50;
 end;
end;

procedure TMainForm.RuLowRadioChange(Sender: TObject);
begin
 if RuLowRadio.Checked then begin
   UsingSymbol := UsingSymbol + 60;
 end else begin
   UsingSymbol := UsingSymbol - 60;
 end;
end;

procedure TMainForm.RuHighRadioChange(Sender: TObject);
begin
 if RuHighRadio.Checked then begin
   UsingSymbol := UsingSymbol + 70;
 end else begin
   UsingSymbol := UsingSymbol - 70;
 end;
end;

procedure TMainForm.StringRBtnChange(Sender: TObject);
begin
 if StringRBtn.Checked then begin
  UsingType := 1;
 end else begin
  UsingType := 0;
 end;
end;

procedure TMainForm.EMailRBtnChange(Sender: TObject);
begin
 if EMailRBtn.Checked then begin
  UsingType := 2;
 end else begin
  UsingType := 0;
 end;
end;

procedure TMainForm.URLRBtnChange(Sender: TObject);
begin
 if URLRBtn.Checked then begin
  UsingType := 3;
 end else begin
  UsingType := 0;
 end;
end;

procedure TMainForm.ZipRBtnChange(Sender: TObject);
begin
 if ZipRBtn.Checked then begin
  UsingType := 4;
  MaxSymbolSpin.Value := 6;
  MaxSymbolSpin.MaxValue := 6;
  MaxSymbolSpin.MinValue := 4;
 end else begin
  UsingType := 0;
  MaxSymbolSpin.MinValue := 1;
  MaxSymbolSpin.MaxValue := 65534;
  MaxSymbolSpin.Value := 30;
 end;
end;

procedure TMainForm.PhoneRBtnChange(Sender: TObject);
begin
 if PhoneRBtn.Checked then begin
  UsingType := 5;
  MaxSymbolSpin.Value := 7;
  MaxSymbolSpin.MaxValue := 20;
  MaxSymbolSpin.MinValue := 7;
  PhonePlusCheck.Visible := True;
 end else begin
  UsingType := 0;
  MaxSymbolSpin.MinValue := 1;
  MaxSymbolSpin.MaxValue := 65534;
  MaxSymbolSpin.Value := 30;
  PhonePlusCheck.Visible := False;
 end;
end;

procedure TMainForm.PathRBtnChange(Sender: TObject);
begin
 if PathRBtn.Checked then begin
  UsingType := 6;
  ExistsFileCheck.Visible := True;
 end else begin
  UsingType := 0;
  ExistsFileCheck.Visible := False;
 end;
end;

procedure TMainForm.PhonePlusCheckChange(Sender: TObject);
begin
  if PhonePlusCheck.Checked then begin
   MaxSymbolSpin.Value := 13;
  end;
end;

end.
