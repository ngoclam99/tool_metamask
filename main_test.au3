#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <File.au3>
#include <Array.au3>
#include <StringConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include "model.au3"
#include <Date.au3>
;~ Example()

Func Main()
   $file =  @scriptdir & "\key.txt"
   FileOpen($file, 0)
   Global $arr[1000]
   Global $array[1000000]
   ; Đọc file vào lưu vào mảng
   For $i = 1 to _FileCountLines($file)
	  $line = FileReadLine($file, $i)
	  ReDim $arr[_FileCountLines($file)+1]
	  $arr[$i] = $line
   Next

   ; Hiện mảng~ _ArrayDisplay($arr)
   Global $stt = 0;

   ; Thực hiện tách từng từ đưa vào mảng
   For $row in $arr  ;Loop through the array returned by StringSplit to display the individual values.
	  Local $string = "";
	  $string = StringSplit($row, " ");
	  For $i = 1 To $string[0]
		 $array[$stt] = $string[$i];
		 $stt+=1;
   ;~ 	  ConsoleWrite( "i["&$stt&"] = " & $string[$i]&@CRLF);
	  Next
   Next

   $t = MsgBox(4, "Thông báo", "Tool đang tiến hành thực hiện lưu dữ liệu random vào CSDL. Bấm OK để tiến hành");

   $i = 0;
   If $t = 6 Then
	  ; Hiển thị thanh tiến trình
	  ; Display a progress bar window.
	  ProgressOn("Đang thực hiện thêm key vào hệ thống", "Increments every second", "0%", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
	  ;~ Thực hiện Random chuỗi vào lưu vào file txt;
	  For $j = 0 To $stt
		 $random = RandomString($array, $stt);
		 $stringRandom = StringStripWS($random, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)
		 $check = CheckKey($stringRandom);
	  ;~    Kiểm tra những trường hợp chưa có trong CSDL mới insert thôi
		 IF $check == "" THEN
			$date = _NowCalc();
			$id = InsertHref($stringRandom, $date, 0)
	  ;~ 	  Lưu file nếu muốn
	  ;~ 	  SaveFile($stringRandom & @CRLF);
			$i += 1;
			ProgressSet($i, $i & " key")
		 EndIf

	  Next

	  ProgressSet(100, "Done", "Complete")
	  Sleep(5000)

	  ; Close the progress window.
	  ProgressOff()
	  MsgBox(1, "Thông báo", "Kết thúc!!!");
   EndIf

EndFunc

; Julian date of today.
;~ Local $sJulDate = _DateToDayValue(@YEAR, @MON, @MDAY)
;~ Local $Y, $M, $D
;~ $sJulDate = _DayValueToDate($sJulDate, $Y, $M, $D)
;~ MsgBox($MB_SYSTEMMODAL, "", "Thời gian hiện tại: " & $D & "/" & $M & "/" & $Y & "  (" & $sJulDate & ")")
;~ ConsoleWrite(_NowCalc());


;~ MsgBox(1, "Thông báo", "Đã lưu file xong");

;~ ConsoleWrite($stringRandom);

;~ _NowCalc() - thời gian hiện tại

;~ Đọc file
Func Example()
   ; Create a constant variable in Local scope of the filepath that will be read/written to.
   Local Const $sFilePath = @scriptdir & "\key.txt"

    ; Create a temporary file to read data from.
    If Not FileWrite($sFilePath, "This is an example of using FileRead.") Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Open the file for reading and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
        Return False
    EndIf

    ; Read the contents of the file using the handle returned by FileOpen.
    Local $sFileRead = FileRead($hFileOpen)

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)

    ; Display the contents of the file.
;~     MsgBox($MB_SYSTEMMODAL, "", "Contents of the file:" & @CRLF & $sFileRead)
	ConsoleWrite($sFileRead);


EndFunc   ;==>Example

; Hàm random string - Chr(Random(65, 122, 1)) hàm CHR trước mà lấy ký tự trong bảng Asc
Func RandomString($array, $stt)
   Global $randomStr = ""
   For $i = 1 To 12
	  $numberRand  = Random(0, $stt, 1);
	  $randomStr &= " " & $array[$numberRand];
   Next
   return $randomStr;
EndFunc

;~ Tạo 1 file  txt
Func SaveFile($string)
    ; Create a constant variable in Local scope of the filepath that will be read/written to.
    $sFilePath = "test.txt"

    ; Open the file for writing (append to the end of a file) and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_APPEND)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Write data to the file using the handle returned by FileOpen.
    FileWrite($hFileOpen, $string)

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)
EndFunc   ;==>SaveFile

Func SaveFileHtml($string)
    ; Create a constant variable in Local scope of the filepath that will be read/written to.
    $sFilePath = "test.html"

    ; Open the file for writing (append to the end of a file) and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_APPEND)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Write data to the file using the handle returned by FileOpen.
    FileWrite($hFileOpen, $string)

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)
EndFunc   ;==>SaveFile
