#include "WinHttp.au3"
#include "wd_core.au3"
#include "wd_helper.au3"
#include "String.au3"

Local $sDesiredCapabilities, $iIndex, $sSession, $_WD_DEBUG, $_WD_DRIVER_CLOSE
Local $nMsg, $bProcess = False;
$_WD_DEBUG = $_WD_DEBUG_None; Tắt cửa sổ Debug
$_WD_DRIVER_CLOSE = false; Không kiểm tra và đóng các cửa sổ có sẵn
$sURL = "https://www.google.com/"
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
   _WD_LoadWait($sSession, 2000)

   $sElementSelector = "//input[@name='q']"; Tham khảo cách bắt xpath: https://devhints.io/xpath

   $sElement = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
   If @error = $_WD_ERROR_Success Then
	   ; Set element's contents
	   _WD_ElementAction($sSession, $sElement, 'value', "testing 123")
	   Sleep(500)
	  _WD_ElementAction($sSession, $sElement, 'click')

	  $sElementSelector = "//input[@name='btnK']"
   	  $sButton = _WD_FindElement($sSession, $_WD_LOCATOR_ByXPath, $sElementSelector)
	  If @error = $_WD_ERROR_Success Then
		 	_WD_ElementAction($sSession, $sButton, 'click')
			_WD_LoadWait($sSession, 2000)
	  EndIf
   EndIf
	MsgBox($MB_ICONINFORMATION, "Demo complete!", "Click ok to shutdown the browser and console")
EndIf

_WD_Shutdown()

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