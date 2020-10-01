unit uMakedPhrases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    AddPhraseFromClipboardBitBtn: TBitBtn;
    CopySelectedPraseBitBtn: TBitBtn;
    CloseFprmBitBtn: TBitBtn;
    MakedPrasesListBox: TListBox;
  private

  public
    SL_MakedPhrases : TStringList;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

