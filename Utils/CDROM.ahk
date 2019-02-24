#SingleInstance Force 
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Peripherals\SHELL32_12.ico
Run, MyScripts\Utils\Move xplorer2 CD Copy Status Window.ahk

DriveGet, cd_list, List, CDROM
cd_drive := cd_list ":"

Return

; ^#e:: Drive, Eject, %cd_drive%      ; eject
; ^!e:: Drive, Eject, %cd_drive%, 1   ; retract
^+j::   ; status                
    DriveGet, cd_status, StatusCD, %cd_drive%
    OutputDebug, % "- A_ThisFunc: " A_ThisFunc " | A_ThisHotkey: " A_ThisHotkey "`r`ncd_status: " cd_status 
    If (cd_status = "open")
    {
        Drive, Eject, %cd_drive%, 1
        WinActivate, VLC media player
        SendInput !{F4}
    }
    Else If (cd_status = "stopped")
        Drive, Eject, %cd_drive%
    Else
        MsgBox,,, % "unexpected cd_status: " cd_status "`n`nErrorLevel: " ErrorLevel, 1
    Return
