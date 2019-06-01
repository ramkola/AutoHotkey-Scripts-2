/* 
    Turns off montior and disables all mice until Escape key is pressed.

    Needs to be run as administrator either set a shortcut to 
    "Run As Administrator" (only 1 UAC prompt) or enable the 
    *RunAs options (2 UAC prompts. 1 for each RunAs command)

    Note:
        Hitting any keyboard key wakes the montior but only Escape 
        key will re-enable mice.
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
; Run *RunAs "%A_ProgramFiles%\devcon.exe" Disable *mouse*
SendMessage,0x112,0xF170,2,,Program Manager         ; turn off monitor (sleep)
If Not ErrorLevel
    Run, "%A_ProgramFiles%\devcon.exe" Disable *mouse*
Else
{
    MsgBox, % "Could not turn off monitor"
    Goto Escape
}
Return

Escape::
    ; Run *RunAs "%A_ProgramFiles%\devcon.exe" Enable *mouse*
	Run, "%A_ProgramFiles%\devcon.exe" Enable *mouse*
    ExitApp

^+x::   ; in case of emergency this will re-enable mice no matter how mice were disabled (Run or *RunAs)
    Run *RunAs "%A_ProgramFiles%\devcon.exe" Enable *mouse*
    ExitApp
