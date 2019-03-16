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
    DelNameBitBtn: TBitBtn;
    AddListBtn: TButton;
    DelListBtn: TButton;
    NameListComboBox: TComboBox;
    Label1: TLabel;
    WordListBox: TListBox;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure NameListComboBoxChange(Sender: TObject);
    procedure NameListComboBoxCloseUp(Sender: TObject);
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

procedure TStringsParamForm.NameListComboBoxChange(Sender: TObject);
begin

end;

procedure TStringsParamForm.NameListComboBoxCloseUp(Sender: TObject);
begin
  If NameListComboBox.ItemIndex <> -1 then begin
    WorldlistBox.Items.Clear;
    WordListBox.Items.LoadFromFile(ListDir + NameListComboBox.items[NameListComboBox.ItemIndex]);
  end;
end;

end.

