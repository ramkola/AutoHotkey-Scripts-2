;------------------------------------------------------------------------------------
; Toggles any Settings/Preferences on/off or gets the current state without altering it.
; A return code of "ON" or "OFF" is saved on the clipboard.
;  
; A_Args[1]: (p_action) 
;  First parameter passed in the script's Run command. 
;  The options are: on, off, toggle, getstate 
;
; A_Args[2]: (p_option_classnn) 
;   Second parameter passed in the script's Run command. 
;   This is the ClassNN of the option you want to change. Use Window Spy to find ClassNN.
;   It must be spelled exactly as it appears in Window Spy.
;   (ie: "Button9", "Button26", "Button141"...)
;
; A_Args[3]: (p_option_label) 
;   Third parameter passed in the script's Run command. 
;   This is used in the status message displayed at the end.
;   (ie: "Autocomplete", "Doc Switcher")
;
; Examples:
;   1) Run, Toggle Preferences Setting.ahk "toggle" "Button9" "Doc Switcher"
;
;   2) RunWait, Toggle Preferences Setting.ahk "getstate" "Button141" "Autocomplete"
;      If (Clipboard == "ON")
;           Run, Toggle Preferences Setting.ahk "off" "Button141" "Autocomplete"
;
; Notes: The current state of the control is saved to the clipboard. Make sure to use
;        RunWait instead of Run to get the correct status on the clipboard. 
;        See example 2.
;------------------------------------------------------------------------------------
#NoEnv
#NoTrayIcon
#SingleInstance Force
SetTitleMatchMode 3
SetControlDelay 5

; uncomment this to test without needing a Run command to pass the parameter
; A_Args[1] := "toggle"   
; A_Args[2] := "Button9"
; A_Args[3] := "Doc Switcher"

; uncomment this to test without needing a Run command to pass the parameter
; A_Args[1] := "getstate"   
; A_Args[2] := "Button141"
; A_Args[3] := "Autocomplete"

if (A_Args.Length() != 3)
{
    Msgbox, 48,, Bad parameters passed.
    ExitApp
}

p_action := A_Args[1]
StringLower, p_action, p_action
p_option_classnn := A_Args[2]
p_option_label := A_Args[3]    

preferences_window := "Preferences ahk_class #32770"
closebtn_classNN := "Button1"

if p_action not in on,off,toggle,getstate 
{
    Msgbox, 48, Missing Parameter: %p_action% , Valid options are either `n`n "On" or "Off" `n`nin your RUN command.
    ExitApp
}
                       
WinMenuSelectItem, A,, Settings, Preferences
Sleep 100

; Toggle option checkbox
if (p_action == "toggle")
{
    ControlGet, ischecked, Checked,,%p_option_classnn%, %preferences_window%
    p_action := if ischecked ? "off" : "on"     
}

; Set the option
If (p_action == "on")
    Control, Check,,%p_option_classnn%, %preferences_window%
Else If (p_action == "off")
    Control, Uncheck,,%p_option_classnn%, %preferences_window%

ControlGet, ischecked, Checked,,%p_option_classnn%, %preferences_window%
state := if ischecked ? "ON" : "OFF"     

; Close the Settings dialog    
countx := 0
While WinExist(preferences_window) and (countx < 10)
{
    ControlClick, %closebtn_classNN%, %preferences_window%,,LEFT,1,NA  
}    
WinActivate, ahk_class Notepad++ 
MouseGetPos, x, y
ToolTip, `n %p_option_label% is %state%  `n`t, x + 20, y + 20
Sleep 1000
Clipboard := state
ExitApp
