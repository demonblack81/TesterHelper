unit uEditStringsParam;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls,

  uListOperation;

type

  { TStringsParamForm }

  TStringsParamForm = class(TForm)
    AddNameBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    UpWordBitBtn: TBitBtn;
    DownWordBitBtn: TBitBtn;
    BtnSave: TButton;
    DelNameBitBtn: TBitBtn;
    AddListBtn: TButton;
    DelListBtn: TButton;
    Label2: TLabel;
    NameListComboBox: TComboBox;
    Label1: TLabel;
    WordListBox: TListBox;
    procedure AddListBtnClick(Sender: TObject);
    procedure AddNameBitBtnClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure DelListBtnClick(Sender: TObject);
    procedure DelNameBitBtnClick(Sender: TObject);
    procedure DownWordBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NameListComboBoxCloseUp(Sender: TObject);
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
  ListDir := ExtractFileDir(ParamStr(0));
  if ListDir[Length(ListDir)] <> '\' then begin
   ListDir := ListDir + '\List\';
  end else begin
   ListDir :=  ListDir +  'List\';
  end;
  WordList := TStringList.Create;
  err := LoadNameListInString((ListDir + '*.*'), NameListComboBox); //NameList);
  if (err < 0) then begin
   ShowMessage('LoadNameListInString. Файлы в коталоге не найдены');
  end;
end;

procedure TStringsParamForm.BtnSaveClick(Sender: TObject);
begin
  WordListBox.Items.SaveToFile(ListDir+NameListComboBox.items[NameListComboBox.ItemIndex]);
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

end;

procedure TStringsParamForm.DownWordBitBtnClick(Sender: TObject);
var CurSel: integer;
begin
  if WordListBox.SelCount <> 1 then exit;
  CurSel := GetCurentSelectedItemLB(WordListBox);
  if CurSel < (WordListBox.Items.Count-1) then begin
   WordListBox.Items.Move(CurSel, (CurSel+1));
  end;
end;

procedure TStringsParamForm.AddListBtnClick(Sender: TObject);
var NewName: string;
begin
  NewName := '';
  if not InputQuery('Название листа фраз', 'Введите имя для листа фраз:', NewName) then exit;
  if NewName <> '' then NameListComboBox.Items.Add(NewName);
  FileCreate(ListDir+NewName);
end;

procedure TStringsParamForm.AddNameBitBtnClick(Sender: TObject);
var NewWord: string;
begin
  NewWord := '';
  if not InputQuery('Веведите слово', 'Введите слово для листа фраз:', NewWord) then exit;
  if NewWord <> '' then WordListBox.Items.Add(NewWord);
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

procedure TStringsParamForm.UpWordBitBtnClick(Sender: TObject);
var CurSel: integer;
begin
  if WordListBox.SelCount <> 1 then exit;
  CurSel := GetCurentSelectedItemLB(WordListBox);
  if CurSel > 0 then begin
   WordListBox.Items.Move(CurSel, (CurSel-1));
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

