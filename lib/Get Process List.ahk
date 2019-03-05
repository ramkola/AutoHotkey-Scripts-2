; This program should be Run As Administrator or Run RunAs otherwise 
; Win32_Process.CommandLine info won't be complete.
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

If Not A_IsAdmin
{
    MsgBox, 48,, % "Restart Notepad++ as Administrator", 10
    ExitApp
}

OnMessage(0x5550,"get_process_list")
OnMessage(0x5559,"shut_down")             ; 
Gui, +AlwaysOnTop +ToolWindow   ; -SysMenu
Gui, Add, Text,, Message Receiver Window
Gui, Show, x10 y10, Get Process List
Gui, Hide
SetTimer, CHECK_RESTART, 1000
Return

get_process_list(wParam, lParam, msg)
{ 
    OutputDebug Message %msg% arrived:`nwParam: %wParam%`nlParam: %lParam%
    Clipboard := ""
    results := []
    process_list := ComObjGet( "winmgmts:" ).ExecQuery("Select * from Win32_Process") 
    For item in process_list
    {
        parameters := StrReplace(item.Commandline, item.ExecutablePath)
        parameters := StrReplace(parameters, """", "")
        parameters := trim(parameters)
        results.push([item.Name
                    , parameters
                    , item.ExecutablePath
                    , item.ProcessId])
    }      
    
    return_string := ""
    for i, j in results
        return_string .= results[i][1] Chr(7) results[i][2] Chr(7) results[i][3] Chr(7) results[i][4] "`n"
    
    ClipBoard := SubStr(return_string, 1, StrLen(return_string) - 1)   ; delete last (empty) newline
    Return
}

shut_down(wParam, lParam, msg)
{
    ExitApp
}

CHECK_RESTART:
    DetectHiddenWindows On
    ; If Not A_IsAdmin Or Not WinExist("Get Process List ahk_class AutoHotkeyGUI")
    ; {
        ; Run *RunAs "%A_ScriptFullPath%"
        ; SetTimer, CHECK_RESTART, 1000
    ; }
    DetectHiddenWindows Off
    Return