#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\macro_recorder_icon.png
SetTitleMatchMode 1
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

OutputDebug, DBGVIEWCLEAR

Global mod_states := {"control": 0, "alt": 0, "shift": 0, "lwin": 0
                     ,"control_down": 0, "alt_down": 0, "shift_down": 0, "lwin_down": 0}

Global write_string := ""
recorder_off := True

aoe_flag := False
If aoe_flag
{
    aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
    WinActivate, %aoe_wintitle%
}

If aoe_flag
    target_hwnd := WinExist(aoe_wintitle)
Else
    WinGet, target_hwnd, ID, A

WinGetTitle, aw, ahk_id %target_hwnd%
OutputDebug, % "target_hwnd: " target_hwnd
OutputDebug, % "aw: " aw

Return

process_modifier_key(p_mod_key)
{
    ; 0 = modifier key NOT pressed (up position)
    ; 1 = modifier key is pressed (down position)
    StringUpper, cap_mod_key, p_mod_key, T
    already_down := p_mod_key "_down"
    IF (mod_states[p_mod_key] = 1)
    {
        If (mod_states[already_down] = 0)
        {
            write_string .= "SendInput {" cap_mod_key " Down}`r`n"
            mod_states[already_down] := 1
        }
    }
    ; Control Key Unpressed
    IF (mod_states[p_mod_key] = 0)
    {
        If (mod_states[already_down] = 1)
        {
            write_string .= "SendInput {" cap_mod_key " Up}`r`n"
            mod_states[already_down] := 0
        }
    }
}

; Capture mouse clicks with modifier key states
~*MButton::
~*RButton::
~*LButton::
    If recorder_off
        Return
    ; capture modifier key states at the time hotkey (mouse button) was invoked
    mod_states["control"] := GetKeyState("Control")
    mod_states["alt"] := GetKeyState("Alt")
    mod_states["shift"] := GetKeyState("Shift")
    mod_states["lwin"] := GetKeyState("LWin")   
    process_modifier_key("control")
    process_modifier_key("alt")
    process_modifier_key("shift")
    process_modifier_key("lwin")
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
    write_string .= Format("Click, {:-6}, {:4}, {:4}`r`n", mouse_button, x, y)
    Return

CapsLock & F8::    ; end recording
    SetCapslockState, AlwaysOff
    If aoe_flag
        SendInput {F3}  ; pause game
    ;
    recorder_off := True
    If mod_states["control_down"]
        write_string .= "SendInput {Control Up}`r`n"
    If mod_states["alt_down"]
        write_string .= "SendInput {Alt Up}`r`n"
    If mod_states["shift_down"]
        write_string .= "SendInput {Shift Up}`r`n"
    If mod_states["lwin_down"]
        write_string .= "SendInput {LWin Up}`r`n"
    mod_states["control_down"] := 0
    mod_states["alt_down"] := 0
    mod_states["shift_down"] := 0
    mod_states["lwin_down"] := 0
    ClipBoard := write_string
    ToolTip, Hit Escape to exit`n`nCopied to Clipboard:`n %write_string%, 100, 100
    Input, out_var,,{Escape}
    ToolTip
    write_string := ""
    ExitApp

CapsLock & F9:: ; toggle recording
    ; avoid getting capslock in the down position if it gets 
    ; stuck and you press Shift it will be interpreted as CapsLock
    ; launching hotkeys that use the CapsLock as a modifier
    ; (ie Shift+A would launch the CapsLock+A which replaces selected char with ascii code)
    KeyWait, CapsLock, T2
    If ErrorLevel
        OutputDebug, % "Error A_ThisHotkey: " A_ThisHotkey " - A_ScriptName: " A_ScriptName 
    SendInput {CapsLock Up}
    SetCapslockState, AlwaysOff
    ; Not sure why any of this to the next comment is necessary maybe it 
    ; allows you to click normally in other windows while recorder is still
    ; on without recording the clicks. If so should be made an optional.
    WinGet, current_hwnd, ID, A
    WinGetActiveTitle, current_wintitle
    WinGetTitle, target_wintitle, ahk_id %target_hwnd%
    If (current_hwnd <> target_hwnd)
    {
        MsgBox, % A_ScriptName " not recording:`r`nCurrent: " current_hwnd  " - " current_wintitle "`r`n`r`nTarget: " target_hwnd " - " target_wintitle
        Return
    }
    ; END OF - don't know if why any of this to the above comment is necessary
    ;
    recorder_off := !recorder_off
    msg := "`r`nRecorder is "
    msg .= recorder_off ? "OFF" : "ON"
    msg .= "`r`n "
    MouseGetPos, x, y
    ToolTip, %msg%, x+10, y+10
    Sleep 1000
    ToolTip
    Return

^+k:: list_hotkeys()