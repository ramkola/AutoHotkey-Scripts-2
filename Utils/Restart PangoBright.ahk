#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
found := find_process("PangoBright.exe")
If found[1]
{ 
    proc_info := StrSplit(found[2],"`n","`r")
    proc_id := SubStr(proc_info[2], StrLen(" proc_id: ") + 1) 
    proc_exe := SubStr(proc_info[3], StrLen("exe_path: ") + 1)
    Process, Close, %proc_id%
    If (ErrorLevel != proc_id)
        OutputDebug, % "ErrorLevel: " ErrorLevel
}

If (proc_exe != "")
    Run, "%proc_exe%"
Else
    Run, "C:\Program Files (x86)\PangoBright.exe"

found := find_process("AutoHotkey", "pangolin.ahk")
If (found[1] != 0)
    Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\pangolin.ahk    
Else
    OutputDebug, % "Parameter not found: pangolin.ahk"
refresh_tray()  ; remove dead icons in systray if any

ExitApp 