program TesterHelper;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UMain, uGeneration, UWorkExcel, uProcInfo, uEditStringsParam, uPhraseTemplate;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TStringsParamForm, StringsParamForm);
  Application.CreateForm(TPhraseTemplateForm, PhraseTemplateForm);
  Application.Run;
end.

