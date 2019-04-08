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

If (A_Args[1] = "#+PgUp")
    maximize_all()
Else If (A_Args[1] = "#PgUp")
    maximize_active()
Else If (A_Args[1] = "#!PgUp")
    restore_active()

ExitApp

maximize_all()
{
    Winget, windows_list, List
    Loop, %windows_list%
    {
        win_hwnd := "ahk_id " windows_list%A_Index%
        WinGetTitle, win_title, %win_hwnd%
        WinGet, process_name, ProcessName, %win_hwnd%
        OutputDebug, % "process_name: " process_name
        If RegExMatch(process_name, "i)(Dbgview|Calculator|PangoBright|Spy)\.exe")
            Continue    ; don't want these windows maximized
        WinGet, minmax_state, MinMax, %win_hwnd%
        If (win_title <> "") And (minmax_state = 0)
        {
            WinMaximize, %win_hwnd%
            Sleep 100
            
            WinGet, minmax_state, MinMax, %win_hwnd%
            If (minmax_state = 0)
                PostMessage, 0x112, 0xF030,,,%win_hwnd%  ; 0x112 = WM_SYSCOMMAND, 0xF030 = SC_MAXIMIZE

            Sleep 100
            WinGet, minmax_state, MinMax, %win_hwnd%
            If (minmax_state <> 1)
                OutputDebug, % "Could not maximize window hwnd: " win_hwnd " - " win_title
        }
    }
    MsgBox, 48,, % "WinMaximize All.........Done", 2
    Return  
}

maximize_active()
{
    WinGetTitle, win_title, A
    WinGet, minmax_state, MinMax, A
    If (minmax_state = 0)
        WinMaximize, A
        
    WinGet, minmax_state, MinMax, A
    If (minmax_state = 0)
        PostMessage, 0x112, 0xF030,,,A  ; 0x112 = WM_SYSCOMMAND, 0xF030 = SC_MAXIMIZE

    WinGet, minmax_state, MinMax, A
    If (minmax_state <> 1)
        MsgBox, 48,, % "Could not maximize:`r`n" win_title, 2
    Return
}

restore_active()
{
    WinGetTitle, win_title, A
    WinGet, minmax_state, MinMax, A
    If (minmax_state = 1)
        WinRestore, A
        
    WinGet, minmax_state, MinMax, A
    If (minmax_state = 1)
        PostMessage, 0x112, 0xF120,,,A  ; 0x112 = WM_SYSCOMMAND, 0xF120 = SC_RESTORE
    
    Sleep 100
    WinGet, minmax_state, MinMax, A
    If (minmax_state <> 0)
        MsgBox, 48,, % "Could not restore:`r`n" win_title " state = " minmax_state, 5
    Return
}
