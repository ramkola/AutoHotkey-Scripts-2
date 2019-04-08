org_file = C:\Program Files\AutoHotkey\SciTE\tools\SUtility.ahk
bkp_file = C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\SciTE\utils\SUtility.ahk 

FileCopy, %org_file%, %bkp_file%, 1
IF ErrorLevel
    MsgBox, 16,, % "Could not copy `r`n`r`n" org_file "`r`n`r`nA_LastError: " A_LastError
Else
    MsgBox, 64,, % "Success.`r`n`r`n" org_file "`r`n`r`nCopied to:`r`n`r`n" bkp_file
ExitApp
