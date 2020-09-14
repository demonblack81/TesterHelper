unit uGeneration;

interface

uses {$IFDEF WINDOWS}Windows,{$ENDIF} Classes, SysUtils, Math, FileUtil, LazUTF8;

const c_NUMERIC       = '0123456789';
      c_ENGALLSYMBOL  = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
      c_ENGLOWSYMBOL  = 'qwertyuiopasdfghjklzxcvbnm';
      c_ENGHIGHSYMBOL = 'QWERTYUIOPASDFGHJKLZXCVBNM';
      c_VALIDEMAILORURLSPECSYMBOL = '._-';
      
	  c_NUM 	          = 1; // Выбраны цифры (для UsingSymbol)
      c_SPEC 	          = 2; // Выбраны спецсимволы (для UsingSymbol)
      c_SPEC_NUM          = 3; // Выбраны спец символы и цифры (для UsingSymbol)
      c_ENGALL 	          = 5; // Выбраны все английские буквы (для UsingSymbol)
      c_ENGALL_NUM        = 6; // Выбраны все английские буквы и цифры (для UsingSymbol)
      c_ENGALL_SPEC       = 7; // Выбраны все английские буквы и спец символы (для UsingSymbol)
      c_ENGALL_SPEC_NUM   = 8; // Выбраны все английские буквы, спец символы и цифры (для UsingSymbol)
      c_ENGLOW 	         = 10; // Выбраны маленкие английские буквы (для UsingSymbol)
      c_ENGLOW_NUM       = 11; // Выбраны маленкие английские буквы и цифры (для UsingSymbol)
      c_ENGLOW_SPEC      = 12; // Выбраны маленкие английские буквы и спец символы (для UsingSymbol)
      c_ENGLOW_SPEC_NUM  = 13; // Выбраны маленкие английские буквы, спец символы и цифры (для UsingSymbol)
      c_ENGHIGH          = 20; // Выбраны большие английские буквы (для UsingSymbol)
      c_ENGHIGH_NUM      = 21; // Выбраны большие английские буквы и цифры (для UsingSymbol)
      c_ENGHIGH_SPEC     = 22; // Выбраны большие английские буквы и спец символы (для UsingSymbol)
      c_ENGHIGH_SPEC_NUM = 23; // Выбраны большие английские буквы, спец символы и цифры  (для UsingSymbol)
      c_RUALL 	         = 50; // Выбраны все русские буквы (для UsingSymbol)
      c_RUALL_NUM        = 51; // Выбраны все русские буквы и цифры (для UsingSymbol)
      c_RUALL_SPEC       = 52; // Выбраны все русские буквы и спец символы (для UsingSymbol)
      c_RUALL_SPEC_NUM   = 53; // Выбраны все русские буквы, спец символы и цифры (для UsingSymbol)
      c_RULOW            = 60; // Выбраны маленкие русские буквы (для UsingSymbol)
      c_RULOW_NUM        = 61; // Выбраны маленкие русские буквы и цифры (для UsingSymbol)
      c_RULOW_SPEC       = 62; // Выбраны маленкие русские буквы и спец символы (для UsingSymbol)
      c_RULOW_SPEC_NUM   = 63; // Выбраны маленкие русские буквы, спец символы и цифры (для UsingSymbol)
      c_RUHIGH           = 70; // Выбраны большие русские буквы (для UsingSymbol)
      c_RUHIGH_NUM       = 71; // Выбраны большие русские буквы и цифры (для UsingSymbol)
      c_RUHIGH_SPEC      = 72; // Выбраны большие русские буквы и спец символы (для UsingSymbol)
      c_RUHIGH_SPEC_NUM  = 73; // Выбраны большие русские буквы , спец символы и цифры (для UsingSymbol)
      c_All	        = 100; // Выбраны все символы


function GenerationZip(MaxNumeber: integer):String; // Генерация почтового индекса
function GenerationPhone(MaxNumeber: integer; Pluspresent:Boolean):String; // Генерация телефона
function GenerationNumber(MaxNumeber: integer):String; //Генерация цифровой строки
function GenerationString(MaxNumeber: integer; UsingSymbol:byte):String; //Генерация Строки
function GenerationEMail(MaxNumeber: integer):String; // Генерация e-mail
function GenerationUrl(MaxNumeber: integer):String; // Генерация урла
function GenerationPath(ExistsFile: boolean):String; // Генерация пути к файлу

procedure FindFiles(sDir :String);
procedure InitilzationSymbol; // иницилизация руских символов (делалось из за 2 байтовых руских символов) и инетзон
procedure FinilazeSymbol; // освобождаем память от StringList

var RuSymbol : TStringList;
    Inetzone : TStringList;
    InetScheme : TStringList;
    SpecialSimbol : TStringList;
    FilesOnDrive : TStringList;
    DirectoryOnDrive : TStringList;
    MaxFileFindOnDisk: integer;

implementation

procedure InitilzationSymbol;
var i : integer;
    DriveLetter: TStringList;
    Drives : array [0..255] of Char;
    p_DriveLetter: PChar;
    TempStr: String;
begin

 RuSymbol := TStringList.Create;
 {$IFDEF WINDOWS}
  Rusymbol.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\Data\RussionSymbol.txt');
 {$ELSE}
  TempStr := ParamStr(0);
  {$IFDEF UNIX}
   i := Pos('TesterHelper.app', TempStr);
   Delete(TempStr, i, (Length(TempStr) - i + 2) );
  {$ENDIF}
  {$IFDEF LINUX}
   i := Pos('TesterHelper/', TempStr);
   i := i + 13;
   Delete(TempStr, i, 12 );
  {$ENDIF}


  Rusymbol.LoadFromFile(TempStr + 'Data/RussionSymbol.txt');
 {$ENDIF}
 For i := 0 to (RuSymbol.Count-1) do begin
  Rusymbol.Strings[i] :=  SysToUTF8(Rusymbol.Strings[i]);
 end;

 Inetzone := TStringList.Create;
 {$IFDEF WINDOWS}
  Inetzone.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\Data\Inetzone.txt');
 {$ELSE}
  TempStr := ParamStr(0);
  {$IFDEF UNIX}
   i := Pos('TesterHelper.app', TempStr);
   Delete(TempStr, i, (Length(TempStr) - i + 2) );
  {$ENDIF}
  {$IFDEF LINUX}
   i := Pos('TesterHelper/', TempStr);
   i := i + 13;
   Delete(TempStr, i, 12 );
  {$ENDIF}  ;

  Inetzone.LoadFromFile(TempStr + 'Data/RussionSymbol.txt');
 {$ENDIF}
 For i := 0 to (Inetzone.Count-1) do begin
  Inetzone.Strings[i] :=  SysToUTF8(Inetzone.Strings[i]);
 end;

 
 InetScheme := TStringList.Create;
 {$IFDEF WINDOWS}
  InetScheme.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\Data\InetScheme.txt');
 {$ELSE}
  TempStr := ParamStr(0);
  {$IFDEF UNIX}
   i := Pos('TesterHelper.app', TempStr);
   Delete(TempStr, i, (Length(TempStr) - i + 2) );
  {$ENDIF}
  {$IFDEF LINUX}
   i := Pos('TesterHelper/', TempStr);
   i := i + 13;
   Delete(TempStr, i, 12 );
  {$ENDIF}

  InetScheme.LoadFromFile(TempStr + 'Data/RussionSymbol.txt');
 {$ENDIF}
 For i := 0 to (InetScheme.Count-1) do begin
  InetScheme.Strings[i] :=  SysToUTF8(InetScheme.Strings[i]);
 end;

 SpecialSimbol := TStringList.Create;
 {$IFDEF WINDOWS}
  SpecialSimbol.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\Data\SpecialSimbol.txt');
 {$ELSE}
  TempStr := ParamStr(0);
  {$IFDEF UNIX}
   i := Pos('TesterHelper.app', TempStr);
   Delete(TempStr, i, (Length(TempStr) - i + 2) );
  {$ENDIF}
  {$IFDEF LINUX}
   i := Pos('TesterHelper/', TempStr);
   i := i + 13;
   Delete(TempStr, i, 12 );
  {$ENDIF}

  SpecialSimbol.LoadFromFile(TempStr + 'Data/RussionSymbol.txt');
 {$ENDIF}
 For i := 0 to (SpecialSimbol.Count-1) do begin
  SpecialSimbol.Strings[i] :=  SysToUTF8(SpecialSimbol.Strings[i]);
 end;

 {$IFDEF WINDOWS}
 FilesOnDrive := TStringList.Create;
 DirectoryOnDrive := TStringList.Create;

 // Проверяем сколько есть разделов жестких дисков
 DriveLetter := TStringList.Create;
 if GetLogicalDriveStrings(256,Drives) > 256 then begin
  DriveLetter.Add('Bed read Drive Letter');
  Exit;
 end;
 
 p_DriveLetter := Drives;
 while p_DriveLetter^ <> #0 do begin
  i := GetDriveType(p_DriveLetter);
  if (i = DRIVE_FIXED) then begin
   DriveLetter.Add(p_DriveLetter);
  end;
  p_DriveLetter := p_DriveLetter + 4;
 end;
 
 //Находим файлы и папки на диске
 for i := 0 to (DriveLetter.Count - 1) do begin
  MaxFileFindOnDisk := 0;
  FindFiles(DriveLetter[i]);
 end; 
 
 DriveLetter.Free
 {$ENDIF}

 //{$IFDEF LINUX}
 // FindFiles('/');
 //{$ENDIF}  
end;

procedure FinilazeSymbol;
begin
  RuSymbol.Free;
  Inetzone.Free;
  InetScheme.Free;
  SpecialSimbol.Free;
  FilesOnDrive.Free;
  DirectoryOnDrive.Free;
end;

function GenerationZip(MaxNumeber: integer):String;
// Генерация почтового индекса
var  i: integer;
begin
 Result:= '';
 //Randomize;
 
 For i:= 0 to (MaxNumeber-1) do begin
  Result:= Result + c_NUMERIC[Random(10)+1];
  if (i = 0) and (StrToInt(Result) = 0) then begin
   Result:= '1';
  end;
 end;
 
 Trim(Result);
end;

function GenerationPhone(MaxNumeber: integer; Pluspresent:Boolean):String;
// Генерация Телефона
begin
 Result:= '';
 //Randomize;
 
 if (Pluspresent) then
 begin
  Result:= '+';
 end;
 
 While Length(Result) < MaxNumeber do begin
  Result:= Result + c_NUMERIC[Random(10)+1];
 end;
 Trim(Result);
end;


function GenerationNumber(MaxNumeber: integer):String;
// Генерация цифровой строки
begin
 Result:= '';
 //Randomize;
 
 While Length(Result) < MaxNumeber do begin
  Result:= Result + c_NUMERIC[Random(10)+1];
 end;
 Trim(Result);
end;



function GenerationString(MaxNumeber: integer; UsingSymbol:byte):String;
// Генерация строки
begin
 Result:= '';
 //Randomize;
 
 case (UsingSymbol) of
      c_NUM:
       begin
        Result:= GenerationNumber(MaxNumeber);       
       end;

      c_ENGALL:
       begin
        While Length(Result) < MaxNumeber do begin
         Result:= Result + c_ENGALLSYMBOL[Random(52)+1];
        end;
       end;

      c_ENGLOW:
       begin
        While Length(Result) < MaxNumeber do begin
         Result:= Result + c_ENGLOWSYMBOL[Random(26)+1];
        end;
       end;

      c_ENGHIGH:
       begin
        While Length(Result) < MaxNumeber do begin
         Result:= Result + c_ENGHIGHSYMBOL[Random(26)+1];
        end;
       end;

      c_SPEC:
       begin
        While Length(Result) < MaxNumeber do begin
	 Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	end;
       end;

      c_RUALL:
       begin
        While Length(Result) < (MaxNumeber*2) do begin
         Result:= Result + RuSymbol[Random(64)];
        end;
       end;

      c_RULOW:
       begin
        While Length(Result) < (MaxNumeber*2) do begin
         Result:= Result + RuSymbol[Random(32)];
        end;
       end;

      c_RUHIGH:
       begin
        While Length(Result) < (MaxNumeber*2) do begin
         Result:= Result + RuSymbol[RandomRange(32,64)];
        end;
       end;

      c_ENGALL_NUM:
       begin
        While Length(Result) < MaxNumeber do begin
         if Random(2) = 1 then begin
	  Result:= Result + c_ENGALLSYMBOL[Random(52)+1];
	 end else begin
	  Result:= Result + c_NUMERIC[Random(9)+1];
	 end;
        end;
       end;

      c_ENGALL_SPEC:
       begin
	While Length(Result) < MaxNumeber do begin
         if Random(2) = 1 then begin
	  Result:= Result + c_ENGALLSYMBOL[Random(52)+1];
	 end else begin
	  Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	 end;
        end;
       end;

      c_ENGALL_SPEC_NUM:
       begin
	While Length(Result) < MaxNumeber do begin
         case (Random(3)) of
	      0:
	       begin
	        Result:= Result + c_ENGALLSYMBOL[Random(52)+1];
	       end;

	      1:
	       begin
	        Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	       end;

	      2:
	       begin
	       Result:= Result + c_NUMERIC[Random(10)+1];
	      end;
	 end;
        end;
       end;
	   
      c_ENGLOW_NUM:
       begin
        While Length(Result) < MaxNumeber do begin
	 if Random(2) = 1 then begin
	  Result:= Result + c_ENGLOWSYMBOL[Random(26)+1];
	 end else begin
	  Result:= Result + c_NUMERIC[Random(10)+1];
	 end;
	end;
       end;
	   
      c_ENGLOW_SPEC:
       begin
        While Length(Result) < MaxNumeber do begin
	 if Random(2) = 1 then begin
	  Result:= Result + c_ENGLOWSYMBOL[Random(26)+1];
	 end else begin
	  Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	 end;
	end;
       end;
	  
      c_ENGLOW_SPEC_NUM:
       begin
	While Length(Result) < MaxNumeber do begin
         case (Random(3)) of
	      0:
	       begin
	        Result:= Result + c_ENGLOWSYMBOL[Random(26)+1];
	       end;

	      1:
	       begin
	        Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	       end;

	      2:
	       begin
	        Result:= Result + c_NUMERIC[Random(10)+1];
	       end;
	 end;
        end;
       end;
	  
      c_RUALL_NUM:
       begin
        
	While Length(Result) < MaxNumeber do begin
         if Random(2) = 1 then begin
	  Result:= Result + RuSymbol[Random(64)];
          MaxNumeber := MaxNumeber + 1;
	 end else begin
	  Result:= Result + c_NUMERIC[Random(10)+1];
	 end;
        end;
       end;

      c_RUALL_SPEC:
       begin
        
	While Length(Result) < MaxNumeber do begin
         if Random(2) = 1 then begin
	  Result:= Result + RuSymbol[Random(64)];
          MaxNumeber := MaxNumeber + 1;
	 end else begin
	  Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	 end;
        end;
       end;
	   
      c_RULOW_NUM:
       begin
        
	While Length(Result) < MaxNumeber do begin
         if Random(2) = 1 then begin
	  Result:= Result + RuSymbol[Random(32)];
          MaxNumeber := MaxNumeber + 1;
	 end else begin
	  Result:= Result + c_NUMERIC[Random(10)+1];
	 end;
        end;
       end;
	   
      c_RULOW_SPEC:
       begin
	While Length(Result) < MaxNumeber do begin
         if Random(2) = 1 then begin
	  Result:= Result + RuSymbol[Random(32)];
          MaxNumeber := MaxNumeber + 1;
	 end else begin
	  Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	 end;
        end;
       end;
	   
      c_RULOW_SPEC_NUM:
       begin
	While Length(Result) < MaxNumeber do begin
         case (Random(3)) of
	      0:
	       begin
	        Result:= Result + RuSymbol[Random(32)];
                MaxNumeber := MaxNumeber + 1;
	       end;

	      1:
	       begin
	        Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	       end;

	      2:
	       begin
	        Result:= Result + c_NUMERIC[Random(10)+1];
	       end;
	 end;
        end;
       end;

      c_RUALL_SPEC_NUM:
       begin
        
	While Length(Result) < MaxNumeber do begin
         case (Random(2)) of
	      0:
	       begin
	        Result:= Result + RuSymbol[Random(64)];
                MaxNumeber := MaxNumeber + 1;
	       end;

	      1:
	       begin
	        Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	       end;

	      2:
	       begin
	        Result:= Result + c_NUMERIC[Random(10)+1];
	       end;
	 end;
        end;
       end;

      c_SPEC_NUM:
       begin
        
	    While Length(Result) < MaxNumeber do begin
         if (Random(2)) = 1 then begin
	  Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
	 end else begin
	  Result:= Result + c_NUMERIC[Random(10)+1];
	 end;
        end;
       end;
	   
      c_All:
       begin
        While Length(Result) < MaxNumeber do begin
	 case (Random(9)) of
	      1:
	       begin
	        Result:= Result + c_NUMERIC[Random(10)+1];
	       end;
			  
	       2:
	        begin
		 Result:= Result + SpecialSimbol[Random(SpecialSimbol.Count)];
		end;
			  
		3:
		 begin
		  Result:= Result + RuSymbol[Random(64)];
                  MaxNumeber := MaxNumeber + 1;
		 end;
			  
		4:
		 begin
		  Result:= Result + RuSymbol[Random(32)];
                  MaxNumeber := MaxNumeber + 1;
		 end;
			  
		5:
		 begin
		  Result:= Result + c_ENGALLSYMBOL[Random(52)+1];
		 end;
			 
		6:
		 begin
		  Result:= Result + c_ENGLOWSYMBOL[Random(26)+1];
		 end;
			 
		7:
		 begin
		  Result:= Result + c_ENGHIGHSYMBOL[Random(26)+1];
                 end;
			  
		8:
		 begin
		  Result:= Result + RuSymbol[RandomRange(32, 64)];
                  MaxNumeber := MaxNumeber + 1;
                 end;
	 end;
	end;
       end;
	  
      else begin
       if (UsingSymbol = 0) then begin
        Result := '-1'; // Не Выбран не один из типов символов
       end else begin
        Result :=  IntToStr(UsingSymbol); // Не правельный код символов
       end;
      end;
  //Result :=  UTF8ToSys(Result);
 end;
 
 //Trim(Result);
end;

function GenerationEMail(MaxNumeber: integer):String;
{
  Делим максимум на 2 для символ перед и после @
  Генерируем первую часть (можно использовать спец символы "._-")
  Добовляем символ @
  Генерируем вторую часть(можно использовать спец символы "._-" но символы 3 4  не должны быть "--")
  Собираем всю стороку
}   
var i, PartOfMax, SpecExistsLength: integer;
    SpecExists: array [0..1] of integer;
    

begin
 Result := '';
 
 PartOfMax := MaxNumeber div 2;

 SpecExistsLength := Random(3); // Будут ли спец символы в первой части e-mail
 if SpecExistsLength <> 0 then begin
  For i := 0 to SpecExistsLength do begin
    SpecExists[i] := Random(PartOfMax);
  end;
 end;

 For i := 1 to PartOfMax do begin
  if Random(2)= 1 then begin
   Result := Result + c_ENGLOWSYMBOL[Random(26)+1];
  end else begin 
   Result:= Result + c_NUMERIC[Random(10)+1];
  end;
  if SpecExistsLength <> 0 then begin
   if (SpecExistsLength = 1) and (i = SpecExists[0])  then begin
    Result[i-1] := c_VALIDEMAILORURLSPECSYMBOL[Random(3)];
   end; 
   if (SpecExistsLength = 2) and (i = SpecExists[0]) or (i = SpecExists[1])   then begin
    Result[i-1] := c_VALIDEMAILORURLSPECSYMBOL[Random(3)];
   end;
  end; 
 end;

 SpecExistsLength := Random(3); // Будут ли спец символы во второй части e-mail
 if SpecExistsLength <> 0 then begin
  For i := 0 to SpecExistsLength do begin
    SpecExists[i] := Random(PartOfMax);
  end;
 end;

 Result := Result + '@'; 
 
 PartOfMax := (MaxNumeber - PartOfMax)  - 4; 
 For i:= 1 to PartOfMax do begin
  if Random(2)= 1 then begin
   Result := Result + c_ENGLOWSYMBOL[Random(26)+1];
  end else begin 
   Result:= Result + c_NUMERIC[Random(10)+1];
  end;
  if SpecExistsLength <> 0 then begin
   if (SpecExistsLength = 1) and (i = SpecExists[0])  then begin
    Result[i-1] := c_VALIDEMAILORURLSPECSYMBOL[Random(3)];
   end;
   if (SpecExistsLength = 2) and (i = SpecExists[0]) or (i = SpecExists[1])   then begin
    Result[i-1] := c_VALIDEMAILORURLSPECSYMBOL[Random(3)];
   end; 
  end;
  if (i = 4) and ((Result[Length(Result)] = '-') and (Result[Length(Result)-1] = '-')) then begin
   Result[Length(Result)] := 'a';
  end;
 end;

 Result := Result + Inetzone[Random(Inetzone.Count)];
end;

function GenerationUrl(MaxNumeber: integer):String; 
// Генерация урла
var i, SpecExistsLength : integer;
    SpecExists: array [0..1] of integer;
begin
 Result := '';
 
 // Выбераем случайную инетсхему 
 i := Random(InetScheme.Count);
 Result := Result + InetScheme[i];
 
 SpecExistsLength := Random(3); // Будут ли спец символы в первой части e-mail
 if SpecExistsLength <> 0 then begin
  For i := 0 to SpecExistsLength do begin
    SpecExists[i] := Random(MaxNumeber - 4);
  end;
 end;
 
 For i:= 1 to (MaxNumeber - 4) do begin
  if Random(2)= 1 then begin
   Result := Result + c_ENGLOWSYMBOL[Random(26)+1];
  end else begin 
   Result:= Result + c_NUMERIC[Random(10)+1];
  end;
  if SpecExistsLength <> 0 then begin
   if (SpecExistsLength = 1) and (i = SpecExists[0])  then begin
    Result[i-1] := c_VALIDEMAILORURLSPECSYMBOL[Random(3)];
   end;
   if (SpecExistsLength = 2) and (i = SpecExists[0]) or (i = SpecExists[1])   then begin
    Result[i-1] := c_VALIDEMAILORURLSPECSYMBOL[Random(3)];
   end; 
  end;
  if (i = 4) and ((Result[Length(Result)] = '-') and (Result[Length(Result)-1] = '-')) then begin
   Result[Length(Result)] := 'a';
  end;
 end;
 
 Result := Result + Inetzone[Random(Inetzone.Count)];
end;

procedure FindFiles(sDir :String);
var FileSerchRec: TSearchRec; // запись для поиска
    sFileName : String; // строка имени файла
begin
 if (sDir[Length(sDir)] <> '\') then sDir := sDir + '\';
 if FindFirst(sDir + '*.*', faAnyFile, FileSerchRec)=0 then begin
  repeat
   sFileName := ExtractFileDir(sDir);
   if (sFileName[Length(sFileName)] <> '\') then begin
    sFileName := sFileName + '\' + FileSerchRec.Name;
   end else begin
    sFileName := sFileName + FileSerchRec.Name;
   end;
   if (FileSerchRec.Attr and faDirectory > 0) and (FileSerchRec.Attr <> 22) then begin
    if (FileSerchRec.Name <> '') and (FileSerchRec.Name <> '.') and 
	   (FileSerchRec.Name <> '..') and (FileSerchRec.Name <> '\') then begin	 
     DirectoryOnDrive.Add(SysToUtf8(sFileName));
     FindFiles(sFileName);
    end;
   end else begin
    MaxFileFindOnDisk := MaxFileFindOnDisk + 1;
    FilesOnDrive.Add(SysToUtf8(sFileName));
   end;
   if MaxFileFindOnDisk >= 1000 then begin
    FindClose(FileSerchRec);
    exit;
   end;
  until FindNext(FileSerchRec) <> 0;
 end;
 FindClose(FileSerchRec);
end;

function GenerationPath(ExistsFile: boolean):String; 
// Генерация пути к файлу 
begin
 result := ''; 
 if (ExistsFile) then begin
  Result := FilesOnDrive[Random(FilesOnDrive.Count)];
 end else begin
  Result := DirectoryOnDrive[Random(DirectoryOnDrive.Count)]+ '\';
  Result := Result + GenerationString(Random(30), c_ENGALL_NUM);
  {$IFDEF WINDOWS}
  Result := Result + '.' + GenerationString(3, c_ENGLOW);
  {$ENDIF}
 end; 
end;


end.
