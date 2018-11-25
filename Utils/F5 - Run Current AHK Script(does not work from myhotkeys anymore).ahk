#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\npp.ahk

WinMenuSelectItem, A,, Plugins, DBGp, Stop
WinMenuSelectItem, A,,File,Save
Sleep 10
fname := get_current_npp_filename_ahk_version()
OutputDebug, %A_AhkPath% "%fname%"
Run, %A_AhkPath% "%fname%"
Return

ExitApp

