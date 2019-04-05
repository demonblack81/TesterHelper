unit uListOperation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls;

function LoadNameListInString(Path:string; Combobox: TComboBox): integer;
function GetCurentSelectedItemLB(ListBox: TListBox):integer;
function LoadDiscriptionInCB(Path:string; Combobox: TComboBox): integer;

implementation

function LoadNameListInString(Path:string; Combobox: TComboBox): integer;
var FileSearch: TSearchRec;
    Attr : integer;
begin
   Result := 0;
   if ComboBox.Items.Count > 0 then ComboBox.Items.Clear;
   Attr := faAnyFile - faDirectory;
   if FindFirst(Path, Attr, FileSearch) = 0 then begin
     if FileSearch.Name <> '' then begin
       ComboBox.Items.Add(ExtractFileName(FileSearch.Name));
     end;
     while FindNext(FileSearch) = 0 do begin
       if FileSearch.Name <> '' then begin
        ComboBox.Items.Add(ExtractFileName(FileSearch.Name));
       end;
     end;
     Result := ComboBox.Items.Count;
   end else begin
     Result := -1; // Файлы в коталоге не найдены
   end;
   FindClose(FileSearch);
end;

function GetCurentSelectedItemLB(ListBox: TListBox): integer;
var i: integer;
begin
  Result := -1;
  for i:= 0 to (ListBox.Items.Count -1 ) do begin
    if ListBox.Selected[i] then begin
      Result := i;
      break;
    end;
  end;
end;

function LoadDiscriptionInCB(Path: string; Combobox: TComboBox): integer;
var FileSearch: TSearchRec;
    Attr : integer;
    TempList: TStringList;
    TempPath : string;
begin
   Result := 0;
   if ComboBox.Items.Count > 0 then ComboBox.Items.Clear;
   Attr := faAnyFile - faDirectory;
   TempList := TStringList.Create;
   TempPath := Copy(Path, 0, (Length(Path)-3));
   if FindFirst(Path, Attr, FileSearch) = 0 then begin
     if FileSearch.Name <> '' then begin
        TempList.LoadFromFile(TempPath + FileSearch.Name);
        ComboBox.Items.Add(TempList[0]); //, Object(TempStr));
     end;
     while FindNext(FileSearch) = 0 do begin
       if FileSearch.Name <> '' then begin
         TempList.Clear;
         TempList.LoadFromFile(TempPath + FileSearch.Name);
         ComboBox.Items.Add(TempList[0]);
       end;
     end;
     Result := ComboBox.Items.Count;
   end else begin
     Result := -1; // Файлы в коталоге не найдены
   end;
   FindClose(FileSearch);
   TempList.Free;
end;

end.

