#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%

Process, Exist, PangoBright.exe
proc_id := ErrorLevel
If proc_id
{ 
    Process, Close, proc_id
    If (ErrorLevel != proc_id)
        OutputDebug, % "Could not kill PangoBright. ErrorLevel: " ErrorLevel
}
Run, "C:\Program Files (x86)\PangoBright.exe" 
dimmer_level := (A_Args[1] == "") ? 7 : A_Args[1]   ; 7 = default pango %70
Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\pangolin.ahk %dimmer_level%
refresh_tray()  ; remove dead icons in systray if any

ExitApp 