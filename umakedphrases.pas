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
  TempMemo := TMemo.Create(self);
  TempMemo.Parent := MakedPhrasesForm;
  TempMemo.Left := MakedPhrasesForm.Width + 10;
end;

procedure TMakedPhrasesForm.FormShow(Sender: TObject);
begin
  TempMemo := TMemo.Create(self);
  TempMemo.Parent := MakedPhrasesForm;
  TempMemo.Left := MakedPhrasesForm.Width + 10;
  if MakedPrasesListBox.Items.Count <> SL_MakedPhrases.Count then begin
    MakedPrasesListBox.Items.Clear;
    MakedPrasesListBox.Items := SL_MakedPhrases;
  end;
end;

procedure TMakedPhrasesForm.CopySelectedPraseBitBtnClick(Sender: TObject);
var SelText: String;
begin
  SelText := '';
  SelText := MakedPrasesListBox.GetSelectedText;
  if SelText <> '' then begin
    if TempMemo.Lines.Count > 0 then TempMemo.Lines.Clear;
    TempMemo.Lines.Add(SelText);
    TempMemo.SetFocus;
    TempMemo.SelectAll;
    TempMemo.CopyToClipboard;
  end;
end;


procedure TMakedPhrasesForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if SL_MakedPhrases.Count < MakedPrasesListBox.Items.Count then begin
    SL_MakedPhrases.Clear;
    SL_MakedPhrases.AddStrings(MakedPrasesListBox.Items);
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
{$IFDEF UNIX}
var LastLbstring, LastMemoString: string;
  CountofString: integer;
{$ENDIF}
begin
  if TempMemo.Lines.Count > 0 then TempMemo.Lines.Clear;
  TempMemo.SetFocus;
  TempMemo.PasteFromClipboard;
  {$IFDEF UNIX}
  CountofString := 0;
  CountofString := MakedPrasesListBox.Items.Count;
  LastLbstring := '';
  LastLbstring := MakedPrasesListBox.Items[CountofString-1];
  CountofString := TempMemo.Lines.Count;
  LastMemoString := '';
  LastMemoString := TempMemo.Lines[CountofString-1];
  if LastLbstring = LastMemoString then begin
   exit;
  end;
  {$ELSE}
   if MakedPrasesListBox.Items[MakedPrasesListBox.Items.Count-1] = TempMemo.Lines[TempMemo.Lines.Count-1] then begin
      exit;
   end;
  {$ENDIF}
  SL_MakedPhrases.AddStrings(TempMemo.Lines);
  MakedPrasesListBox.Items.AddStrings(TempMemo.Lines);
end;

end.

