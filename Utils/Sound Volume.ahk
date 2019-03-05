#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\trayicon.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
; #NoTrayIcon
SetTitleMatchMode 2
OutputDebug, DBGVIEWCLEAR                           

volume_wintitle = Speakers (Realtek High Definition Audio) ahk_class #32770 ahk_exe SndVol.exe
master_classnn := ""

Return 

CapsLock & WheelUp::
CapsLock & WheelDown:: 
    SetCapsLockState, AlwaysOff

OutputDebug, % "master_classnn before: >" master_classnn "<"

    If Not WinExist(volume_wintitle) or (master_classnn == ""S )
        master_classnn := start_volume_mixer(volume_wintitle)

    WinActivate, %volume_wintitle%
    WinWaitActive, %volume_wintitle%,, 3  
    ControlFocus, %master_classnn%, A

OutputDebug, % "master_classnn after: >" master_classnn "<"

    If (A_ThisHotkey = "Capslock & WheelUp")
        SendInput {Up 3}
    Else If (A_ThisHotkey = "Capslock & WheelDown") 
        SendInput {Down 3}
    Else If (A_ThisHotkey = "Capslock & MButton") 
        SendInput {Escape}
    Else
    {
        OutputDebug, % "Unexepected hotkey: " A_ThisHotkey " (" A_ScriptName ")"
        Return
    }
    Return 

start_volume_mixer(volume_wintitle)    
{
    Run %A_WinDir%\System32\SndVol.exe
    If ErrorLevel
    {
        MsgBox, 48,, % "No Volume Mixer Window", 10
        Return
    }
    WinGet, control_list, ControlList, %volume_wintitle%
    Sort control_list
    Loop, Parse, control_list, "`r`n"
    {
        If InStr(A_LoopField, "msctls_trackbar") 
            master_classnn := A_LoopField   ; the last one is the master volume it has the highest classNN
    }
    ControlFocus, %master_classnn%, A
OutputDebug, % "master_classnn: " master_classnn " " A_ThisFunc
    Return  %master_classnn%
}

^+x::ExitApp
