unit uPhraseTemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,

  uListOperation, uEditStringsParam;

type

  { TPhraseTemplateForm }

  TPhraseTemplateForm = class(TForm)
    AddTemplateBtn: TButton;
    ClloseBitBtn: TBitBtn;
    Button1: TButton;
    AddWordBtn: TButton;
    SaveTemplateBtn: TButton;
    ClearTemplateBtn: TButton;
    AddListPhrBtn: TButton;
    UpdWordListBtn: TButton;
    TamplatePhrasesComboBox: TComboBox;
    NameListComboBox: TComboBox;
    PhraseInfoEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    WordListBox: TListBox;
    PhraseTemplateMemo: TMemo;
    procedure AddTemplateBtnClick(Sender: TObject);
    procedure AddWordBtnClick(Sender: TObject);
    procedure AddListPhrBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ClearTemplateBtnClick(Sender: TObject);
    procedure UpdWordListBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NameListComboBoxCloseUp(Sender: TObject);
    procedure SaveTemplateBtnClick(Sender: TObject);
    procedure TamplatePhrasesComboBoxCloseUp(Sender: TObject);
    procedure ClearTemplate;
  private

  public

  end;

var
  PhraseTemplateForm: TPhraseTemplateForm;
  PhraseTamplateList, WordList: TStringList;
  TamplateDir, ListDir: String;

implementation

{$R *.lfm}

{ TPhraseTemplateForm }

procedure TPhraseTemplateForm.FormCreate(Sender: TObject);
var err: integer;
begin
  TamplateDir := ExtractFileDir(ParamStr(0));
  if TamplateDir[Length(TamplateDir)] <> '\' then begin
   ListDir := TamplateDir + '\List\';
   TamplateDir := TamplateDir + '\Phrases\';
  end else begin
   ListDir := TamplateDir + 'List\';
   TamplateDir :=  TamplateDir + 'Phrases\';
  end;
  WordList := TStringList.Create;
  PhraseTamplateList := TStringList.Create;
  err := LoadNameListInString((TamplateDir + '*.*'), TamplatePhrasesComboBox);
  if (err < 0) then begin
   ShowMessage('LoadNameListInString. Файлы в коталоге не найдены');
  end;
  err := LoadNameListInString((ListDir + '*.*'), NameListComboBox);
  if (err < 0) then begin
   ShowMessage('LoadNameListInString. Файлы в коталоге не найдены');
  end;
end;

procedure TPhraseTemplateForm.AddTemplateBtnClick(Sender: TObject);
var NewName: string;
    FileHandle:  Longint;
begin
  NewName := '';
  if not InputQuery('Название шаблона фразы', 'Введите название шаблона фразы:', NewName) then exit;
  if NewName <> '' then TamplatePhrasesComboBox.Items.Add(NewName);
  FileHandle := FileCreate(TamplateDir+NewName);
  FileClose(FileHandle);
end;

procedure TPhraseTemplateForm.AddWordBtnClick(Sender: TObject);
var CurSel: integer;
    CurPosInMemo: TPoint;
    TempStr: String;
begin
  if WordListBox.SelCount <> 1 then exit;
  CurSel := GetCurentSelectedItemLB(WordListBox);
  if CurSel < 0 then exit;
  CurPosInMemo := PhraseTemplateMemo.CaretPos;
  TempStr := PhraseTemplateMemo.Lines[CurPosInMemo.y];
  Insert(WordListBox.Items[CurSel], TempStr, CurPosInMemo.x);
  PhraseTemplateMemo.Lines[CurPosInMemo.y] := TempStr;
end;

procedure TPhraseTemplateForm.AddListPhrBtnClick(Sender: TObject);
var CurPosInMemo: TPoint;
    TempStr: String;
begin
   if NameListComboBox.Text <> '' then begin
     CurPosInMemo := PhraseTemplateMemo.CaretPos;
     TempStr := PhraseTemplateMemo.Lines[CurPosInMemo.y];
     Insert('<PhTemp' + IntToStr(NameListComboBox.ItemIndex) + '/>', TempStr, CurPosInMemo.x);
     PhraseTemplateMemo.Lines[CurPosInMemo.y] := TempStr;
   end;
end;

procedure TPhraseTemplateForm.Button1Click(Sender: TObject);
begin
  if TamplatePhrasesComboBox.Text = '' then exit;
  PhraseInfoEdit.Text := '';
  PhraseTemplateMemo.Lines.Clear;
  DeleteFile(TamplateDir+TamplatePhrasesComboBox.Items[TamplatePhrasesComboBox.ItemIndex]);
  TamplatePhrasesComboBox.Items.Delete(TamplatePhrasesComboBox.ItemIndex);
  TamplatePhrasesComboBox.Text := '';
end;

procedure TPhraseTemplateForm.ClearTemplateBtnClick(Sender: TObject);
begin
  ClearTemplate;
end;

procedure TPhraseTemplateForm.UpdWordListBtnClick(Sender: TObject);
var err: integer;
begin
  if StringsParamForm.ShowModal = mrOK then begin
    NameListComboBox.Items.Clear;
    WordListBox.Items.Clear;
    err := LoadNameListInString((ListDir + '*.*'), NameListComboBox); //NameList);
    if (err < 0) then begin
    ShowMessage('LoadNameListInString. Файлы в коталоге не найдены');
    end;
  end;
end;

procedure TPhraseTemplateForm.NameListComboBoxCloseUp(Sender: TObject);
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

procedure TPhraseTemplateForm.SaveTemplateBtnClick(Sender: TObject);
begin
  if TamplatePhrasesComboBox.Text = '' then exit;
  PhraseTamplateList.Clear;
  PhraseTamplateList.Add(PhraseInfoEdit.Text);
  PhraseTamplateList.AddStrings(PhraseTemplateMemo.Lines);
  PhraseTamplateList.SaveToFile(TamplateDir + TamplatePhrasesComboBox.Text);
end;

procedure TPhraseTemplateForm.TamplatePhrasesComboBoxCloseUp(Sender: TObject);
var FileSearch: TSearchRec;
    Attr : integer;
begin
  If TamplatePhrasesComboBox.ItemIndex <> -1 then begin
    PhraseTamplateList.Clear;
    ClearTemplate;
    Attr := faAnyFile - faDirectory;
    if FindFirst(TamplateDir + TamplatePhrasesComboBox.items[TamplatePhrasesComboBox.ItemIndex], Attr, FileSearch) = 0 then begin
      if FileSearch.Size > 0 then begin
         PhraseTamplateList.LoadFromFile((TamplateDir + TamplatePhrasesComboBox.items[TamplatePhrasesComboBox.ItemIndex]));
         if PhraseTamplateList.Count > 0 then begin
           PhraseInfoEdit.Text := PhraseTamplateList[0];
           PhraseTamplateList.Delete(0);
           PhraseTemplateMemo.Lines := PhraseTamplateList;
         end;
      end else begin
       ShowMessage('Выбранный файл пуст.');
      end;
    end;
    FindClose(FileSearch);
  end;
end;

procedure TPhraseTemplateForm.ClearTemplate;
begin
  PhraseInfoEdit.Text:= '';
  PhraseTemplateMemo.Lines.Clear;
end;


end.

