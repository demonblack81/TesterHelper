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
    UpWordBitBtn: TBitBtn;
    DownWordBitBtn: TBitBtn;
    BtnClose: TButton;
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
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure DownWordBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NameListComboBoxCloseUp(Sender: TObject);
    procedure UpWordBitBtnClick(Sender: TObject);
  private
    ListDir: string;
  public

  end;

var
  StringsParamForm: TStringsParamForm;
  NameList, WordList: TStringList;
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
  NameList := TStringList.Create;
  WordList := TStringList.Create;
  err := LoadNameListInString((ListDir + '*.*'), NameList);
  if (err >= 0) then begin
   NameListComboBox.Items := NameList;
  end else begin
    // Произошла ошибка нужна выводить мисагу что случилось
  end;
end;

procedure TStringsParamForm.BtnCloseClick(Sender: TObject);
begin
  StringsParamForm.Close;
end;

procedure TStringsParamForm.BtnSaveClick(Sender: TObject);
begin
  WordListBox.Items.SaveToFile(ListDir+NameListComboBox.items[NameListComboBox.ItemIndex]);
end;

procedure TStringsParamForm.DownWordBitBtnClick(Sender: TObject);
var CurSel, i: integer;
begin
  if WordListBox.SelCount <> 1 then exit;
  CurSel := 0;
  for i:= 0 to (WordListBox.Items.Count -1 ) do begin
    if WordListBox.Selected[i] then begin
      CurSel := i;
      break;
    end;
  end;
  if CurSel < (WordListBox.Items.Count-1) then begin
   WordListBox.Items.Move(CurSel, (CurSel+1));
  end;
end;

procedure TStringsParamForm.AddListBtnClick(Sender: TObject);
var NewName: string;
begin
  NewName := '';
  if not InputQuery('Название листа фраз:', 'Введите имя для листа фраз', NewName ) then exit;
  if NewName <> '' then NameListComboBox.Items.Add(NewName);
  FileCreate(ListDir+NewName);
end;

procedure TStringsParamForm.AddNameBitBtnClick(Sender: TObject);
var NewWord: string;
begin
  NewWord := '';
  if not InputQuery('Веведите слово:', 'Введите слова для листа фраз', NewWord) then exit;
  if NewWord <> '' then WordListBox.Items.Add(NewWord);
end;

procedure TStringsParamForm.NameListComboBoxCloseUp(Sender: TObject);
var FileSearch: TSearchRec;
    Attr : integer;
begin
  If NameListComboBox.ItemIndex <> -1 then begin
    WordListBox.Items.Clear;
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
var CurSel, i: integer;
begin
  if WordListBox.SelCount <> 1 then exit;
  CurSel := 0;
  for i:= 0 to (WordListBox.Items.Count -1) do begin
    if WordListBox.Selected[i] then begin
      CurSel := i;
      break;
    end;
  end;
  if CurSel > 0 then begin
   WordListBox.Items.Move(CurSel, (CurSel-1));
  end;
end;

end.

