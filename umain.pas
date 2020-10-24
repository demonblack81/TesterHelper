unit UMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, StdCtrls, Spin, ExtCtrls, Buttons, LCLType,

  uGeneration, uProcInfo, uEditStringsParam, uPhraseTemplate, uListOperation, uFastPhrases, uMakedPhrases;

type

  { TMainForm }

  TMainForm = class(TForm)
    AllCheck: TCheckBox;
    FastPhraseBitBtn: TBitBtn;
    BtnPasteFromClipboard: TButton;
    ClearBitBtn: TBitBtn;
    MakePhraseBitBtn: TBitBtn;
    CopyToClipBitBtn: TBitBtn;
    BtnWord: TButton;
    BtnPhrase: TButton;
    MenuItem2: TMenuItem;
    FastPhrasesMenuItem: TMenuItem;
    MakedPhrMenuItem: TMenuItem;
    PhrasesMenuItem: TMenuItem;
    WordsMenuItem: TMenuItem;
    TemplateComboBox: TComboBox;
    FirstTempCB: TComboBox;
    SecondTempCB: TComboBox;
    ThirdTempCB: TComboBox;
    FourthTempCB: TComboBox;
    FifthTempCB: TComboBox;
    SixthTempCB: TComboBox;
    SeventhTempCB: TComboBox;
    EigthTempCB: TComboBox;
    Label1: TLabel;
    EigthCBTemplLabel: TLabel;
    PhraseMemoLabel: TLabel;
    FirstCBTemplLabel: TLabel;
    SecondCBTemplLabel: TLabel;
    ThirdCBTemplLabel: TLabel;
    FourthCBTemplLabel: TLabel;
    FifthCBTemplLabel: TLabel;
    SixthCBTemplLabel: TLabel;
    SeventhCBTemplLabel: TLabel;
    LabelSettings: TLabel;
    PhraseMemo: TMemo;
    OpenGenerationBtn: TButton;
    SaveGenerationBtn: TButton;
    CloseProcessBtn: TButton;
    SaveWatcherLogBtn: TButton;
    ProcessWatchLabel: TLabel;
    ProcessWatcherMemo: TMemo;
    ProcessWatchwerTimer: TTimer;
    StopWatchSBtn: TSpeedButton;
    TempPhraseTab: TTabSheet;
    UpdateProcessBtn: TButton;
    ProcesInfoGroupBox: TGroupBox;
    ProcesInfoView: TListView;
    ResetTimeBtn: TButton;
    StartStopBtn: TSpeedButton;
    TimeLabel: TLabel;
    TimerForTime: TTimer;
    TimerSecGroup: TGroupBox;
    TabRaznoe: TTabSheet;
    ExistsFileCheck: TCheckBox;
    PhonePlusCheck: TCheckBox;
    EnHighRadio: TRadioButton;
    GenerationBtn: TButton;
    GenerationGroup: TGroupBox;
    MaxSymbolLabel: TLabel;
    MaxSymbolSpin: TSpinEdit;
    GenerationMemo: TMemo;
    PhoneRBtn: TRadioButton;
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
    procedure AllCheckChange(Sender: TObject);
    procedure FastPhraseBitBtnClick(Sender: TObject);
    procedure BtnPasteFromClipboardClick(Sender: TObject);
    procedure BtnPhraseClick(Sender: TObject);
    procedure BtnWordClick(Sender: TObject);
    procedure ClearBitBtnClick(Sender: TObject);
    procedure CloseProcessBtnClick(Sender: TObject);
    procedure CopyToClipBitBtnClick(Sender: TObject);
    procedure EMailRBtnChange(Sender: TObject);
    procedure EnAllRadioChange(Sender: TObject);
    procedure EngSymbolCheckChange(Sender: TObject);
    procedure EnHighRadioChange(Sender: TObject);
    procedure EnLowRadioChange(Sender: TObject);
    procedure FastPhrasesMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure GenerationBtnClick(Sender: TObject);
    procedure MakedPhrMenuItemClick(Sender: TObject);
    procedure MakePhraseBitBtnClick(Sender: TObject);
    procedure OpenGenerationBtnClick(Sender: TObject);
    procedure PhrasesMenuItemClick(Sender: TObject);
    procedure ProcesInfoViewDblClick(Sender: TObject);
    procedure ProcessWatchwerTimerTimer(Sender: TObject);
    procedure ResetTimeBtnClick(Sender: TObject);
    procedure SaveGenerationBtnClick(Sender: TObject);
    procedure SaveWatcherLogBtnClick(Sender: TObject);
    procedure StartStopBtnClick(Sender: TObject);
    procedure StopWatchSBtnClick(Sender: TObject);
    procedure TemplateComboBoxCloseUp(Sender: TObject);
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
    procedure WordsMenuItemClick(Sender: TObject);
    procedure ZipRBtnChange(Sender: TObject);
  private
    { private declarations }
    UsingSymbol,
    UsingType         : Byte;
    Secondomer        : TTime;
    HH,MM,SS,MS       : Word;
    WatcherProcessName,
    StartPath, TempStr: string;
    LastProcessMemory : integer;
    TempArray: Array [0..15] of integer;
    CountVisibleCB : integer;
    LastWordInPhrases : TStringList;
  public
    { public declarations }

  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var err, i: integer;
begin
 StartPath := ExtractFileDir(ParamStr(0)); // определяем  путь к программе
 {$IFDEF WINDOWS}
 if StartPath[Length(StartPath)] <> '\' then begin
   StartPath := StartPath + '\';
 end; // проверяем есть ли на конце строки "\"
 {$ELSE}
   StartPath := ParamStr(0);
   {$IFDEF UNIX}
     err := Pos('TesterHelper.app', StartPath);
     Delete(StartPath, err, (Length(StartPath) - err + 2) );
  {$ENDIF}
  {$IFDEF LINUX}
     err := Pos('TesterHelper/', StartPath);
     err := err+ 13;
     Delete(StartPath, err, 12 );
  {$ENDIF}
   err := 0;
 {$ENDIF}
 Randomize;
 InitilzationSymbol;
 UsingSymbol := 0;
 UsingType := 1;
 Secondomer := 0;
 TimeLabel.Caption := TimeToStr(Secondomer);
 PageControl.TabIndex := 0;
 WatcherProcessName := '';
 LastProcessMemory := 0;
 {$IFDEF WINDOWS}
  err := LoadDiscriptionInCB((StartPath + 'Phrases\' + '*.*'), TemplateComboBox);
 {$ELSE}
  err := LoadDiscriptionInCB((StartPath + 'Phrases/' + '*'), TemplateComboBox);
 {$ENDIF}
  if (err < 0) then begin
   ShowMessage('LoadDiscriptionInCB. Файлы в коталоге не найдены');
  end;
  LastWordInPhrases := TStringList.Create;
  {$IFDEF WINDOWS}
    LastWordInPhrases.LoadFromFile(StartPath + 'Data\LastWordInPhrases.txt');
  {$ELSE}
    LastWordInPhrases.LoadFromFile(StartPath + 'Data/LastWordInPhrases.txt');
  {$ENDIF}
  if LastWordInPhrases.Count <> TemplateComboBox.Items.Count then begin
    for i := LastWordInPhrases.Count to  TemplateComboBox.Items.Count do begin
     LastWordInPhrases.Add(IntToStr(i));
    end;
  end;
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

procedure TMainForm.MakedPhrMenuItemClick(Sender: TObject);
begin
  MakedPhrasesForm.ShowModal;
end;

procedure TMainForm.MakePhraseBitBtnClick(Sender: TObject);
var PosI, i: integer;
    PosStr: string;
begin
  if CountVisibleCB > 0 then begin
    case CountVisibleCB of
      1: begin
        if FirstTempCB.Text = '' then exit;
        if TempArray[0] < 10 then Delete(TempStr,TempArray[8],10)
        else Delete(TempStr,TempArray[8],11);
        Insert(FirstTempCB.Text, TempStr, TempArray[8]);
        LastWordInPhrases[TemplateComboBox.ItemIndex] := FirstTempCB.Text;
      end;
      2: begin
        if FirstTempCB.Text = '' then exit;
        if SecondTempCB.Text = '' then exit;
        if TempArray[0] < 10 then Delete(TempStr,TempArray[8],10)
        else Delete(TempStr,TempArray[8],11);
        Insert(FirstTempCB.Text, TempStr, TempArray[8]);
        PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[9] then TempArray[9] := PosI;
        Delete(TempStr,TempArray[9],Length(PosStr));
        Insert(SecondTempCB.Text, TempStr, TempArray[9]);
        LastWordInPhrases[TemplateComboBox.ItemIndex] := FirstTempCB.Text + '<1>' + SecondTempCB.Text + '<2>';
      end;
      3: begin
        if FirstTempCB.Text = '' then exit;
        if SecondTempCB.Text = '' then exit;
        if ThirdTempCB.Text = '' then exit;
        if TempArray[0] < 10 then Delete(TempStr,TempArray[8],10)
        else Delete(TempStr,TempArray[8],11);
        Insert(FirstTempCB.Text, TempStr, TempArray[8]);

        PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[9] then TempArray[9] := PosI;
        Delete(TempStr,TempArray[9],Length(PosStr));
        Insert(SecondTempCB.Text, TempStr, TempArray[9]);

        PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[10] then TempArray[10] := PosI;
        Delete(TempStr,TempArray[10],Length(PosStr));
        Insert(ThirdTempCB.Text, TempStr, TempArray[10]);
        LastWordInPhrases[TemplateComboBox.ItemIndex] := FirstTempCB.Text + '<1>' + SecondTempCB.Text + '<2>' + ThirdTempCB.Text + '<3>';
      end;
      4: begin
        if FirstTempCB.Text = '' then exit;
        if SecondTempCB.Text = '' then exit;
        if ThirdTempCB.Text = '' then exit;
        if FourthTempCB.Text = '' then exit;
        if TempArray[0] < 10 then Delete(TempStr,TempArray[8],10)
        else Delete(TempStr,TempArray[8],11);
        Insert(FirstTempCB.Text, TempStr, TempArray[8]);

        PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[9] then TempArray[9] := PosI;
        Delete(TempStr,TempArray[9],Length(PosStr));
        Insert(SecondTempCB.Text, TempStr, TempArray[9]);

        PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[10] then TempArray[10] := PosI;
        Delete(TempStr,TempArray[10],Length(PosStr));
        Insert(ThirdTempCB.Text, TempStr, TempArray[10]);

        PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[11] then TempArray[11] := PosI;
        Delete(TempStr,TempArray[11],Length(PosStr));
        Insert(FourthTempCB.Text, TempStr, TempArray[11]);
        LastWordInPhrases[TemplateComboBox.ItemIndex] := FirstTempCB.Text + '<1>' + SecondTempCB.Text + '<2>' + ThirdTempCB.Text + '<3>'  + FourthTempCB.Text + '<4>';
      end;
      5: begin
        if FirstTempCB.Text = '' then exit;
        if SecondTempCB.Text = '' then exit;
        if ThirdTempCB.Text = '' then exit;
        if FourthTempCB.Text = '' then exit;
        if FifthTempCB.Text = '' then exit;
        if TempArray[0] < 10 then Delete(TempStr,TempArray[8],10)
        else Delete(TempStr,TempArray[8],11);
        Insert(FirstTempCB.Text, TempStr, TempArray[8]);

        PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[9] then TempArray[9] := PosI;
        Delete(TempStr,TempArray[9],Length(PosStr));
        Insert(SecondTempCB.Text, TempStr, TempArray[9]);

        PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[10] then TempArray[10] := PosI;
        Delete(TempStr,TempArray[10],Length(PosStr));
        Insert(ThirdTempCB.Text, TempStr, TempArray[10]);

        PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[11] then TempArray[11] := PosI;
        Delete(TempStr,TempArray[11],Length(PosStr));
        Insert(FourthTempCB.Text, TempStr, TempArray[11]);

        PosStr := '<PhTemp' + IntToStr(TempArray[4]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[4]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[12] then TempArray[12] := PosI;
        Delete(TempStr,TempArray[12],Length(PosStr));
        Insert(FifthTempCB.Text, TempStr, TempArray[12]);
        LastWordInPhrases[TemplateComboBox.ItemIndex] := FirstTempCB.Text + '<1>' + SecondTempCB.Text + '<2>' + ThirdTempCB.Text + '<3>'  + FourthTempCB.Text + '<4>' + FifthTempCB.Text + '<5>';
      end;
      6: begin
        if FirstTempCB.Text = '' then exit;
        if SecondTempCB.Text = '' then exit;
        if ThirdTempCB.Text = '' then exit;
        if FourthTempCB.Text = '' then exit;
        if FifthTempCB.Text = '' then exit;
        if SixthTempCB.Text = '' then exit;
        if TempArray[0] < 10 then Delete(TempStr,TempArray[8],10)
        else Delete(TempStr,TempArray[8],11);
        Insert(FirstTempCB.Text, TempStr, TempArray[8]);
        PosI := -1;
        PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '/>';
        PosI := pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[9] then TempArray[9] := PosI;
        Delete(TempStr,TempArray[9],Length(PosStr));
        Insert(SecondTempCB.Text, TempStr, TempArray[9]);

        PosI := -1;
        PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[10] then TempArray[10] := PosI;
        Delete(TempStr,TempArray[10],Length(PosStr));
        Insert(ThirdTempCB.Text, TempStr, TempArray[10]);

        PosI := -1;
        PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[11] then TempArray[11] := PosI;
        Delete(TempStr,TempArray[11],Length(PosStr));
        Insert(FourthTempCB.Text, TempStr, TempArray[11]);

        PosI := -1;
        PosStr := '<PhTemp' + IntToStr(TempArray[4]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[4]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[12] then TempArray[12] := PosI;
        Delete(TempStr,TempArray[12],Length(PosStr));
        Insert(FifthTempCB.Text, TempStr, TempArray[12]);

        PosI := -1;
        PosStr := '<PhTemp' + IntToStr(TempArray[5]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          PosI := -1;
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[5]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[13] then TempArray[13] := PosI;
        Delete(TempStr,TempArray[13],Length(PosStr));
        Insert(SixthTempCB.Text, TempStr, TempArray[13]);
        LastWordInPhrases[TemplateComboBox.ItemIndex] := FirstTempCB.Text + '<1>' + SecondTempCB.Text + '<2>' + ThirdTempCB.Text + '<3>'  + FourthTempCB.Text + '<4>' + FifthTempCB.Text + '<5>' + SixthTempCB.Text + '<6>';
      end;
      7: begin
        if FirstTempCB.Text = '' then exit;
        if SecondTempCB.Text = '' then exit;
        if ThirdTempCB.Text = '' then exit;
        if FourthTempCB.Text = '' then exit;
        if FifthTempCB.Text = '' then exit;
        if SixthTempCB.Text = '' then exit;
        if SeventhTempCB.Text = '' then exit;
        if TempArray[0] < 10 then Delete(TempStr,TempArray[8],10)
        else Delete(TempStr,TempArray[8],11);
        Insert(FirstTempCB.Text, TempStr, TempArray[8]);

        PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[9] then TempArray[9] := PosI;
        Delete(TempStr,TempArray[9],Length(PosStr));
        Insert(SecondTempCB.Text, TempStr, TempArray[9]);

        PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[10] then TempArray[10] := PosI;
        Delete(TempStr,TempArray[10],Length(PosStr));
        Insert(ThirdTempCB.Text, TempStr, TempArray[10]);

        PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[11] then TempArray[11] := PosI;
        Delete(TempStr,TempArray[11],Length(PosStr));
        Insert(FourthTempCB.Text, TempStr, TempArray[11]);

        PosStr := '<PhTemp' + IntToStr(TempArray[4]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[4]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[12] then TempArray[12] := PosI;
        Delete(TempStr,TempArray[12],Length(PosStr));
        Insert(FifthTempCB.Text, TempStr, TempArray[12]);

        PosStr := '<PhTemp' + IntToStr(TempArray[5]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[5]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[13] then TempArray[13] := PosI;
        Delete(TempStr,TempArray[13],Length(PosStr));
        Insert(SixthTempCB.Text, TempStr, TempArray[13]);

        PosStr := '<PhTemp' + IntToStr(TempArray[6]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[6]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[14] then TempArray[14] := PosI;
        Delete(TempStr,TempArray[14],Length(PosStr));
        Insert(SeventhTempCB.Text, TempStr, TempArray[14]);
        LastWordInPhrases[TemplateComboBox.ItemIndex] := FirstTempCB.Text + '<1>' + SecondTempCB.Text + '<2>' + ThirdTempCB.Text + '<3>'  + FourthTempCB.Text + '<4>' + FifthTempCB.Text + '<5>' + SixthTempCB.Text + '<6>' + SeventhTempCB.Text +'<7>';
      end;
      8: begin
        if FirstTempCB.Text = '' then exit;
        if SecondTempCB.Text = '' then exit;
        if ThirdTempCB.Text = '' then exit;
        if FourthTempCB.Text = '' then exit;
        if FifthTempCB.Text = '' then exit;
        if SixthTempCB.Text = '' then exit;
        if SeventhTempCB.Text = '' then exit;
        if EigthTempCB.Text = '' then exit;
        if TempArray[0] < 10 then Delete(TempStr,TempArray[8],10)
        else Delete(TempStr,TempArray[8],11);
        Insert(FirstTempCB.Text, TempStr, TempArray[8]);

        PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[1]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[9] then TempArray[9] := PosI;
        Delete(TempStr,TempArray[9],Length(PosStr));
        Insert(SecondTempCB.Text, TempStr, TempArray[9]);

        PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[2]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[10] then TempArray[10] := PosI;
        Delete(TempStr,TempArray[10],Length(PosStr));
        Insert(ThirdTempCB.Text, TempStr, TempArray[10]);

        PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[3]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[11] then TempArray[11] := PosI;
        Delete(TempStr,TempArray[11],Length(PosStr));
        Insert(FourthTempCB.Text, TempStr, TempArray[11]);

        PosStr := '<PhTemp' + IntToStr(TempArray[4]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[4]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            Inc(i);
            if i > 7 then break;
          end;
        end;
        if PosI <> TempArray[12] then TempArray[12] := PosI;
        Delete(TempStr,TempArray[12],Length(PosStr));
        Insert(FifthTempCB.Text, TempStr, TempArray[12]);

        PosStr := '<PhTemp' + IntToStr(TempArray[5]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[5]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            if PosI > 0 then break;
            Inc(i);
          end;
        end;
        if PosI <> TempArray[13] then TempArray[13] := PosI;
        Delete(TempStr,TempArray[13],Length(PosStr));
        Insert(SixthTempCB.Text, TempStr, TempArray[13]);

        PosStr := '<PhTemp' + IntToStr(TempArray[6]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[6]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            if PosI > 0 then break;
            Inc(i);
          end;
        end;
        if PosI <> TempArray[14] then TempArray[14] := PosI;
        Delete(TempStr,TempArray[14],Length(PosStr));
        Insert(SeventhTempCB.Text, TempStr, TempArray[14]);

        PosStr := '<PhTemp' + IntToStr(TempArray[7]) + '/>';
        PosI := Pos(PosStr,TempStr);
        if PosI = 0 then begin
          i := 1;
          while PosI < 1 do begin
            PosStr := '<PhTemp' + IntToStr(TempArray[7]) + '_' + IntToStr(i) + '/>';
            PosI := Pos(PosStr,TempStr);
            if PosI > 0 then break;
            Inc(i);
          end;
        end;
        if PosI <> TempArray[15] then TempArray[15] := PosI;
        Delete(TempStr,TempArray[15],Length(PosStr));
        Insert(EigthTempCB.Text, TempStr, TempArray[15]);
        LastWordInPhrases[TemplateComboBox.ItemIndex] := FirstTempCB.Text + '<1>' + SecondTempCB.Text + '<2>' + ThirdTempCB.Text + '<3>'  + FourthTempCB.Text + '<4>' + FifthTempCB.Text + '<5>' + SixthTempCB.Text + '<6>' + SeventhTempCB.Text +'<7>'+ EigthTempCB.Text + '<8>';
      end;
      else begin
        ShowMessage('MakePhraseBitBtnClick. Неправльное количество CountVisibleCB: ' + IntToStr(CountVisibleCB));
      end;
    end;
    TempStr := Trim(TempStr);
    PhraseMemo.Lines.Clear;
    PhraseMemo.Lines.Add(TempStr);
    PhraseMemo.SelectAll;
    PhraseMemo.CopyToClipboard;
    MakedPhrasesForm.SL_MakedPhrases.AddStrings(PhraseMemo.Lines);
    PhraseMemo.SetFocus;
  end;
end;

procedure TMainForm.OpenGenerationBtnClick(Sender: TObject);
begin
 {$IFDEF WINDOWS}
  GenerationMemo.Lines.LoadFromFile(StartPath+ '\Generation\genstr.txt');
 {$ELSE}
   GenerationMemo.Lines.LoadFromFile(StartPath+ '/Generation/genstr.txt');
 {$ENDIF}
end;

procedure TMainForm.PhrasesMenuItemClick(Sender: TObject);
begin
  MainForm.BtnPhraseClick(Self);
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
  {$IFDEF WINDOWS}
    LogStr := ProcessWatcherLog(LastProcessMemory, WatcherProcessName);
  {$ENDIF}
  if LogStr <> '' then ProcessWatcherMemo.Lines.Add(LogStr);
end;

procedure TMainForm.ResetTimeBtnClick(Sender: TObject);
begin
  Secondomer := 0;
  TimeLabel.Caption := TimeToStr(Secondomer);
end;

procedure TMainForm.SaveGenerationBtnClick(Sender: TObject);
begin
 {$IFDEF WINDOWS}
  GenerationMemo.Lines.SaveToFile(StartPath+ '\Generation\genstr.txt');
 {$ELSE}
   GenerationMemo.Lines.SaveToFile(StartPath+ '/Generation/genstr.txt');
 {$ENDIF}
  SaveGenerationBtn.Enabled := False;
end;

procedure TMainForm.SaveWatcherLogBtnClick(Sender: TObject);
begin
 if ProcessWatcherMemo.Lines.Count > 0 then begin
  {$IFDEF WINDOWS}
    ProcessWatcherMemo.Lines.SaveToFile(StartPath + '\Watch\' +
                                                WatcherProcessName + '.txt');
  {$ELSE}
    ProcessWatcherMemo.Lines.SaveToFile(StartPath + '/Watch/' +
                                                WatcherProcessName + '.txt');
  {$ENDIF}
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

procedure TMainForm.TemplateComboBoxCloseUp(Sender: TObject);
var i, j, PosI, ArrPos, iDoubleTemp: integer;
    PosStr: string;
    FileSearch: TSearchRec;
    Attr : integer;
    TempList: TStringList;
begin
  if TemplateComboBox.ItemIndex <> -1 then begin
    CountVisibleCB := 0;
    TempList := TStringList.Create;
    //Скрываем все комбобоксы и очищаем их
    FirstCBTemplLabel.Visible := false;
    FirstTempCB.Visible := false;
    FirstTempCB.Clear;
    SecondCBTemplLabel.Visible := false;
    SecondTempCB.Visible := false;
    SecondTempCB.Clear;
    ThirdCBTemplLabel.Visible := false;
    ThirdTempCB.Visible := false;
    ThirdTempCB.Clear;
    FourthCBTemplLabel.Visible := false;
    FourthTempCB.Visible := false;
    FourthTempCB.Clear;
    FifthCBTemplLabel.Visible := false;
    FifthTempCB.Visible := false;
    FifthTempCB.Clear;
    SixthCBTemplLabel.Visible := false;
    SixthTempCB.Visible := false;
    SixthTempCB.Clear;
    SeventhCBTemplLabel.Visible := false;
    SeventhTempCB.Visible := false;
    SeventhTempCB.Clear;
    EigthCBTemplLabel.Visible := false;
    EigthTempCB.Visible := false;
    EigthTempCB.Clear;
    Attr := faAnyFile - faDirectory;
    // Загрузить шаблон из файла
    {$IFDEF WINDOWS}
      PosStr := StartPath + 'Phrases\' +  PhraseTemplateForm.TamplatePhrasesComboBox.items[TemplateComboBox.ItemIndex];
    {$ELSE}
      PosStr := StartPath + 'Phrases/' +  PhraseTemplateForm.TamplatePhrasesComboBox.items[TemplateComboBox.ItemIndex];
    {$ENDIF}
    if FindFirst(PosStr, Attr, FileSearch) = 0 then begin
      if FileSearch.Size > 0 then begin
        {$IFDEF WINDOWS}
          TempList.LoadFromFile((StartPath + 'Phrases\' + PhraseTemplateForm.TamplatePhrasesComboBox.items[TemplateComboBox.ItemIndex]));
        {$ELSE}
          TempList.LoadFromFile((StartPath + 'Phrases/' + PhraseTemplateForm.TamplatePhrasesComboBox.items[TemplateComboBox.ItemIndex]));
        {$ENDIF}
        if TempList.Count > 0 then begin
           TempList.Delete(0);
           TempStr := TempList.Text;
         end;
      end else begin
       ShowMessage('Выбранный файл пуст.');
      end;
    end;
    FindClose(FileSearch);
    if Length(TempStr) > 2 then begin
      PosStr := '';
      for i:= 0 to 15 do begin
        TempArray[i] := 0;
      end;
      j := 0; ArrPos :=  8;
      for i:= 0 to (StringsParamForm.NameListComboBox.Items.Count - 1) do begin
         PosI := -1;
         PosStr := '<PhTemp' +IntToStr(i)+ '/>';
         PosI := pos(PosStr,TempStr);
         if PosI > 0 then begin
           TempArray[j] := i;
           TempArray[ArrPos] := PosI;
           Inc(CountVisibleCB);
           Inc(j);
           Inc(ArrPos);
         end;
         PosI := -1;
         iDoubleTemp :=1;
         PosStr := '<PhTemp' +IntToStr(i)+ '_' + IntToStr(iDoubleTemp) + '/>';
         PosI := Pos(PosStr, TempStr);
         while PosI > 0 do begin
           TempArray[j] := i;
           TempArray[ArrPos] := PosI;
           Inc(CountVisibleCB);
           Inc(j);
           Inc(ArrPos);
           Inc(iDoubleTemp);
           PosStr := '<PhTemp' + IntToStr(i) + '_' + IntToStr(iDoubleTemp) + '/>';
           PosI := Pos(PosStr, TempStr);
         end;
      end;
      case CountVisibleCB of
        1: begin
         FirstCBTemplLabel.Visible := true;
         FirstTempCB.Visible := true;
         FirstCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[0]];
         if LastWordInPhrases[TemplateComboBox.ItemIndex].Length > 2 then begin
           FirstTempCB.Text:= LastWordInPhrases[TemplateComboBox.ItemIndex];
         end;
         {$IFDEF MSWINDOWS}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ELSE}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ENDIF}
        end;
        2: begin
         FirstCBTemplLabel.Visible := true;
         FirstTempCB.Visible := true;
         SecondCBTemplLabel.Visible := true;
         SecondTempCB.Visible := true;
         FirstCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[0]];
         if LastWordInPhrases[TemplateComboBox.ItemIndex].Length > 2 then begin
           PosI := Pos('<1>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], 0, (PosI-1));
           FirstTempCB.Text:= PosStr;
           i := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SecondTempCB.Text:= PosStr;
         end;
         {$IFDEF MSWINDOWS}
          FirstTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ELSE}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ENDIF}
           SecondCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[1]];
         {$IFDEF MSWINDOWS}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ELSE}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ENDIF}
        end;
        3: begin
         FirstCBTemplLabel.Visible := true;
         FirstTempCB.Visible := true;
         SecondCBTemplLabel.Visible := true;
         SecondTempCB.Visible := true;
         ThirdCBTemplLabel.Visible := true;
         ThirdTempCB.Visible := true;
         FirstCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[0]];
         if LastWordInPhrases[TemplateComboBox.ItemIndex].Length > 2 then begin
           PosI := Pos('<1>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], 0, (PosI-1));
           FirstTempCB.Text:= PosStr;
           i := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SecondTempCB.Text:= PosStr;
           PosI := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           ThirdTempCB.Text:= PosStr;
         end;
         {$IFDEF MSWINDOWS}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ELSE}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ENDIF}
         SecondCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[1]];
         {$IFDEF MSWINDOWS}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ELSE}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ENDIF}
         ThirdCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[2]];
         {$IFDEF MSWINDOWS}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ELSE}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ENDIF}
        end;
        4: begin
         FirstCBTemplLabel.Visible := true;
         FirstTempCB.Visible := true;
         SecondCBTemplLabel.Visible := true;
         SecondTempCB.Visible := true;
         ThirdCBTemplLabel.Visible := true;
         ThirdTempCB.Visible := true;
         FourthCBTemplLabel.Visible := true;
         FourthTempCB.Visible := true;
         FirstCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[0]];
         if LastWordInPhrases[TemplateComboBox.ItemIndex].Length > 2 then begin
           PosI := Pos('<1>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], 0, (PosI-1));
           FirstTempCB.Text:= PosStr;
           i := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SecondTempCB.Text:= PosStr;
           PosI := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           ThirdTempCB.Text:= PosStr;
           PosI := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FourthTempCB.Text:= PosStr;
         end;
         {$IFDEF MSWINDOWS}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ELSE}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ENDIF}
         SecondCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[1]];
         {$IFDEF MSWINDOWS}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ELSE}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ENDIF}
         ThirdCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[2]];
         {$IFDEF MSWINDOWS}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ELSE}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ENDIF}
         FourthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[3]];
         {$IFDEF MSWINDOWS}
            FourthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ELSE}
            FourthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ENDIF}
        end;
        5: begin
         FirstCBTemplLabel.Visible := true;
         FirstTempCB.Visible := true;
         SecondCBTemplLabel.Visible := true;
         SecondTempCB.Visible := true;
         ThirdCBTemplLabel.Visible := true;
         ThirdTempCB.Visible := true;
         FourthCBTemplLabel.Visible := true;
         FourthTempCB.Visible := true;
         FifthCBTemplLabel.Visible := true;
         FifthTempCB.Visible := true;
         FirstCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[0]];
         if LastWordInPhrases[TemplateComboBox.ItemIndex].Length > 2 then begin
           PosI := Pos('<1>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], 0, (PosI-1));
           FirstTempCB.Text:= PosStr;
           i := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SecondTempCB.Text:= PosStr;
           PosI := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           ThirdTempCB.Text:= PosStr;
           PosI := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FourthTempCB.Text:= PosStr;
           PosI := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<5>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FifthTempCB.Text:= PosStr;
         end;
         {$IFDEF MSWINDOWS}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ELSE}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ENDIF}
           SecondCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[1]];
         {$IFDEF MSWINDOWS}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ELSE}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ENDIF}
         ThirdCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[2]];
         {$IFDEF MSWINDOWS}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ELSE}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ENDIF}
         FourthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[3]];
         {$IFDEF MSWINDOWS}
           FourthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ELSE}
           FourthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ENDIF}
          FifthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[4]];
         {$IFDEF MSWINDOWS}
           FifthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[4]]);
         {$ELSE}
           FifthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[4]]);
         {$ENDIF}
        end;
        6: begin
         FirstCBTemplLabel.Visible := true;
         FirstTempCB.Visible := true;
         SecondCBTemplLabel.Visible := true;
         SecondTempCB.Visible := true;
         ThirdCBTemplLabel.Visible := true;
         ThirdTempCB.Visible := true;
         FourthCBTemplLabel.Visible := true;
         FourthTempCB.Visible := true;
         FifthCBTemplLabel.Visible := true;
         FifthTempCB.Visible := true;
         SixthCBTemplLabel.Visible := true;
         SixthTempCB.Visible := true;
         FirstCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[0]];
         if LastWordInPhrases[TemplateComboBox.ItemIndex].Length > 2 then begin
           PosI := Pos('<1>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], 0, (PosI-1));
           FirstTempCB.Text:= PosStr;
           i := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SecondTempCB.Text:= PosStr;
           PosI := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           ThirdTempCB.Text:= PosStr;
           PosI := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FourthTempCB.Text:= PosStr;
           PosI := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<5>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FifthTempCB.Text:= PosStr;
           PosI := Pos('<5>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<6>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SixthTempCB.Text:= PosStr;
         end;
         {$IFDEF MSWINDOWS}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ELSE}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ENDIF}
           SecondCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[1]];
         {$IFDEF MSWINDOWS}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ELSE}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ENDIF}
         ThirdCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[2]];
         {$IFDEF MSWINDOWS}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ELSE}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ENDIF}
         FourthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[3]];
         {$IFDEF MSWINDOWS}
           FourthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ELSE}
           FourthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ENDIF}
          FifthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[4]];
         {$IFDEF MSWINDOWS}
           FifthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[4]]);
         {$ELSE}
           FifthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[4]]);
         {$ENDIF}
         SixthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[5]];
         {$IFDEF MSWINDOWS}
           SixthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[5]]);
         {$ELSE}
           SixthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[5]]);
         {$ENDIF}
        end;
        7: begin
         FirstCBTemplLabel.Visible := true;
         FirstTempCB.Visible := true;
         SecondCBTemplLabel.Visible := true;
         SecondTempCB.Visible := true;
         ThirdCBTemplLabel.Visible := true;
         ThirdTempCB.Visible := true;
         FourthCBTemplLabel.Visible := true;
         FourthTempCB.Visible := true;
         FifthCBTemplLabel.Visible := true;
         FifthTempCB.Visible := true;
         SixthCBTemplLabel.Visible := true;
         SixthTempCB.Visible := true;
         SeventhCBTemplLabel.Visible := true;
         SeventhTempCB.Visible := true;
         if LastWordInPhrases[TemplateComboBox.ItemIndex].Length > 2 then begin
           PosI := Pos('<1>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], 0, (PosI-1));
           FirstTempCB.Text:= PosStr;
           i := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SecondTempCB.Text:= PosStr;
           PosI := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           ThirdTempCB.Text:= PosStr;
           PosI := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FourthTempCB.Text:= PosStr;
           PosI := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<5>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FifthTempCB.Text:= PosStr;
           PosI := Pos('<5>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<6>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SixthTempCB.Text:= PosStr;
           PosI := Pos('<6>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<7>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SeventhTempCB.Text:= PosStr;
         end;
         {$IFDEF MSWINDOWS}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ELSE}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ENDIF}
           SecondCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[1]];
         {$IFDEF MSWINDOWS}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ELSE}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ENDIF}
         ThirdCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[2]];
         {$IFDEF MSWINDOWS}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ELSE}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ENDIF}
         FourthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[3]];
         {$IFDEF MSWINDOWS}
           FourthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ELSE}
           FourthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ENDIF}
          FifthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[4]];
         {$IFDEF MSWINDOWS}
           FifthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[4]]);
         {$ELSE}
           FifthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[4]]);
         {$ENDIF}
         SixthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[5]];
         {$IFDEF MSWINDOWS}
           SixthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[5]]);
         {$ELSE}
           SixthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[5]]);
         {$ENDIF}
         SeventhCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[6]];
         {$IFDEF MSWINDOWS}
           SeventhTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[6]]);
         {$ELSE}
           SeventhTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[6]]);
         {$ENDIF}
        end;
        8: begin
         FirstCBTemplLabel.Visible := true;
         FirstTempCB.Visible := true;
         SecondCBTemplLabel.Visible := true;
         SecondTempCB.Visible := true;
         ThirdCBTemplLabel.Visible := true;
         ThirdTempCB.Visible := true;
         FourthCBTemplLabel.Visible := true;
         FourthTempCB.Visible := true;
         FifthCBTemplLabel.Visible := true;
         FifthTempCB.Visible := true;
         SixthCBTemplLabel.Visible := true;
         SixthTempCB.Visible := true;
         SeventhCBTemplLabel.Visible := true;
         SeventhTempCB.Visible := true;
         EigthCBTemplLabel.Visible := true;
         EigthTempCB.Visible := true;
         FirstCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[0]];
         if LastWordInPhrases[TemplateComboBox.ItemIndex].Length > 2 then begin
           PosI := Pos('<1>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], 0, (PosI-1));
           FirstTempCB.Text:= PosStr;
           i := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SecondTempCB.Text:= PosStr;
           PosI := Pos('<2>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           ThirdTempCB.Text:= PosStr;
           PosI := Pos('<3>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FourthTempCB.Text:= PosStr;
           PosI := Pos('<4>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<5>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           FifthTempCB.Text:= PosStr;
           PosI := Pos('<5>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<6>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SixthTempCB.Text:= PosStr;
           PosI := Pos('<6>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<7>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           SeventhTempCB.Text:= PosStr;
           PosI := Pos('<7>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           i := Pos('<8>', LastWordInPhrases[TemplateComboBox.ItemIndex]);
           PosStr := Copy(LastWordInPhrases[TemplateComboBox.ItemIndex], (PosI + 3), (i-(PosI+3)));
           EigthTempCB.Text:= PosStr;
         end;
         {$IFDEF MSWINDOWS}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ELSE}
           FirstTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[0]]);
         {$ENDIF}
           SecondCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[1]];
         {$IFDEF MSWINDOWS}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ELSE}
           SecondTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[1]]);
         {$ENDIF}
         ThirdCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[2]];
         {$IFDEF MSWINDOWS}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ELSE}
           ThirdTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[2]]);
         {$ENDIF}
         FourthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[3]];
         {$IFDEF MSWINDOWS}
           FourthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ELSE}
           FourthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[3]]);
         {$ENDIF}
          FifthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[4]];
         {$IFDEF MSWINDOWS}
           FifthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[4]]);
         {$ELSE}
           FifthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[4]]);
         {$ENDIF}
         SixthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[5]];
         {$IFDEF MSWINDOWS}
           SixthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[5]]);
         {$ELSE}
           SixthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[5]]);
         {$ENDIF}
         SeventhCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[6]];
         {$IFDEF MSWINDOWS}
           SeventhTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[6]]);
         {$ELSE}
           SeventhTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[6]]);
         {$ENDIF}
         EigthCBTemplLabel.Caption := StringsParamForm.NameListComboBox.Items[TempArray[7]];
         {$IFDEF MSWINDOWS}
           EigthTempCB.Items.LoadFromFile(StartPath + 'List\' + StringsParamForm.NameListComboBox.Items[TempArray[7]]);
         {$ELSE}
           EigthTempCB.Items.LoadFromFile(StartPath + 'List/' + StringsParamForm.NameListComboBox.Items[TempArray[7]]);
         {$ENDIF}
        end;
        else begin
          PhraseMemo.Lines.Add(TempStr);
        end;
      end;

    end else begin
      PhraseMemo.Lines.Clear;
      PhraseMemo.Lines.Add(TempStr);
      PhraseMemo.SelectAll;
      PhraseMemo.CopyToClipboard;
      ShowMessage('Строка шаблона очень маленькая: ' + TempStr);
    end;
    TempList.Free;
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
 {$IFDEF WINDOWS}
  if not FillProcessesList() then begin // Заполняем список процессов
   ShowMessage('Ошибка. Не могу получить список процессов.');
  end;
 {$ENDIF}
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

procedure TMainForm.FastPhraseBitBtnClick(Sender: TObject);
begin
  //Открытие формы с быстрыми фразами
  if FastPhraseBitBtn.Caption = '>>' then begin
    FastPhrasesForm.Show;
    FastPhraseBitBtn.Caption := '<<';
  end else begin
    FastPhrasesForm.Close;
    FastPhraseBitBtn.Caption := '>>';
  end;

end;

procedure TMainForm.BtnPasteFromClipboardClick(Sender: TObject);
begin
  //Кнопка вставки из буфера обмена
  if PhraseMemo.Lines.Count > 0 then begin
    PhraseMemo.SelectAll;
    PhraseMemo.PasteFromClipboard;
  end else begin
    PhraseMemo.PasteFromClipboard;
  end;
end;

procedure TMainForm.BtnPhraseClick(Sender: TObject);
var err: integer;
begin
  if PhraseTemplateForm.ShowModal = mrOK then begin
   TemplateComboBox.Items.Clear;
   {$IFDEF MSWINDOWS}
     err := LoadDiscriptionInCB((StartPath + 'Phrases\*.*'), TemplateComboBox);
   {$ELSE}
     err := LoadDiscriptionInCB((StartPath + 'Phrases/*'), TemplateComboBox);
   {$ENDIF}

   if (err < 0) then begin
     ShowMessage('LoadNameListInString. Файлы в коталоге не найдены');
   end;
  end;
end;

procedure TMainForm.BtnWordClick(Sender: TObject);
begin
  StringsParamForm.ShowModal;
end;

procedure TMainForm.ClearBitBtnClick(Sender: TObject);
begin
  if PhraseMemo.Lines.Count = 0 then exit;
  PhraseMemo.Lines.Clear;
end;

procedure TMainForm.CloseProcessBtnClick(Sender: TObject);
Var iKillErr: integer;
begin
 if ProcesInfoView.Selected <> nil then begin
  {$IFDEF WINDOWS}
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
  {$ENDIF}
 end else begin
  ShowMessage('Не Выбран Процесс!');
 end;
end;

procedure TMainForm.CopyToClipBitBtnClick(Sender: TObject);
begin
 if PhraseMemo.Lines.Count > 0 then begin
  PhraseMemo.SelectAll;
  PhraseMemo.CopyToClipboard;
  if PhraseMemo.Lines[PhraseMemo.Lines.Count-1] <> MakedPhrasesForm.SL_MakedPhrases[MakedPhrasesForm.SL_MakedPhrases.Count-1] then begin
   MakedPhrasesForm.SL_MakedPhrases.AddStrings(PhraseMemo.Lines);
  end;
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

procedure TMainForm.FastPhrasesMenuItemClick(Sender: TObject);
begin
  MainForm.FastPhraseBitBtnClick(Self);
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 {$IFDEF WINDOWS}
   LastWordInPhrases.SaveToFile(StartPath + 'Data\LastWordInPhrases.txt');
 {$ELSE}
   LastWordInPhrases.SaveToFile(StartPath + 'Data/LastWordInPhrases.txt');
 {$ENDIF}
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

procedure TMainForm.WordsMenuItemClick(Sender: TObject);
begin
  MainForm.BtnWordClick(Self);
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
