; Thư viện dùng chung
; Gọi thư viện SQL Lite
#include <SQLite.au3>
#include <SQLite.dll.au3>

; Gọi hàm kết nối CSDL
ConnectDataBase("DB_Metamask.db")

; Hàm connectDatabase
Func ConnectDataBase($db = "")
   Global $hQuery, $aRow, $aNames
   _SQLite_Startup()
   ; Dùng để kiểm tra file sql3.dll
   If @error Then
	   MsgBox($MB_SYSTEMMODAL, "SQLite Error", "SQLite3.dll Can't be Loaded!")
	   Exit -1
   EndIf

   ; Hiển thị version của SQLite - ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
   ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)

   ; Gọi hàm mở kết nối tới CSDL
   _SQLite_Open($db)
EndFunc

; Hàm CloseConnectDatabse
Func CloseConnection($hQuery)
   ; Tránh tràn bộ nhớ ram
   _SQLite_QueryFinalize($hQuery)
   _SQLite_Close()
   _SQLite_Shutdown()
EndFunc

; Lấy bảng dữ liệu
Func get( $table, $limit)
   Local $array[$limit][2];
   ConnectDataBase("DB_Metamask.db");
   ; Lấy CSDL
   _SQLite_Query(-1, "SELECT * FROM " & $table &" WHERE status = 0 ORDER BY id LIMIT " & $limit, $hQuery)
   _SQLite_FetchNames($hQuery, $aNames)
   $i = 0;
   While _SQLite_FetchData($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
	  $array[$i][0] = $aRow[0]
	  $array[$i][1] = $aRow[1]
	  $i += 1;
;~ 	  ConsoleWrite($aRow[0]&@TAB&$aRow[1]& @CRLF)
   WEnd

   ; Hàm đóng kết nối CSDL
   CloseConnection($hQuery);
;~    _ArrayDisplay($array);
   return $array;
EndFunc

; Lấy bảng dữ liệu
Func get_key( $table, $array_size)
   Local $array[$array_size][7];
   ConnectDataBase("DB_Metamask.db");
   ; Lấy CSDL
   _SQLite_Query(-1, "SELECT * FROM " & $table &" WHERE status = 1 ORDER BY id", $hQuery)
   _SQLite_FetchNames($hQuery, $aNames)
   $i = 0;
   While _SQLite_FetchData($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
	  $array[$i][0] = $aRow[0]
	  $array[$i][1] = $aRow[1]
	  $array[$i][2] = $aRow[2]
	  $array[$i][3] = $aRow[3]
	  $array[$i][4] = $aRow[4]
	  $array[$i][5] = $aRow[5]
	  $i += 1;
;~ 	  ConsoleWrite($aRow[0]&@TAB&$aRow[1]& @CRLF)
   WEnd

   ; Hàm đóng kết nối CSDL
   CloseConnection($hQuery);
;~    _ArrayDisplay($array);
   return $array;
EndFunc


; Lấy xóa dữ liệu
Func Delete( $table, $key, $column)
   ; Lấy CSDL
   _SQLite_Query(-1, "DELETE FROM " & $table & " WHERE " & $key & "=" & $column, $hQuery)
   _SQLite_FetchNames($hQuery, $aNames)
   While _SQLite_FetchData($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
	   ConsoleWrite($aRow[0]&@TAB&$aRow[1]& @CRLF)
   WEnd

   ; Hàm đóng kết nối CSDL
   CloseConnection($hQuery);
EndFunc

; Insert CSDL

Func InsertKey($key, $date, $status)
   $_ex = _SQLite_Exec(-1, "INSERT INTO tbl_key VALUES (NULL, "& _SQLite_Escape($key) &","& _SQLite_Escape($date)&","& _SQLite_Escape($status) &", 0, NULL);")
   $LastInsertID = 0;
   if $_ex = $SQLITE_OK then
	  $LastInsertID = _SQLite_LastInsertRowID();
;~ 	  ConsoleWrite("id" & $LastInsertID)
;~ 	  ConsoleWrite("_SQLite_LastInsertRowID = "&$LastInsertID& @CRLF)
   EndIf
   Return $LastInsertID;
EndFunc

Func UpdateKey($status, $updatetime, $ghichu, $id)
   ConnectDataBase("DB_Metamask.db");
   $_ex = _SQLite_Exec(-1, "UPDATE tbl_key SET status = " & $status &", updatetime = " & _SQLite_Escape($updatetime) & ", ghichu = " & _SQLite_Escape($ghichu) & " WHERE id = " & $id & ";")
   $LastInsertID = 0;
   if $_ex = $SQLITE_OK then
	  $status = 1;
;~ 	  ConsoleWrite("UPDATE tbl_key SET status = " & $status &", updatetime = " & _SQLite_Escape($updatetime) & ", ghichu = " & _SQLite_Escape($ghichu) & " WHERE id = " & $id & ");" & @CRLF)
   Else
	  ConsoleWrite(@CRLF & "Update thất bại" & @CRLF)
   EndIf
   CloseConnection($hQuery);
   Return $status;
EndFunc

; Kiểm tra xem có tồn tại trong CSDL chưa
Func CheckKey($key)
   Local $aRow = "";
   $sql = "SELECT * FROM tbl_key WHERE title_key = " & _SQLite_Escape($key);
   _SQLite_QuerySingleRow(-1, $sql , $aRow) ; Select single row and single field !
   If $aRow <> 0 Then
	  return $aRow[0]
   Else
	  return "";
   EndIf
   ; Hàm đóng kết nối CSDL
   CloseConnection($hQuery);
EndFunc

Func getRow($tb)
   Global $i = 0;
   For $s In $tb
	  If ($s <> "")  Then
		 $i = $i + 1
	  EndIf
   Next
   return $i
EndFunc

; Hàm check status của trang web
Func _URLStatus($aURL)
    $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
    $oHTTP.Open("GET", $aURL, False)
    $oHTTP.Send()
    Return $oHTTP.Status = 200
EndFunc   ;==>_URLStatus





