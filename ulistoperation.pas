unit uListOperation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function LoadNameListInString(Path:string; var NameList: TStringList): integer;

implementation

function LoadNameListInString(Path: string; var NameList: TStringList): integer;
var FileSearch: TSearchRec;
    Attr : integer;
begin
   Result := 0;
   if (NameList = nil) then  NameList := TStringList.Create;
   NameList.Clear;
   Attr := faAnyFile - faDirectory;
   if FindFirst(Path, Attr, FileSearch) = 0 then begin
     if FileSearch.Name <> '' then begin
       NameList.Add(ExtractFileName(FileSearch.Name));
     end;
     while FindNext(FileSearch) = 0 do begin
       if FileSearch.Name <> '' then begin
           NameList.Add(ExtractFileName(FileSearch.Name));
       end;
     end;
     Result := NameList.Count;
   end else begin
     Result := -1; // Файлы в коталоге не найдены
   end;
   FindClose(FileSearch);
end;

end.

