#include "WinHttp.au3"
#include "wd_core.au3"
#include "wd_helper.au3"
#include "String.au3"
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
#include "model.au3"

Local $sDesiredCapabilities, $iIndex, $sSession, $_WD_DEBUG, $_WD_DRIVER_CLOSE
Local $nMsg, $bProcess = False;
Global $time = _TimeGetStamp();

$_WD_DEBUG = $_WD_DEBUG_None; Tắt cửa sổ Debug
$_WD_DRIVER_CLOSE = false; Không kiểm tra và đóng các cửa sổ có sẵn
$sURL = "chrome-extension://nkbihfbeogaeaoehlefnkodbefgpgknn/home.html#initialize/create-password/import-with-seed-phrase"
SetupChrome()

_WD_Startup()

If @error <> $_WD_ERROR_Success Then
	Exit -1
EndIf

$sSession = _WD_CreateSession($sDesiredCapabilities)

; Phóng to trình duyệt lên
_WD_Window($sSession, "Maximize")

If @error = $_WD_ERROR_Success Then
   _WD_Navigate($sSession, $sURL)
   _WD_LoadWait($sSession, 1000)

   $sElementSelector = "//input[@id='create-new-vault__srp']"; Tham khảo cách bắt xpath: https://devhints.io/xpath

   $sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
   If @error = $_WD_ERROR_Success Then
	   ; Set element's contents
	  $getKey = get("tbl_key", 5);
;~ 	  ProgressOn("Đang thực hiện lấy key từ hệ thống ra bên ngoài", "Increments every second", "0 key", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
;~ 	  $i = 1;
;~ 	  ConsoleWrite($row &@CRLF);
;~ 	  Sleep(1000)
;~ 	  ProgressSet($i, $i & " key")
	  Local $null = '';
	  For $i = 0 To UBound($getKey) - 1
		 Sleep(3000)
		 If $i > 0 Then
			_WD_Navigate($sSession, $sURL)
			_WD_LoadWait($sSession, 1000)
		 EndIf

		 $sElementSelector = "//input[@id='create-new-vault__srp']";
		 $sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)

		 $id = $getKey[$i][0];
		 $text = $getKey[$i][1];

		 ConsoleWrite(@CRLF & "Send key: " & $text & @CRLF & "======================================" & @CRLF);
		 Sleep(300)
		 _WD_ElementAction($sSession, $sElement, "value", $text);

		 $hasError = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, "//span[@class='box box--margin-top-1 box--margin-right-0 box--margin-bottom-1 box--margin-left-0 box--flex-direction-row typography create-new-vault__srp-error typography--p typography--weight-normal typography--style-normal typography--color-error-1']")
		 $input_error = _WD_ElementAction($sSession, $hasError, 'Text')
		 $text_error = "OK";
		 $date = _NowCalc();
		 If $hasError <> '' Then
			   $ObjScreenShot = _WD_Screenshot($sSession, $sElement)
			   $FileName = $input_error&'.png'
			   $FilePath = FileOpen(@scriptdir&"/Screenshoot/"&'case_id_'&$id&'_'&$FileName, 18)
			   FileWrite($FilePath, $ObjScreenShot)
			   FileClose($FilePath)
			   $text_error = $input_error;
			   UpdateKey(1, $date, $text_error, $id);
			   ConsoleWrite("ID = " & $id & @CRLF);
			   _WD_ElementAction($sSession, $sElement, 'value', $null);
		 Else
			Local $time = _TimeGetStamp();
			UpdateKey(1, $date, "OK", $id)
			_WD_ElementAction($sSession, $sElement, 'value', $null);
			ConsoleWrite("OK" & @CRLF);
		 EndIf

		 Sleep(1000);
	  Next
;~ 	  ProgressSet($i, "Done", "Complete")
   EndIf
EndIf

Build();
MsgBox(1, "Thông báo", "Đã hoàn tất quá trình chạy tool, Trình duyệt sẽ đóng sau 3s");

Sleep(3000);
_WD_DeleteSession($sSession)
_WD_Shutdown()

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

Func SetupChrome()
	_WD_Option('Driver', 'chromedriver.exe')
	_WD_Option('Port', 9515)
	_WD_Option('DriverParams', '--verbose --log-path="' & @ScriptDir & '\chrome.log"')

 	$sDesiredCapabilities = '{"capabilities": {"alwaysMatch": {"goog:chromeOptions": {"w3c": true, "excludeSwitches": [ "enable-automation"]}}}}'


   $user_data_dir = "C:\Users\NguyenLam\AppData\Local\Google\Chrome\User Data"
   $user_data_dir = StringReplace($user_data_dir, "\", "#")
   $user_data_dir = StringReplace($user_data_dir, "#", "\\")
   ConsoleWrite($user_data_dir)

   $sDesiredCapabilities = '{"capabilities": {"alwaysMatch": {"goog:chromeOptions": {"w3c": true, "useAutomationExtension": false, "excludeSwitches": [ "enable-automation" ], "args":["start-maximized", "--user-data-dir=' & $user_data_dir & '", "--profile-directory=Default"]}}}}'

EndFunc   ;==>SetupChrome

Func _TimeGetStamp()
	Local $av_Time
	$av_Time = DllCall('CrtDll.dll', 'long:cdecl', 'time', 'ptr', 0)
	If @error Then
		SetError(99)
		Return False
	EndIf
	Return int($av_Time[0])
 EndFunc
