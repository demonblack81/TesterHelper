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
    BitBtn4: TBitBtn;
    AddListBtn: TButton;
    DelListBtn: TButton;
    NameListComboBox: TComboBox;
    Label1: TLabel;
    ListBox1: TListBox;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
  private

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

end;

end.

