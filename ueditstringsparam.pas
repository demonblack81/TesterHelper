unit uEditStringsParam;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls, LCLType,

  uListOperation;

type

  { TStringsParamForm }

  TStringsParamForm = class(TForm)
    AddNameBitBtn: TBitBtn;
    SaveBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    UpWordBitBtn: TBitBtn;
    DownWordBitBtn: TBitBtn;
    DelNameBitBtn: TBitBtn;
    AddListBtn: TButton;
    DelListBtn: TButton;
    Label2: TLabel;
    NameListComboBox: TComboBox;
    Label1: TLabel;
    WordListBox: TListBox;
    procedure AddListBtnClick(Sender: TObject);
    procedure AddNameBitBtnClick(Sender: TObject);
    procedure DelListBtnClick(Sender: TObject);
    procedure DelNameBitBtnClick(Sender: TObject);
    procedure DownWordBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NameListComboBoxCloseUp(Sender: TObject);
    procedure SaveBitBtnClick(Sender: TObject);
    procedure UpWordBitBtnClick(Sender: TObject);
    procedure WordListBoxDblClick(Sender: TObject);
  private

  public

  end;

var
  StringsParamForm: TStringsParamForm;
  WordList: TStringList;
  ListDir: string;

implementation

{$R *.lfm}

{ TStringsParamForm }

procedure TStringsParamForm.FormCreate(Sender: TObject);
var err: integer;
begin
  //Добавляем в NameListComboBox название листов по именам файлов в папке ./List
  {$IFDEF MSWINDOWS}
     ListDir := ExtractFileDir(ParamStr(0));
     if ListDir[Length(ListDir)] <> '\' then begin
       ListDir := ListDir + '\List\';
     end else begin
       ListDir :=  ListDir +  'List\';
     end;
  {$ELSE}
   ListDir := ParamStr(0);
   {$IFDEF UNIX}
   err := Pos('TesterHelper.app', ListDir);
   Delete(ListDir, err, (Length(ListDir) - err + 2) );
  {$ENDIF}
  {$IFDEF LINUX}
   err := Pos('TesterHelper/', ListDir);
   err := err+ 13;
   Delete(ListDir, err, 12 );
  {$ENDIF}
   err := 0;
   ListDir := ListDir + 'List/';
  {$ENDIF}
  WordList := TStringList.Create;
  {$IFDEF MSWINDOWS}
    err := LoadNameListInString((ListDir + '*.*'), NameListComboBox);
  {$ELSE}
    err := LoadNameListInString((ListDir + '*'), NameListComboBox);
  {$ENDIF}
  if (err < 0) then begin
   ShowMessage('LoadNameListInString. Файлы в коталоге не найдены');
  end;
end;

procedure TStringsParamForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (ssCtrl in Shift) and (chr(Key) in ['N', 'n']) then AddNameBitBtn.Click;
   if (ssCtrl in Shift) and (chr(Key) in ['S', 's']) then SaveBitBtn.Click;
end;

procedure TStringsParamForm.DelListBtnClick(Sender: TObject);
begin
  if NameListComboBox.Text = '' then exit;
  WordListBox.Items.Clear;
  DeleteFile(ListDir+NameListComboBox.items[NameListComboBox.ItemIndex]);
  NameListComboBox.items.Delete(NameListComboBox.ItemIndex);
  NameListComboBox.Text:= '';
end;

procedure TStringsParamForm.DelNameBitBtnClick(Sender: TObject);
begin
  if WordListBox.SelCount <> 1 then exit;
  WordListBox.DeleteSelected;
end;

procedure TStringsParamForm.DownWordBitBtnClick(Sender: TObject);
var CurSel: integer;
begin
  if WordListBox.SelCount <> 1 then exit;
  CurSel := GetCurentSelectedItemLB(WordListBox);
  if CurSel < (WordListBox.Items.Count-1) then begin
   WordListBox.Items.Move(CurSel, (CurSel+1));
   WordListBox.Selected[CurSel+1] := true;
  end;
end;

procedure TStringsParamForm.AddListBtnClick(Sender: TObject);
var NewName: string;
    FileHandle:  Longint;
begin
  NewName := '';
  if not InputQuery('Название листа фраз', 'Введите имя для листа фраз:', NewName) then exit;
  if NewName <> '' then NameListComboBox.Items.Add(NewName);
  FileHandle := FileCreate(ListDir+NewName);
  FileClose(FileHandle);
  NameListComboBox.Text := NewName;
  NameListComboBox.ItemIndex := NameListComboBox.Items.Count -1;
end;

procedure TStringsParamForm.AddNameBitBtnClick(Sender: TObject);
var NewWord: string;
begin
  NewWord := '';
  if not InputQuery('Веведите слово', 'Введите слово для листа фраз:', NewWord) then exit;
  if NewWord <> '' then WordListBox.Items.Add(NewWord);
  WordListBox.Selected[(WordListBox.Count -1)] := true;
end;

procedure TStringsParamForm.NameListComboBoxCloseUp(Sender: TObject);
var FileSearch: TSearchRec;
    Attr : integer;
begin
  If NameListComboBox.ItemIndex <> -1 then begin
    WordListBox.Items.Clear;
    Attr := faAnyFile - faDirectory;
    if FindFirst(ListDir + NameListComboBox.items[NameListComboBox.ItemIndex], Attr, FileSearch) = 0 then begin
      if FileSearch.Size > 0 then begin
        WordListBox.Items.LoadFromFile(ListDir + NameListComboBox.items[NameListComboBox.ItemIndex]);
      end else begin
       ShowMessage('Выбранный файл пуст.');
      end;
    end;
    FindClose(FileSearch);
  end;
end;

procedure TStringsParamForm.SaveBitBtnClick(Sender: TObject);
begin
  WordListBox.Items.SaveToFile(ListDir+NameListComboBox.items[NameListComboBox.ItemIndex]);
end;

procedure TStringsParamForm.UpWordBitBtnClick(Sender: TObject);
var CurSel: integer;
begin
  if WordListBox.SelCount <> 1 then exit;
  CurSel := GetCurentSelectedItemLB(WordListBox);
  if CurSel > 0 then begin
   WordListBox.Items.Move(CurSel, (CurSel-1));
   WordListBox.Selected[CurSel-1] := true;
  end;
end;

procedure TStringsParamForm.WordListBoxDblClick(Sender: TObject);
var CurSel: integer;
    TempStr: string;
begin
  if WordListBox.SelCount <> 1 then exit;
  CurSel := GetCurentSelectedItemLB(WordListBox);
  if CurSel < 0 then exit;
  TempStr := WordListBox.Items[CurSel];
  TempStr := InputBox('Изменение слова','Введите новое слово для листа фраз:',TempStr);
  if TempStr <> WordListBox.Items[CurSel] then begin
    WordListBox.Items[CurSel] := TempStr;
  end;
end;

end.

