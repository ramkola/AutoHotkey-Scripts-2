; Note: FileFullPath of this script is also used in Notepad++ Run menu (Run AHK Current Script)
; and used in its custom toolbar buttons too. It is also defined with the same hotkey (F5)
; in MyHotkeys.ahk (not really necessary...but I am leaving it that way for now.)
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
WinMenuSelectItem, A,, File, Save
fname := get_filepath_from_wintitle()
If InStr(fname, "Manage Chrome Browsing History")
    fname  = C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Web\Manage Chrome Browsing History\Manager.ahk
If SubStr(fname, -3) = ".ahk"
    Run, %A_AhkPath% "%fname%"
Else
    MsgBox, 48,, % "Not an AHK script:`r`n" fname, 3
ExitApp
