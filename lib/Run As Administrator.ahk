/* 
    This program executes commands as Administrator (Integrity Level = High)

    It is always running in background with a hidden window (Admin Message Receiver Window)
    That other programs can use to send/postmessages to in order to execute on their
    behalf as an Administrator. It also bypasses the UAC prompt.
    
    It is able to do this because it is started by MyHotkeys.ahk which is started 
    with Integrity Level - High
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\processes.ahk
#NoTrayIcon

OnMessage(0x5550,"get_process_list")
OnMessage(0x5551,"kill_process")
OnMessage(0x5559,"shut_down")           

; Bypass User Account Control (UAC) that restricted lower elevated 
; processes sending messages to higher elevated messages
ErrorLevel := "RESETBYME"
result_5550 := DllCall("ChangeWindowMessageFilter", uint, 0x5550, uint, 1)   
error_level_5550 := ErrorLevel
ErrorLevel := "RESETBYME"
result_5551 := DllCall("ChangeWindowMessageFilter", uint, 0x5551, uint, 1)   
error_level_5551 := ErrorLevel
ErrorLevel := "RESETBYME"
result_5559 := DllCall("ChangeWindowMessageFilter", uint, 0x5559, uint, 1)
error_level_5559 := ErrorLevel

gui_title := StrReplace(A_ScriptName,".ahk", "")
msg_receiver_wintitle := gui_title " ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe"

Gui, +Owner -SysMenu
Gui, Add, Text,, Message Receiver Window
Gui, Show, x10 y10, %gui_title%
Gui, Hide       ; programs wanting to PostMessage to this window will have to DetectHiddenWindows On
SetTimer, CHECK_RESTART, 1000

Return

; =================================================================================
kill_process(wParam, lParam, msg)
{
    ; Message #5551
    proc_id := wParam
    Process, Close, %proc_id%
    If (ErrorLevel = proc_id)
        refresh_tray()  ; in case killing the process left a "dead" icon in the tray
    Return ErrorLevel
}

get_process_list_admin(wParam, lParam, msg)
{ 
    ; Message #5550
    ; This procedure needs Administrator privilege otherwise
    ; Win32_Process.CommandLine info won't be complete.
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
    Return 1
}

shut_down(wParam, lParam, msg)
{
    ; Message #5559
    ExitApp
}

CHECK_RESTART:
    ; in case the gui was killed somehow while the script process is left running.
    DetectHiddenWindows On
    If Not A_IsAdmin Or Not WinExist(msg_receiver_wintitle)
        Run *RunAs "%A_ScriptFullPath%"
    DetectHiddenWindows Off
    Return