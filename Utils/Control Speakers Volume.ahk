#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\trayicon.ahk
#NoTrayIcon
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

volume_wintitle = Volume Mixer - Speakers (Realtek High Definition Audio) ahk_class #32770 ahk_exe sndvol.exe
#If WinActive(volume_wintitle)

Run, sndvol.exe
WinWaitActive, %volume_wintitle%

WinGet, control_list, ControlList, A
Sort control_list, R      ; reverse sort will highest classnn first and that is the speakers_classn
Loop, Parse, control_list, `n, `r
{
    If Instr(A_LoopField, "msctls_trackbar32")
    {
        speakers_classn := A_LoopField
        Break
    }
}

WheelUp::
WheelDown::
    If A_TimeSincePriorHotkey > 1500
    {
        WinClose, %volume_wintitle%
        ExitApp
    }
    ControlClick, %speakers_classn%, %volume_wintitle%,, %A_ThisHotkey%
    Return