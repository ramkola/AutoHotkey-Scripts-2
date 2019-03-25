; This program should be Run As Administrator or Run RunAs otherwise 
; Win32_Process.CommandLine info won't be complete.
#SingleInstance Force
; #Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
; #Include lib\utils.ahk
; g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
#NoTrayIcon
OnMessage(0x5550,"get_process_list")
OnMessage(0x5559,"shut_down")           
; Bypass User Account Control (UAC) that restricted lower elevated 
; processes sending messages to higher elevated messages
result_5550 := DllCall("ChangeWindowMessageFilter", uint, 0x5550, uint, 1)   
error_level_5550 := ErrorLevel
ErrorLevel := "RESETBYME"
result_5559 := DllCall("ChangeWindowMessageFilter", uint, 0x5559, uint, 1)
error_level_5559 := ErrorLevel
; OutputDebug, % "result_5550: " result_5550
; OutputDebug, % "error_level_5550: " error_level_5550
; OutputDebug, % "result_5559: " result_55590
; OutputDebug, % "error_level_5559: " error_level_5559

Gui, +Owner -SysMenu
Gui, Add, Text,, Message Receiver Window
Gui, Show, x10 y10, Get Process List
Gui, Hide       ; programs wanting to PostMessage to this window will have to DetectHiddenWindows On
SetTimer, CHECK_RESTART, 1000
Return

; =================================================================================

get_process_list(wParam, lParam, msg)
{ 

; MsgBox, % "A_ThisFunc: " A_ThisFunc " - A_ScriptName: " A_ScriptName 

    ; OutputDebug Message %msg% arrived:`nwParam: %wParam%`nlParam: %lParam%
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
    ; MsgBox % "ClipBoard: " ClipBoard 
    Return 1
}

shut_down(wParam, lParam, msg)
{
    ExitApp
}

CHECK_RESTART:
    ; in case the gui was killed somehow while the script process is left running.
    DetectHiddenWindows On
    If Not A_IsAdmin Or Not WinExist("Get Process List ahk_class AutoHotkeyGUI")
    {
        OutputDebug, % "Restart - A_ScriptName: " A_ScriptName
        Run *RunAs "%A_ScriptFullPath%"
        ; SetTimer, CHECK_RESTART, 1000
    }
    DetectHiddenWindows Off
    Return