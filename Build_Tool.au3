#include <String.au3> ; needed for stringbetween
#include <File.au3>
#include "model.au3"
Build();
Func Build()
   $file =  @scriptdir & "\test.txt"
   FileOpen($file, 0)
   Global $arr[1000]

   FileDelete ("Build.html");

   $sFilePath = "Build.html";

   ConnectDataBase("DB_Metamask.db");
   ; Lấy CSDL
   _SQLite_Query(-1, "SELECT * FROM tbl_key WHERE status = 1 AND ghichu = 'OK' ORDER BY id", $hQuery)
   _SQLite_FetchNames($hQuery, $aNames)
   $i = 0;
   While _SQLite_FetchData($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
	  $id = $aRow[0];
	  $key = $aRow[1];
	  $time_add = $aRow[2];
	  $status = $aRow[3];
	  $time_update = $aRow[4];
	  $note = $aRow[5];
	  SaveFileHtml($i, $id, $key, $time_add, $time_update, $note)
   ;~ 	  ConsoleWrite($aRow[0]&@TAB&$aRow[1]& @CRLF)
	  $i += 1;
   WEnd

	  ; Hàm đóng kết nối CSDL
   CloseConnection($hQuery);

   MsgBox(0, "Thông báo", "Đã build xong file Build.html")
EndFunc


Func SaveFileHtml($i, $id, $key, $time_add, $time_update, $note)
    ; Create a constant variable in Local scope of the filepath that will be read/written to.
   $sFilePath = "Build.html";

    ; Open the file for writing (append to the end of a file) and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_APPEND)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Write data to the file using the handle returned by FileOpen.
   FileWrite($hFileOpen, "<p> ID = " & $id & "" &@CRLF)
   FileWrite($hFileOpen, "<span>---- TIME_ADD = " & $time_add & "</span>" &@CRLF)
   FileWrite($hFileOpen, "<span>---- TIME_UPDATE = " & $time_update & "</span>" &@CRLF)
   FileWrite($hFileOpen, "<span>----- NOTE = " & $note & "</span>" &@CRLF)
   FileWrite($hFileOpen, "<p>--- KEY = <b>" & $key & "</b></p>" &@CRLF)
   FileWrite($hFileOpen, "<p>=================================================================</p>" &@CRLF)


    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)
EndFunc   ;==>SaveFile
