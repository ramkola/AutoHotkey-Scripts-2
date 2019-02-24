#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
#NoTrayIcon

text_string := "x" 
While (Errorlevel = 0)
{
    FileDelete, k:\keep_kdrive_active.junk
    FileAppend, %text_string%, k:\keep_kdrive_active.junk
    Sleep 1800000    ; 30 minutes   - test by increments of 300,000 (5 minutes)
}

MsgBox, 48,, % "Done. ErrorLevel = " ErrorLevel " A_LastError = " A_LastError
ExitApp


^+x::ExitApp
