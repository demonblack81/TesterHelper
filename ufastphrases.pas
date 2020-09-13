unit uFastPhrases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Buttons,
  CheckLst, Grids, ExtCtrls, StdCtrls, ButtonPanel,

  uListOperation;

type

  { TFastPhrasesForm }

  TFastPhrasesForm = class(TForm)
    ControlBar1: TControlBar;
    FastPhrasesBtnPanel: TPanel;
    EditFastPhrasesPanel: TPanel;
    FastPhrasesListBox: TListBox;
    FasrPhrasesImageList: TImageList;
    EditSpeedButton: TSpeedButton;
    TempMemo: TMemo;
    EditFastPhrToolBar: TToolBar;
    NewPhrasesToolButton: TToolButton;
    UpPhrasesToolButton: TToolButton;
    DownPhrasesToolButton: TToolButton;
    DeletePhrasesToolButton: TToolButton;
    SavePhrasesToolButton: TToolButton;
    DoneEditToolButton: TToolButton;
    procedure DeletePhrasesToolButtonClick(Sender: TObject);
    procedure DoneEditToolButtonClick(Sender: TObject);
    procedure DownPhrasesToolButtonClick(Sender: TObject);
    procedure EditSpeedButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure NewPhrasesToolButtonClick(Sender: TObject);
    procedure SavePhrasesToolButtonClick(Sender: TObject);
    procedure UpPhrasesToolButtonClick(Sender: TObject);
    procedure CreateButtonOnPanel;
    procedure DeleteButtonFromPanel;
  private

  public
    procedure Clicks(Sender: TObject);
  end;

var
  FastPhrasesForm: TFastPhrasesForm;
  FastPhrasesList: TStringList;
  StartPath: String;


implementation

{$R *.lfm}

{ TFastPhrasesForm }
var
  aFastBtn: array of TButton;

procedure TFastPhrasesForm.FormCreate(Sender: TObject);
var err: integer;
begin
  StartPath := ExtractFileDir(ParamStr(0)); // определяем  путь к программе
 {$IFDEF WINDOWS}
 if StartPath[Length(StartPath)] <> '\' then begin
   StartPath := StartPath + '\';
 end; // проверяем есть ли на конце строки "\"
 {$ELSE}
   StartPath := ParamStr(0);
   {$IFDEF MACOS}
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
   FastPhrasesList := TStringList.Create;
  {$IFDEF WINDOWS}
    FastPhrasesList.LoadFromFile(StartPath + 'Data\FastPhrases.txt');
  {$ELSE}
    FastPhrasesList.LoadFromFile(StartPath + 'Data/FastPhrases.txt');
  {$ENDIF}
  FastPhrasesListBox.Items.AddStrings(FastPhrasesList);

  CreateButtonOnPanel;
end;

procedure TFastPhrasesForm.NewPhrasesToolButtonClick(Sender: TObject);
var NewWord: string;
begin
  NewWord := '';
  if not InputQuery('Веведите слово', 'Введите слово для листа фраз:', NewWord) then exit;
  if NewWord <> '' then FastPhrasesListBox.Items.Add(NewWord);
  FastPhrasesListBox.Selected[(FastPhrasesListBox.Count -1)] := true;
end;

procedure TFastPhrasesForm.SavePhrasesToolButtonClick(Sender: TObject);
begin
 FastPhrasesList.Clear;
 FastPhrasesList.AddStrings(FastPhrasesListBox.Items);
 {$IFDEF WINDOWS}
   FastPhrasesList.SaveToFile(StartPath + 'Data\FastPhrases.txt');
 {$ELSE}
   FastPhrasesList.SaveToFile(StartPath + 'Data/FastPhrases.txt');
 {$ENDIF}
end;

procedure TFastPhrasesForm.UpPhrasesToolButtonClick(Sender: TObject);
var CurSel: integer;
begin
  if FastPhrasesListBox.SelCount <> 1 then exit;
  CurSel := GetCurentSelectedItemLB(FastPhrasesListBox);
  if CurSel > 0 then begin
   FastPhrasesListBox.Items.Move(CurSel, (CurSel-1));
   FastPhrasesListBox.Selected[CurSel-1] := true;
  end;
end;

procedure TFastPhrasesForm.CreateButtonOnPanel;
var i, NewTop: integer;
begin
  if FastPhrasesList.Count > 0 then begin
    for i := 0 to (FastPhrasesList.Count -1) do begin
      SetLength(aFastBtn, (Length(aFastBtn) + 1));
      {$IFDEF WINDOWS}
        NewTop := 5 + i*40;
      {$ELSE}
        NewTop := 5 + i*25;
      {$ENDIF}
      aFastBtn[i] :=  TButton.Create(FastPhrasesBtnPanel);
      aFastBtn[i].Parent:=FastPhrasesBtnPanel;            // Компонент - родитель
      aFastBtn[i].Left:=5;                 // задаем параметр left
      aFastBtn[i].Top:=NewTop;                  // задаем параметр top
      aFastBtn[i].Caption:=FastPhrasesList[i];        // задаем caption
      aFastBtn[i].Height:=25; // задаем высоту
      aFastBtn[i].Width:=200;
      aFastBtn[i].OnClick:=@Clicks;
    end;
  end;
end;

procedure TFastPhrasesForm.DeleteButtonFromPanel;
var i, countBtn:integer;
begin
  countBtn := Length(aFastBtn) -1;
  for i := countBtn downto 0 do begin
   //aFastBtn[i].Destroy;
   aFastBtn[i].Free;
  end;
  SetLength(aFastBtn, 0);
end;

procedure TFastPhrasesForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
 {$IFDEF WINDOWS}
   FastPhrasesList.SaveToFile(StartPath + 'Data\FastPhrases.txt');
 {$ELSE}
   FastPhrasesList.SaveToFile(StartPath + 'Data/FastPhrases.txt');
 {$ENDIF}
end;

procedure TFastPhrasesForm.EditSpeedButtonClick(Sender: TObject);
begin
  if EditSpeedButton.Down then begin
    EditFastPhrasesPanel.Visible:= true;
    FastPhrasesBtnPanel.Visible:=false;
    DeleteButtonFromPanel;
  end else begin
    EditFastPhrasesPanel.Visible:= false;
    CreateButtonOnPanel;
    FastPhrasesBtnPanel.Visible:= true;
  end;
end;

procedure TFastPhrasesForm.DownPhrasesToolButtonClick(Sender: TObject);
var CurSel: integer;
begin
 if FastPhrasesListBox.SelCount <> 1 then exit;
  CurSel := GetCurentSelectedItemLB(FastPhrasesListBox);
  if CurSel < (FastPhrasesListBox.Items.Count-1) then begin
   FastPhrasesListBox.Items.Move(CurSel, (CurSel+1));
   FastPhrasesListBox.Selected[CurSel+1] := true;
  end;
end;

procedure TFastPhrasesForm.DeletePhrasesToolButtonClick(Sender: TObject);
begin
  if FastPhrasesListBox.SelCount <> 1 then exit;
  FastPhrasesListBox.DeleteSelected;
end;

procedure TFastPhrasesForm.DoneEditToolButtonClick(Sender: TObject);
begin
  FastPhrasesForm.EditSpeedButtonClick(Self);
end;

procedure TFastPhrasesForm.Clicks(Sender: TObject);
begin
  with (Sender as TButton) do begin
    TempMemo.Text := Caption;
    if TempMemo.Lines.Count > 0 then begin
     TempMemo.SetFocus;
     TempMemo.SelectAll;
     TempMemo.CopyToClipboard;
    end;
  end;
end;

end.

