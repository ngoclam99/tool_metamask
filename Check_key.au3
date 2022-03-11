#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <File.au3>
#include <Array.au3>
#include <StringConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Date.au3>
#include "Main.au3"
#include "wd_core.au3"
#include "wd_helper.au3"
#include "openChrome.au3"

;~ Kiểm tra xem có muốn thêm dữ liệu vào hệ thống không;
$t = MsgBox (4, "Thông báo" ,"Bạn có muốn thực hiện thêm key vào hệ thống không?")
If $t = 6 Then
   Main();
Else
   Main_Tool();
EndIf

;~ Lấy key từ cơ sở dữ liệu ra
$getKey = get("tbl_key", 10);
;~ ProgressOn("Đang thực hiện lấy key từ hệ thống ra bên ngoài", "Increments every second", "0 key", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
;~ $i = 1;

For $i = 0 To UBound($getKey)
;~    ConsoleWrite($getKey[$i][0] &@CRLF);
;~    ConsoleWrite($getKey[$i][1] &@CRLF);

;~    Sleep(1000)
;~    ProgressSet($i, $i & " key")
;~    $i += 1;
Next
;~ UBound($getKey) - để lấy số dòng trong mảng
;~ ProgressSet($i, "Done", "Complete")

;~ ToolTip("Trình duyệt Chrome", 0, 0)
;~ Sleep(2000) ; Sleep to give tooltip time to display
;~ HotKeySet('{esc}', '_exit')
;~ HotKeySet("{f6}", 'AutoRun')

Func AutoRun()
   MsgBox(0, "ThongBao", "Hi");

   $title = "[REGEXPTITLE:(?i) (.*Google Chrome.*)]"
   $count = 0;
;~    While 1
	  Sleep(1500)
	  ControlClick($title, "", "", "left", 1, 340, 461)
	  Send("monster kingdom skirt angle patch frost pluck inch twice learn swift brick");

	  Sleep(500)
;~    WEnd
EndFunc

Func _Exit()
   MsgBox(0, "ThongBao", "Ket Thuc nhé!");
   Exit
EndFunc