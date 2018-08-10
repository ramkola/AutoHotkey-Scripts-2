#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include C:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\PythonScript\scripts\AHK Modules\ahk_constants.py
#NoEnv
#SingleInstance Force
SetTitleMatchMode 2
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Space_satellite-13.jpg

; python receiver new instance of Notepad++
python_script_receiver_hwnd = 
com_file := StrReplace(PYTHON_AHK_MESSAGE_FILE,"'")
receiver := StrReplace(RECEIVER_MODULE_NAME,"'")
countx := 1
While (python_script_receiver_hwnd == "") And countx < 3
{
    If WinExist(receiver " ahk_class PythonAhkReceiver ahk_exe notepad++.exe")
    {
        If FileExist(com_file)
            FileRead, python_script_receiver_hwnd, %com_file%
        Else
        {
            ; PythonScript receiver running but no com_file exists ( or vice versa) means 
            ; something got screwed up. Try to clean up the environment and try again.
            WinGet, process_id, PID, %python_script_receiver_hwnd%
            process_id := "ahk_pid " process_id
            WinClose, %process_id%,,1
            if (countx > 1) 
                ; if countx = 1 leave countx at 1 so that it will try to launch_pythonscript_message_receiver one time
                countx++
        }
    }
    Else 
    {
        If (countx = 1)
        {
            countx++
            if not launch_pythonscript_message_receiver()
            {
                MsgBox, 16,, % A_ScriptName ": Could not start Python Script module: " receiver
                ExitApp
            }
        }
    }
}

python_script_receiver_hwnd := "ahk_id " python_script_receiver_hwnd
OutputDebug, % "python_script_receiver_hwnd: " python_script_receiver_hwnd


Loop 1 {
    message_text := Format("Message#{:03}", A_Index) chr(7) A_TickCount
    result := Send_WM_COPYDATA(message_text, python_script_receiver_hwnd)  
    OutputDebug, % A_Index ") result: " result
    ; if result = FAIL
        ; MsgBox SendMessage failed. Does the following WinTitle exist?:`n%python_script_receiver_hwnd%
    ; else if result = 0
        ; MsgBox Message sent but the target window responded with 0, which may mean it ignored it.
}
Return

Send_WM_COPYDATA(ByRef p_message_text, ByRef p_hwnd)
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    SizeInBytes := (StrLen(p_message_text) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
    NumPut(&p_message_text, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
    save_detect_hidden_windows := A_DetectHiddenWindows
    save_title_match_mode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime = 4000  ; Optional. Milliseconds to wait for response from receiver. Default is 5000
    ; Must use SendMessage not PostMessage.
    SendMessage, 0x4a, 0, &CopyDataStruct,, %p_hwnd%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
    DetectHiddenWindows %save_detect_hidden_windows%  ; Restore original setting for the caller.
    SetTitleMatchMode %save_title_match_mode%         ; Same.
    Return ErrorLevel  ; Return SendMessage's reply back to our caller.
}


launch_pythonscript_message_receiver()
{
    save_working_dir := A_WorkingDir
    save_title_match_mode := A_TitleMatchMode
    SetWorkingDir C:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\PythonScript\scripts\AHK Modules
    SetTitleMatchMode 2
    
    python_script_module = Receive WM_CopyData from AutoHotkey
    receiver_wintitle = %python_script_module% ahk_class Notepad++ ahk_exe notepad++.exe
    run_filename = "%A_WorkingDir%\%python_script_module%.py"
    
    result := false
    countx := 0
    Run, C:\Program Files (x86)\Notepad++\notepad++.exe -multiInst -nosession %run_filename%
    While Not WinActive(receiver_wintitle) and (countx < 1000)
    {
        WinActivate, %receiver_wintitle%
        Sleep 1
        countx++
    }
    
    if WinActive(receiver_wintitle)
    {
        WinMenuSelectItem,%receiver_wintitle%,,Plugins,Python Script,Scripts,AHK Modules,%python_script_module%
        Sleep 1000
    }
        
    SetWorkingDir %save_working_dir%
    SetTitleMatchMode %save_title_match_mode%
    Return %result%
}
