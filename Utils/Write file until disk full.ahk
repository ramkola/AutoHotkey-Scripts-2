#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
#NoTrayIcon

bigtext := ""
try 
{
    Loop 34000000
        bigtext .= "X"
}
MsgBox, 48,, % substr(bigtext,1,50) "`n`n" 1000s_sep(strlen(bigtext)), 5
 
While (Errorlevel = 0)
{
    ; FileAppend, %bigtext%, k:\bigfile1.junk
    FileAppend, %bigtext%, c:\users\mark\bigfile1.junk
    Sleep 1000
}

MsgBox, 48,, % "Done. ErrorLevel = " ErrorLevel " A_LastError = " A_LastError
ExitApp


^+x::ExitApp
