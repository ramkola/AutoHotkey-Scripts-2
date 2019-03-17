#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
SetTitleMatchMode 1
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

OutputDebug, DBGVIEWCLEAR

recorder_off := True
write_string := ""

; aoe_flag := False
; If aoe_flag
; {
    ; aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
    ; #If WinActive(aoe_wintitle)
    ; WinActivate, %aoe_wintitle%
; }

mod_states := {"control": 0, "alt": 0, "shift": 0, "win": 0}

Return

~*MButton::
~*RButton::
~*LButton::
    If recorder_off
        Return
    ; capture modifier key states at the time hotkey was invoked
    BlockInput, On  
    mod_states["control"] := GetKeyState("Control")
    mod_states["alt"] := GetKeyState("Alt")
    mod_states["shift"] := GetKeyState("Shift")
    mod_states["win"] := GetKeyState("LWin")   
    BlockInput, Off







    IF mod_states["control"] and control_down
        write_string .= "SendInput {Control Down}`r`n"
    IF mod_states["alt"]
        write_string .= "SendInput {Alt Down}`r`n"
    IF mod_states["shift"]
        write_string .= "SendInput {Shift Down}`r`n"
    IF mod_states["win"] 
        write_string .= "SendInput {LWin Down}`r`n"
    ;
        
    If InStr(A_ThisHotkey, "LButton")
        mouse_button := "Left"
    Else If InStr(A_ThisHotkey, "RButton")
        mouse_button := "Right"
    Else If InStr(A_ThisHotkey, "MButton")
        mouse_button := "Middle"
    Else
        OutputDebug, % "Unexpected Hotkey: " A_ThisHotkey " - A_ThisFunc: " A_ThisFunc " - A_ScriptName: " A_ScriptName
    MouseGetPos x,y
    write_string .= Format("Click, {}, {:4}, {:4}`r`n", mouse_button, x, y)
    Return

F8::
    recorder_off := True
    ClipBoard := write_string
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    MsgBox, 48,, % write_string, 10
    Return

F9:: 
    recorder_off := !recorder_off
    msg := "`r`nRecorder is "
    msg .= recorder_off ? "OFF" : "ON"
    msg .= "`r`n "
    MouseGetPos, x, y
    ToolTip, %msg%, x+10, y+10
    Sleep 1000
    ToolTip
    Return


/* 
    If Not WinActive("ahk_class FullScreenClass ahk_exe i_view32.exe")
        SendInput {Enter}   ; Fullscreen


    If (A_ThisHotkey = "~RButton & Control")
        mouse_button := "Right"
    Else If (A_ThisHotkey = "~LButton")
        mouse_button := "Left"
*/