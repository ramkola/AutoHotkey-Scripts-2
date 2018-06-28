#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%
Menu, Tray, NoIcon

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

; Need to create a run command that looks like this - pay attention to quotes and spaces:
; "C:\Program Files\7-Zip\7z.exe" a "AutoHotkey Backup - 2018-06-16 0457.zip" "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\"
backup_path := "C:\Users\Mark\Google Drive\Misc Backups\Notepad++\backup"
FormatTime, time_stamp,,yyyy-MM-dd-HHmm  
zip_name := backup_path . "\AutoHotkey Backup - " . time_stamp . ".zip"
zip_command := chr(34) . "C:\Program Files\7-Zip\7z.exe" . chr(34) . " a " 
zip_command .= chr(34) . zip_name . chr(34) . A_Space 
zip_command .= chr(34) . AHK_MY_ROOT_DIR . "\" . chr(34)

Loop, Files, %backup_path%\AutoHotkey Backup - *.zip, F
{
    difference := A_Now
    Envsub, difference, A_LoopFileTimeCreated, seconds
    difference := difference / 86400.0 ; float - number of seconds in a day 60x60x24
    If (difference > 3.0)
    {
        ; delete if 3 days old
        FileDelete, %A_LoopFileLongPath%
    }
}    

Run, %zip_command% 
; Run, explorer.exe %backup_path%

ExitApp
