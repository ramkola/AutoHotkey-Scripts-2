#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, NoIcon

; Need to create a run command that looks like this - pay attention to quotes and spaces:
; "C:\Program Files\7-Zip\7z.exe" a "C:\Users\Mark\Google Drive\Misc Backups\Notepad++\backup\AutoHotkey Backup - 2018-07-06-0219.zip" *.* -r- -ir@"Misc\7zip Include List - Autohotkey Backup.txt" -xr@"Misc\7zip Exclude List - Autohotkey Backup.txt"
backup_path := "C:\Users\Mark\Google Drive\Misc Backups\Notepad++\backup"
FormatTime, time_stamp,,yyyy-MM-dd-HHmm  
zip_name := "C:\Users\Mark\Google Drive\Misc Backups\Notepad++\backup\AutoHotkey Backup - " time_stamp ".zip"
include_list := "Misc\7zip Include List - Autohotkey Backup.txt" 
exclude_list := "Misc\7zip Exclude List - Autohotkey Backup.txt" 
out_file := "Misc\AutoHotkey_Backup_Results.txt"

; two types of backups are run whose results go into 1 zip file
; *.* -r-
; Backup files only in AHK_ROOT_DIR no recursion
;
; -ir@.....-xr@
; backup included directories recursively, exclude
; unwanted subdirectories. This is necessary because
; subdirectories with the same name as included directories 
; get added even though they are in different paths.

zip_command := chr(34) "C:\Program Files\7-Zip\7z.exe" chr(34) " a "  
zip_command .= chr(34) zip_name chr(34)  
zip_command .= " *.* -r- -ir@" chr(34) include_list chr(34)
zip_command .= " -xr@" chr(34) exclude_list chr(34)
; zip_command .= " > " chr(34) out_file chr(34) 

Clipboard := zip_command
RunWait, %zip_command% 

; delete old archives
Loop, Files, %backup_path%\AutoHotkey Backup - *.zip, F
{
    difference := A_Now
    Envsub, difference, A_LoopFileTimeCreated, seconds
    difference := difference / 86400.0 ; float - number of seconds in a day 60x60x24
    If (difference > 15.0)
    {
        ; delete if 15 days old
        FileDelete, %A_LoopFileLongPath%
    }
}    

; Run, explorer.exe %backup_path%

ExitApp
