;*******************************************************
; Note: Shift+LWin disabled in Classic Shell 
;       Settings/Controls/Shift+LWin opens "Nothing"
;
; minmax_state -1 - The window is minimized (WinRestore can unminimize it). 
; minmax_state  1 - The window is maximized (WinRestore can unmaximize it).
; minmax_state  0 - The window is neither minimized nor maximized.
;*******************************************************
#SingleInstance Force
#NoTrayIcon
SetTitleMatchMode 2
DetectHiddenWindows, Off

; OutputDebug, DBGVIEWCLEAR
; A_Args[1] := "#+PgUp"
; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
exclude_list = 
(Join LTrim
    Program Manager|Dbgview|Calculator|
    PangoBright|Window Spy|Malwarebytes|
    mbamtray|Backup and Sync|\bexplorer\.exe\b|
    googledrivesync
)

If (A_Args[1] = "#+PgUp")
    maximize_all(exclude_list)
Else 
    toggle_minmax_active()
ExitApp

maximize_all(p_exclude_list)
{
    WinGet, windows_id_list, List
    proc_array := []
    Loop, %windows_id_list%
    {
        process_hwnd := "ahk_id " windows_id_list%A_Index%
        WinGet, process_exe, ProcessName, %process_hwnd%
        WinGet, process_pid, PID, %process_hwnd%
        WinGetTitle, process_wintitle, %process_hwnd%
        proc_array.Push([StrReplace(process_hwnd,"ahk_id ",""), process_pid, process_exe, process_wintitle])
    }

    OutputDebug, % A_ScriptName " (" A_ThisFunc ") Results:" 
    For i, proc_info in proc_array
    {
        process_hwnd := proc_info[1]
        process_pid := proc_info[2]
        process_exe := proc_info[3]
        process_wintitle := proc_info[4]
        wintitle_exclude := RegExMatch(process_wintitle, "i)(" p_exclude_list ")""")
        exe_exclude := RegExMatch(process_exe, "i)" p_exclude_list "")
        If wintitle_exclude or exe_exclude
        {
            OutputDebug, % Format("Skipping window: {:-40} | {:-40} | {:5} | {:-8}`n", process_exe, substr(process_wintitle, 1, 40), process_pid, process_hwnd)
            Continue
        }
        Else
        {
            maximize_active(process_hwnd)
        }
    }
    MsgBox, 48,, % "WinMaximize All.........Done", 2
    Return  
}

toggle_minmax_active()
{
    WinGet, minmax_state, MinMax, A
    If (minmax_state = 0)
        maximize_active()
    Else 
        restore_active()
    Return
}

maximize_active(p_hwnd := "")
{
    p_hwnd := (p_hwnd == "") ? "A" : "ahk_id " p_hwnd
    WinGetTitle, win_title, %p_hwnd%
    WinGet, minmax_state, MinMax, %p_hwnd%
    If (minmax_state = 0)
        WinMaximize, %p_hwnd%

    Sleep 10    
    WinGet, minmax_state, MinMax, %p_hwnd%
    If (minmax_state = 0)
        PostMessage, 0x112, 0xF030,,,A  ; 0x112 = WM_SYSCOMMAND, 0xF030 = SC_MAXIMIZE

    Sleep 10    
    WinGet, minmax_state, MinMax, %p_hwnd%
    If (minmax_state <> 1) and (p_hwnd = "A")
        MsgBox, 48,, % "Could not maximize:`r`n" win_title " state = " minmax_state, 5
    Return (minmax_state = 1)
}

restore_active()
{
    WinGetTitle, win_title, A
    WinGet, minmax_state, MinMax, A
    If (minmax_state = 1)
        WinRestore, A
        
    Sleep 10    
    WinGet, minmax_state, MinMax, A
    If (minmax_state = 1)
        PostMessage, 0x112, 0xF120,,,A  ; 0x112 = WM_SYSCOMMAND, 0xF120 = SC_RESTORE
    
    Sleep 10    
    WinGet, minmax_state, MinMax, A
    If (minmax_state <> 0)
        MsgBox, 48,, % "Could not restore:`r`n" win_title " state = " minmax_state, 5
    Return (minmax_state = 0)
}

