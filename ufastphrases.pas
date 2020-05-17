unit uFastPhrases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Buttons,
  CheckLst, Grids, ExtCtrls, StdCtrls;

type

  { TFastPhrasesForm }

  TFastPhrasesForm = class(TForm)
    BitBtn1: TBitBtn;
    FastPhrasesBtnPanel: TPanel;
    TempMemo: TMemo;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
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
var err,i,NewTop: integer;
begin
  StartPath := ExtractFileDir(ParamStr(0)); // определяем  путь к программе
 {$IFDEF WINDOWS}
 if StartPath[Length(StartPath)] <> '\' then begin
   StartPath := StartPath + '\';
 end; // проверяем есть ли на конце строки "\"
 {$ELSE}
   StartPath := ParamStr(0);
   err := Pos('TesterHelper.app', StartPath);
   Delete(StartPath, err, (Length(StartPath) - err + 2));
   err := 0;
 {$ENDIF}
   FastPhrasesList := TStringList.Create;
  {$IFDEF WINDOWS}
    FastPhrasesList.LoadFromFile(StartPath + 'Data\FastPhrases.txt');
  {$ELSE}
    FastPhrasesList.LoadFromFile(StartPath + 'Data/FastPhrases.txt');
  {$ENDIF}

  if FastPhrasesList.Count > 0 then begin
    for i := 0 to (FastPhrasesList.Count -1) do begin
      SetLength(aFastBtn, (Length(aFastBtn) + 1));
      NewTop := 5 + i*40;
      aFastBtn[i] :=  TButton.Create(FastPhrasesBtnPanel);
      aFastBtn[i].Parent:=FastPhrasesBtnPanel;            // Компонент - родитель
      aFastBtn[i].Left:=5;                 // задаем параметр left
      aFastBtn[i].Top:=NewTop;                  // задаем параметр top
      aFastBtn[i].Caption:=FastPhrasesList[i];        // задаем caption
      aFastBtn[i].Height:=40; // задаем высоту
      aFastBtn[i].Width:=200;
      aFastBtn[i].OnClick:=@Clicks;
    end;

  end;
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

procedure TFastPhrasesForm.Clicks(Sender: TObject);
begin
  with (Sender as TButton) do begin
    TempMemo.Text := Caption;
    if TempMemo.Lines.Count > 0 then begin
     TempMemo.SelectAll;
     TempMemo.CopyToClipboard;
    end;
  end;
end;

end.

