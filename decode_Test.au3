;~ $t = MsgBox (4, "test" ,"test")
;~ If $t = 6 Then
;~     SplashTextOn ("", "you have pressed Yes", 250, 30,-1,-1,1,-1,14,600)
;~     Sleep (2000)
;~ ElseIf $t = 7 Then
;~     SplashTextOn ("", "you have pressed No", 250, 30,-1,-1,1,-1,14,600)
;~     Sleep (2000)
;~ EndIf

#include <AutoItConstants.au3>

Example()

Func Example()
    ; Display a progress bar window.
    ProgressOn("Progress Meter", "Increments every second", "0%", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))

    ; Update the progress value of the progress bar window every second.
    For $i = 10 To 100 Step 10
        Sleep(1000)
        ProgressSet($i, $i & "%")
    Next

    ; Set the "subtext" and "maintext" of the progress bar window.
    ProgressSet(100, "Done", "Complete")
    Sleep(5000)

    ; Close the progress window.
    ProgressOff()
EndFunc   ;==>Example
