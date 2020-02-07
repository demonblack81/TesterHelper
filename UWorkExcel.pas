unit UWorkExcel;

interface
uses {$IFDEF WINDOWS}ComObj, {$ENDIF} Classes, Variants, SysUtils;

Function CreateExcel:boolean; // �������� ������� Excel
Function VisibleExcel(visible:boolean): boolean; // ��������/�������� Excel
Function AddWorkBook:boolean; // �������� ����� �����
Function OpenWorkBook(file_: string):boolean; // ������� ������������ �����
Function AddSheet(newsheet:string):boolean; // �������� ����
Function DeleteSheet(sheet:variant):boolean; // ������� ����
Function CountSheets:integer; // ���������� ������
Function GetSheets(value:TStrings):boolean; // ������ �������� ������
Function SelectSheet(sheet:variant):boolean; // ������� ����
Function SaveWorkBookAs(file_:string): boolean; // �������� �����
Function CloseWorkBook:boolean; // ������� �����
Function CloseExcel:boolean; // ���������� ������ Excel

Function SetRange(sheet:variant;range:variant; value_:variant):boolean; // ������ � ������
Function GetRange(sheet:variant;range:variant):variant; // ������ �� ������

implementation

var E:variant;

Function CreateExcel:boolean;
begin
 CreateExcel:=true;
 {$IFDEF WINDOWS}
 try
  E:=CreateOleObject('Excel.Application');
 except
  CreateExcel:=false;
 end;
 {$ENDIF}
end;

Function VisibleExcel(visible:boolean): boolean;
begin
 VisibleExcel:=true;
 try
  E.visible:=visible;
 except
  VisibleExcel:=false;
 end;
end;

Function AddWorkBook:boolean;
begin
 AddWorkBook:=true;
 try
  E.Workbooks.Add;
 except
  AddWorkBook:=false;
 end;
end;

Function OpenWorkBook(file_: string):boolean;
begin
 OpenWorkBook:=true;
 try
  E.Workbooks.Open(file_);
 except
  OpenWorkBook:=false;
 end;
end;

Function AddSheet(newsheet:string):boolean;
begin
 AddSheet:=true;
 try
  E.Sheets.Add;
  E.ActiveSheet.Name:=newsheet;
 except
  AddSheet:=false;
 end;
end;

Function DeleteSheet(sheet:variant):boolean;
begin
 DeleteSheet:=true;
 try
  E.DisplayAlerts:=False;
  E.Sheets[sheet].Delete;
  E.DisplayAlerts:=True;
 except
  DeleteSheet:=false;
 end;
end;

Function CountSheets:integer;
// �������� ���������� ������ �����
begin
 try
  CountSheets:=E.ActiveWorkbook.Sheets.Count;
 except
  CountSheets:=-1;
 end;
end;

Function GetSheets(value:TStrings):boolean;
// ���������� ����� ����� � value
var a_:integer;
begin
 GetSheets:=true;
 value.Clear;
 try
  for a_:=1 to E.ActiveWorkbook.Sheets.Count do
   value.Add(E.ActiveWorkbook.Sheets.Item[a_].Name);
 except
  GetSheets:=false;
  value.Clear;
 end;
end;

Function SelectSheet(sheet:variant):boolean;
// �������� ����
begin
 SelectSheet:=true;
 try
  E.ActiveWorkbook.Sheets.Item[sheet].Select;
 except
  SelectSheet:=false;
 end;
end;

Function SaveWorkBookAs(file_:string): boolean;
begin
 SaveWorkBookAs:=true;
 try
  E.DisplayAlerts:=False;
  E.ActiveWorkbook.SaveAs(file_);
  E.DisplayAlerts:=True;
 except
  SaveWorkBookAs:=false;
 end;
end;

Function CloseWorkBook:boolean;
begin
 CloseWorkBook:=true;
 try
  E.ActiveWorkbook.Close;
 except
  CloseWorkBook:=false;
 end;
end;

Function CloseExcel:boolean;
begin
 CloseExcel:=true;
 try
  E.Quit;
 except
  CloseExcel:=false;
 end;
end;

Function SetRange(sheet:variant;range:variant; value_:variant):boolean;
begin
 SetRange:=true;
 try
  E.ActiveWorkbook.Sheets.Item[sheet].Range[range]:=value_;
 except
  SetRange:=false;
 end;
end;

Function GetRange(sheet:variant;range:variant):variant;
begin
 try
  GetRange:=E.ActiveWorkbook.Sheets.Item[sheet].Range[range];
 except
  GetRange:=null;
 end;
End;

end.
