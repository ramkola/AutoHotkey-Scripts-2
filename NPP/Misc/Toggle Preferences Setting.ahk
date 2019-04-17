;------------------------------------------------------------------------------------
; Toggles any Settings/Preferences on/off or gets the current state without altering it.
;   
; A_Args[1]: (requested_state - not case sensitive) 
;   "On", "1", "True", "Check", "Checked" all evaluate to True and will turn the option ON.
;   "Off", "0", "False". "Uncheck", "Unchecked" all evaluate to False and will turn the option OFF.
;   "Toggle" - switches the option On / Off
;   "ViewState" - displays the current state of the control without changing its status. 
;
; A_Args[2]: (control_id) 
;   This is the ClassNN or Label Text of the option you want to change. Use Window Spy to find ClassNN.
;   It must be spelled exactly as it appears in Window Spy and it is case sensitive.
;   (ie: "Button9", "Button26", "Button54"...) same as ("Show", "Arrow", "Auto-indent"...)
; Note: 
;   Some control labels have leading spaces that have to be included when using the label text method.
;
; Examples:
;   1) Run, Toggle Preferences Setting.ahk "toggle" "Button9"         - show / hide Document List Panel 
;   2) Run, Toggle Preferences Setting.ahk "0" "Auto-indent"          - turns off auto indent (Settings/Preferences/MISC/Auto-indent)
;   3) Run, Toggle Preferences Setting.ahk "Off" "Auto-indent"        -      ""
;   4) Run, Toggle Preferences Setting.ahk "Uncheck" "Auto-indent"    -      ""
;   5) Run, Toggle Preferences Setting.ahk "Unchecked" "Auto-indent"  -      ""
;   6) Run, Toggle Preferences Setting.ahk "False" "Auto-indent"      -      ""
;   7) Run, Toggle Preferences Setting.ahk %False% "Auto-indent"      -      ""
;
;   2) RunWait, Toggle Preferences Setting.ahk "getstate" "Button141" "Autocomplete"
;      If (Clipboard == "ON")
;           Run, Toggle Preferences Setting.ahk "off" "Button141" "Autocomplete"
;
; Notes: The current state of the control is saved to the clipboard. Make sure to use
;        RunWait instead of Run to get the correct status on the clipboard. 
;        See example 2.
;------------------------------------------------------------------------------------#SingleInstance Force
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#NoTrayIcon
saved_titlematchmode := A_TitleMatchMode
saved_detect_hidden_windows := A_DetectHiddenWindows
SetTitleMatchMode 1
DetectHiddenWindows, On
active_hwnd := WinExist("A")    ; active window loses focus when Control Check/Uncheck command is executed
preferences_wintitle = Preferences ahk_class #32770 ahk_exe notepad++.exe
preferences_hwnd := WinExist(preferences_wintitle)
If Not preferences_hwnd
{
    MsgBox, 48,, % "Couldn't set Settings/Preferences/MISC./Auto-indent setting."
    Goto TOGGLE_EXIT
}

; Param 1 - set requested_state
If RegExMatch(A_Args[1], "i)\b(Toggle|ViewState)\b")
    requested_state := A_Args[1]
Else If RegExMatch(A_Args[1], "i)\b(0|False|Off|Uncheck(ed)*)\b")
    requested_state := False
Else If RegExMatch(A_Args[1], "i)\b(1|True|On|Check(ed)*)\b")
    requested_state := True
Else
{
    MsgBox, 48,, % "Bad Param #1: " A_Args[1]
    Goto TOGGLE_EXIT
}
;
; Param 2 - check if control exists (Classnn or Text ie Button54 or "Auto-indent") 
control_id := A_Args[2]
ControlGet, control_hwnd, Hwnd,, %control_id%, ahk_id %preferences_hwnd%
If Not control_hwnd
{
    MsgBox, 48,, % "Bad Param #2: " A_Args[2]
    Goto TOGGLE_EXIT    
}
;
; Param 3 - (optional) Show control's status Tooltip
show_status_tooltip = (A_Args[3] == "") 
; Param 4 - (optional) save On / Off status to clipboard
save_to_clipboard := (A_Args[4] == "") 
;------------------------------------------

; Get current state
ControlGet, control_state, Checked,,,ahk_id %control_hwnd%
; Set desired state
If (requested_state = "ViewState")
    Goto TOGGLE_EXIT    
Else If (requested_state = "Toggle")
    control_toggle := control_state ? "Uncheck" : "Check"
Else
    ; user requested a specific state (1 - ON or 0 - OFF)
    control_toggle := (requested_state = 0) ? "Uncheck" : "Check"
Control, %control_toggle%,,, ahk_id %control_hwnd%
; get state after change.
ControlGet, control_state, Checked,,, ahk_id %control_hwnd%

TOGGLE_EXIT:
If RegExMatch(control_state, "(0|1)")
{
    ControlGetText, control_text,,ahk_id %control_hwnd%
    control_text:= (control_text == "") ? control_id : control_text
    status_on_off := control_state ? "ON" : "OFF"
    ttip("`r`n`r`n    " control_text " is " status_on_off "    `r`n`r`n ", 2000, 500, 500) 
}
SetTitleMatchMode %A_TitleMatchMode%
DetectHiddenWindows, %saved_detect_hidden_windows%
WinActivate, ahk_id %active_hwnd%
ExitApp
