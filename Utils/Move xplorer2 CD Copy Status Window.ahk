#SingleInstance Force 
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Peripherals\SHELL32_12.ico
SetCapslockState, AlwaysOff
SetTitleMatchMode RegEx

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
Sleep 10

DriveGet, cd_list, List, CDROM
cd_drive := cd_list ":"

save_coordmode := A_CoordModeMouse
copying_cdrom := False
window_moved := False
keep_checking := True
While keep_checking 
{       
    ;==========================================================
    ; The order the following checks are performed is important
    ;==========================================================
    If WinExist("xplorer. ahk_class #32770 ahk_exe xplorer2_lite.exe")
    {
        WinActivate
        WinWaitActive,,,2
        If ErrorLevel
            OutputDebug, % "Timeout activating background processes dialog."
        Else
            SendInput !y    ; answer Yes to run background processes 
    }

    If Not WinExist("ahk_class OperationStatusWindow ahk_exe xplorer2_lite.exe") and copying_cdrom
    {
        Drive, Eject
        copying_cdrom := False
        MsgBox, 48,, % "CD ROM finished copy."
        Continue
    }

    If Not WinExist("ahk_class OperationStatusWindow ahk_exe xplorer2_lite.exe")
    {
        window_moved := False
        Sleep 500
        Continue
    }

    
    If window_moved
    {
        Sleep 500
        Continue
    }   
    ;==========================================================
    ; The order the above checks are performed is important
    ;==========================================================
    WinActivate         ; xplorer2 copy status window is last found
    WinWaitActive,,,2
    If ErrorLevel
    {
        OutputDebug, % "Timeout activating copy status window"
        Continue
    }
    CoordMode, Mouse, Window
    MouseGetPos, save_x, save_y
    WinGetPos, x, y, w, h, ahk_class OperationStatusWindow ahk_exe xplorer2_lite.exe
    ; OutputDebug, % "x, y, w, h: " x ", " y ", " w ", " h
    ; mouseclickdrag....
    BlockInput, On
    MouseMove w/2, 10 
    SendInput {Click, Left, Down}
    CoordMode, Mouse, Screen
    MouseMove (w/2) - 10, A_ScreenHeight - h - 20
    SendInput {Click, Left, Up}
    copying_cdrom := True
    
    While WinExist("xplorer.*DVD RW Drive \(D:\) NEW[]]{0,1} #.* ahk_class ATL:ExplorerFrame ahk_exe xplorer2_lite.exe")
        WinClose
    ;
    window_moved := True
    CoordMode, Mouse, Window
    MouseMove, save_x, save_y
    BlockInput, Off
}
CoordMode, Mouse, %save_coordmode%
OutputDebug, % "A_CoordModeMouse: " A_CoordModeMouse

ExitApp

#IFWinActive

^!+j::   
    SetCapslockState, AlwaysOff
    OutputDebug, % "A_ThisFunc: " A_ThisFunc " - A_ThisHotkey: " A_ThisHotkey " - A_ScriptName: " A_ScriptName
    DriveGet, cd_status, StatusCD, %cd_drive%
    OutputDebug, % "cd_drive: " cd_drive
    OutputDebug, % "cd_status: " cd_status
    If (cd_status = "open")
        Drive, Eject, %cd_drive%, 1
    Else If (cd_status = "stopped")
        Drive, Eject, %cd_drive%
    Else
        MsgBox,,, % "unexpected cd_status: " cd_status "`n`nErrorLevel: " ErrorLevel, 1
    Return


CapsLock & x:: keep_checking := False
