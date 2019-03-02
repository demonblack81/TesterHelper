unit uEditStringsParam;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls;

type

  { TStringsParamForm }

  TStringsParamForm = class(TForm)
    AddNameBitBtn: TBitBtn;
    DelNameBitBtn: TBitBtn;
    AddListBtn: TButton;
    DelListBtn: TButton;
    NameListComboBox: TComboBox;
    Label1: TLabel;
    ListBox1: TListBox;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
  private
    ListDir: string;
  public

  end;

var
  StringsParamForm: TStringsParamForm;


implementation

{$R *.lfm}

{ TStringsParamForm }

procedure TStringsParamForm.FormCreate(Sender: TObject);
begin
  //Добавляем в NameListComboBox название листов по именам файлов в папке ./List
  ListDir := ExtractFileDir(ParamStr(0));
  if ListDir[Length(ListDir)] <> '\' then begin
   ListDir := ListDir + '\';
 end;
  ListDir :=  ListDir +  'List\';
end;

end.

