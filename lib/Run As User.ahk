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

OnMessage(0x4a, "Receive_WM_COPYDATA")          ; 0x4a is WM_COPYDATA
OnMessage(0x5559,"shut_down")           

; Bypass User Account Control (UAC) that restricted lower elevated 
; processes sending messages to higher elevated messages
ErrorLevel := "RESETBYME"
result_4a := DllCall("ChangeWindowMessageFilter", uint, 0x4a, uint, 1)   
error_level_4a := ErrorLevel
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
    
    ; Show it with ToolTip vs. MsgBox so we can return in a timely fashion:
    ; ToolTip %A_ScriptName%`nReceived the following string:`n%CopyOfData%
    
    Try
    {
        If (wParam = 1)
            Run, %CopyOfData%
        Else If (wParam = 2)
            Process, Close, %CopyOfData%
        Else If (wParam = 3)
            CopyOfData := get_process_list_user()
        Else
            Throw % A_ScriptName "(" A_ThisFunc ")`n`nUnexpected wParam: " wParam   
           ; ToolTip % A_ScriptName "`nUnexpected wParam: " wParam "`nReceived the following string:`n" CopyOfData
    } 
    catch e
    {
        MsgBox, 16,, % "Exception Message`r`n`r`n" e
    }
    SetTimer, TOOLTIPOFF, 5000
    return true  ; Returning 1 (true) is the traditional way to acknowledge this message.
}

shut_down(wParam, lParam, msg)
{
    ; Message #0x5559
    ExitApp
}

get_process_list_user()
{ 
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

