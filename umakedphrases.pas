unit uMakedPhrases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TMakedPhrasesForm }

  TMakedPhrasesForm = class(TForm)
    AddPhraseFromClipboardBitBtn: TBitBtn;
    CopySelectedPraseBitBtn: TBitBtn;
    CloseFprmBitBtn: TBitBtn;
    MakedPrasesListBox: TListBox;
    procedure AddPhraseFromClipboardBitBtnClick(Sender: TObject);
    procedure CopySelectedPraseBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    StartPath: string;
  public
    SL_MakedPhrases : TStringList;
  end;

var
  MakedPhrasesForm: TMakedPhrasesForm;
  TempMemo: TMemo;

implementation

{$R *.lfm}

{ TMakedPhrasesForm }

procedure TMakedPhrasesForm.FormCreate(Sender: TObject);
var err: integer;
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
   SL_MakedPhrases := TStringList.Create;
  {$IFDEF WINDOWS}
    SL_MakedPhrases.LoadFromFile(StartPath + 'Data\MakedPhrases.txt');
  {$ELSE}
    SL_MakedPhrases.LoadFromFile(StartPath + 'Data/MakedPhrases.txt');
  {$ENDIF}
  MakedPrasesListBox.Items := SL_MakedPhrases;
end;

procedure TMakedPhrasesForm.FormShow(Sender: TObject);
begin
  TempMemo := TMemo.Create(self);
  TempMemo.Parent := MakedPhrasesForm;
  TempMemo.Left := MakedPhrasesForm.Width + 5;
  if MakedPrasesListBox.Items.Count <> SL_MakedPhrases.Count then begin
    MakedPrasesListBox.Items.Clear;
    MakedPrasesListBox.Items := SL_MakedPhrases;
  end;
end;

procedure TMakedPhrasesForm.CopySelectedPraseBitBtnClick(Sender: TObject);
begin
  if MakedPrasesListBox.GetSelectedText <> '' then begin
    if TempMemo.Lines.Count > 0 then TempMemo.Lines.Clear;
    TempMemo.Lines.Add(MakedPrasesListBox.GetSelectedText);
    TempMemo.SetFocus;
    TempMemo.SelectAll;
    TempMemo.CopyToClipboard;
  end;
end;

procedure TMakedPhrasesForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if SL_MakedPhrases.Count < MakedPrasesListBox.Items.Count then begin
    MakedPrasesListBox.Items := SL_MakedPhrases;
  end;
  if SL_MakedPhrases.Count > 500 then begin
    while SL_MakedPhrases.Count > 500 do begin
      SL_MakedPhrases.Delete(0);
    end;
  end;
  {$IFDEF WINDOWS}
    SL_MakedPhrases.SaveToFile(StartPath + 'Data\MakedPhrases.txt');
  {$ELSE}
    SL_MakedPhrases.SaveToFile(StartPath + 'Data/MakedPhrases.txt');
  {$ENDIF}
  TempMemo.Free;
end;

procedure TMakedPhrasesForm.AddPhraseFromClipboardBitBtnClick(Sender: TObject);
begin
  if TempMemo.Lines.Count > 0 then TempMemo.Lines.Clear;
  TempMemo.PasteFromClipboard;
  if MakedPrasesListBox.Items[MakedPrasesListBox.Items.Count-1] = TempMemo.Lines[TempMemo.Lines.Count-1] then begin
   exit;
  end;
  SL_MakedPhrases.AddStrings(TempMemo.Lines);
  MakedPrasesListBox.Items.AddStrings(TempMemo.Lines);
end;

end.

