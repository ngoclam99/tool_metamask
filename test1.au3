#include <INet.au3> ; needed for get source (hmtl)
#include <String.au3> ; needed for stringbetween
#include <File.au3>

$file =  @scriptdir & "\test.txt"
FileOpen($file, 0)
Global $arr[1000]

FileDelete ("test.html");
For $i = 1 to _FileCountLines($file)
   $line = FileReadLine($file, $i)
   SaveFileHtml($i, $line)
Next

Func SaveFileHtml($i, $string)
    ; Create a constant variable in Local scope of the filepath that will be read/written to.
   $sFilePath = "test.html";

    ; Open the file for writing (append to the end of a file) and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_APPEND)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Write data to the file using the handle returned by FileOpen.
    FileWrite($hFileOpen, "<p>" & $i & "." & $string & "</p>" &@CRLF)

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)
EndFunc   ;==>SaveFile
