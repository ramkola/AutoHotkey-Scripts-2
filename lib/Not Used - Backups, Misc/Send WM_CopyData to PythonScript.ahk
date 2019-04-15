#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include C:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\PythonScript\scripts\AHK Modules\ahk_constants.py
#NoEnv
#SingleInstance Force
SetTitleMatchMode 2
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Space_satellite-13.jpg

; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

; python receiver 
receiver_module_name := StrReplace(RECEIVER_MODULE_NAME,"'")
receiver_class_name := StrReplace(RECEIVER_CLASS_NAME,"'")
receiver_wintitle = %receiver_module_name% ahk_class %receiver_class_name% ahk_exe notepad++.exe

WinGet, python_script_receiver_hwnd, ID, %receiver_wintitle%
If python_script_receiver_hwnd
    python_script_receiver_hwnd := "ahk_id " python_script_receiver_hwnd
Else
{
    MsgBox, 48,, % "PythonScript Receiver not running..."
    ExitApp
}
OutputDebug, % "python_script_receiver_hwnd: " python_script_receiver_hwnd

message_text := "notepad_show_tab_context_menu"
message_text := "notepad_get_current_filename"
message_text := "notepad_get_plugin_config_dir"
message_text := "notepad_activate_and_editor_goto_line" Chr(7) "11" Chr(7) "C:\Users\Mark\Desktop\Misc\PythonScript\zzPythonScript - Scintilla Methods.txt"
message_text := "notepad_activate_file" Chr(7) "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\Examples\AHK ComObj - Client.ahk"
message_text := "notepad_getfiles"

Loop 1 {    
    result := Send_WM_COPYDATA(message_text, python_script_receiver_hwnd)  
    OutputDebug, % A_Index ") result: " result
    ; if result = FAILC:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\PythonScript\scripts\AHK Modules

        ; MsgBox SendMessage failed. Does the following WinTitle exist?:`n%python_script_receiver_hwnd%
    ; else if result = 0
        ; MsgBox Message sent but the target window responded with 0, which may mean it ignored it.
}
Return

Send_WM_COPYDATA(ByRef p_message_text, ByRef p_hwnd)
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
    SendMessage, 0x4a, 0, &copy_data_struct,, %p_hwnd%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
    result := ErrorLevel
    DetectHiddenWindows %save_detect_hidden_windows%  ; Restore original setting for the caller.
    SetTitleMatchMode %save_title_match_mode%         ; Same.
    Return %result%  ; Return SendMessage's reply back to our caller.
}

