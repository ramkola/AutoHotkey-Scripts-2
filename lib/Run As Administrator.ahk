/* 
    This program executes commands as Administrator (Integrity Level = High)

    It is always running in background with a hidden window (Admin Message Receiver Window)
    That other programs can use to send/postmessages to in order to execute on their
    behalf as an Administrator. It also bypasses the UAC prompt.
    
    It is able to do this because it is started by MyHotkeys.ahk which is started 
    with Integrity Level - High
    
    See Call RunAs Message Receivers.ahk for examples.
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\processes.ahk
#NoTrayIcon

OnMessage(0x4a,   "Receive_WM_COPYDATA")          ; 0x4a is WM_COPYDATA
OnMessage(0x5000, "get_process_list_admin")     

; Bypass User Account Control (UAC) that restricted lower elevated 
; processes sending messages to higher elevated messages
result_4a := DllCall("ChangeWindowMessageFilter", uint, 0x4a, uint, 1)   
error_level_4a := ErrorLevel
result_5000 := DllCall("ChangeWindowMessageFilter", uint, 0x5000, uint, 1)   
error_level_5000 := ErrorLevel

gui_title := StrReplace(A_ScriptName,".ahk", "")
msg_receiver_wintitle := gui_title " ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe"

Gui, +Owner -SysMenu
Gui, Add, Text,, Message Receiver Window
Gui, Show, x10 y10, %gui_title%
Gui, Hide       ; programs wanting to PostMessage to this window will have to DetectHiddenWindows On
SetTimer, CHECK_RESTART, 1000

Return
; =================================================================================

TOOLTIPOFF:
    ToolTip
    Return

; =================================================================================

Receive_WM_COPYDATA(wParam, lParam)
{
    ; Message #0x4a
    OutputDebug, % A_ScriptName " - " A_ThisFunc " - wParam: " wParam " - lParam: " lParam
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
    CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.
    
    If (wParam = 1)
        Run, %CopyOfData%
    Else If (wParam = 2)
        kill_process(CopyOfData)
    Else If (wParam = 99)
        ExitApp
    Else
        Throw % A_ScriptName "(" A_ThisFunc ")`n`nUnexpected wParam: " wParam   
    SetTimer, TOOLTIPOFF, 5000
    Return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
}

Send_WM_COPYDATA(p_message_type, ByRef p_message_text, ByRef p_hwnd)
{
    VarSetCapacity(copy_data_struct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    size_in_bytes := (StrLen(p_message_text) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(size_in_bytes, copy_data_struct, A_PtrSize)  ; OS requires that this be done.
    NumPut(&p_message_text, copy_data_struct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
    save_detect_hidden_windows := A_DetectHiddenWindows
    save_title_match_mode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime = 3000  ; Optional. Milliseconds to wait for response from receiver. Default is 5000

    ; Must use SendMessage not PostMessage.
    SendMessage, 0x4a, %p_message_type%, &copy_data_struct,, %p_hwnd%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
    result := ErrorLevel

    DetectHiddenWindows %save_detect_hidden_windows%  ; Restore original setting for the caller.
    SetTitleMatchMode %save_title_match_mode%         ; Same.
    Return %result%  ; Return SendMessage's reply back to our caller.
}

get_process_list_admin()
{ 
    ; Message #5000 
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
    
    ClipBoard := SubStr(return_string, 1, StrLen(return_string) - 1)   ; delete last (empty) newline character
    Return True
}

kill_process(p_pid)
{
    Process, Close, %p_pid%
    If (ErrorLevel = p_pid)
        refresh_tray()  ; in case killing the process left a "dead" icon in the tray
    Return ErrorLevel
}

CHECK_RESTART:
    ; in case the gui was killed somehow while the script process is left running.
    DetectHiddenWindows On
    If Not A_IsAdmin Or Not WinExist(msg_receiver_wintitle)
        Run *RunAs "%A_ScriptFullPath%"
    DetectHiddenWindows Off
    Return