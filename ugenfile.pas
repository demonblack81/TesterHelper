unit UGenFile;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Graphics, FileUtil;

procedure GenerateFinalPicture(FileList: TStringList; DirPath:string; Name:string);
function GetFileInFolder(DirPath: String): TStringList;

implementation

procedure GenerateFinalPicture(FileList: TStringList; DirPath:string; Name:string);
var
  FinalPicture, TempPicture: TPicture;
  NewWidth, i, TempWidth: integer;
  Ext : String;
begin
  FinalPicture := TPicture.Create;
  TempPicture := TPicture.Create;
  try
   TempPicture.LoadFromFile(FileList[0]);
   NewWidth := (TempPicture.Width * FileList.Count) + ((FileList.Count -1) *5);
   FinalPicture.Bitmap.SetSize(NewWidth, TempPicture.Height);
   FinalPicture.Bitmap.Canvas.Draw(0, 0, TempPicture.Graphic);
   TempWidth := TempPicture.Width + 5;
   for i := 1 to (FileList.Count -1) do
   begin
     TempPicture.LoadFromFile(FileList[i]);
     FinalPicture.Bitmap.Canvas.Draw(TempWidth, 0, TempPicture.Graphic);
     TempWidth := TempWidth+ TempPicture.Width + 5;
   end;
   Ext := ExtractFileExt(FileList[0]);
   FinalPicture.SaveToFile(DirPath + '/' + Name + Ext);
  finally
    TempPicture.Free;
    FinalPicture.Free;
  end;
end;

function GetFileInFolder(DirPath: String): TStringList;
var FileList: TStringList;
begin
  FileList := FindAllFiles(DirPath, '*.*', False);
  Result := FileList;
  try
   //ShowMessage(IntToStr(FileList.Count) + ' файлов найдено. ' + FileList.Text);
  finally
    FileList.Free;
  end;
end;

//function GetPictureParametr(FileList: TStringList):

end.

