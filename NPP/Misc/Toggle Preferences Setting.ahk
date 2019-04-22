;------------------------------------------------------------------------------------
; Toggles any Settings/Preferences on/off or gets the current state without altering it.
;   
; A_Args[1]: (Required. requested_state) 
;   On, 1, True, Check, Checked       - all evaluate to True and will turn the option ON.
;   Off, 0, False. Uncheck, Unchecked - all evaluate to False and will turn the option OFF.
;   Toggle                            - switches the option to opposite its current state (On/Off)
;   GetState                          - retrieves the current state of the control without changing it. 
;                                       make sure A_Args[3] (show_status_tooltip) is True if you want to view the state. 
;                                       make sure A_Args[4] (save_to_clipboard) is True if you want a return code to check
;
; A_Args[2]: (Required. control_id) 
;   This is the ClassNN or Label Text of the option you want to change. Use Window Spy to find ClassNN.
;   It must be spelled exactly as it appears in Window Spy and it is case sensitive.
;   (ie: Button9, Button26, Button54...) same as (Show, Arrow, Auto-indent...)
;   Note: 
;       Some control labels have leading spaces that have to be included when using the label text method.
;       Any controls with spaces in their label need to be wrapped in quotemarks. 
;       (ie "ignore numbers" - which is Button145, one of the auto-completion options)
;       Use the classNN in such cases if you prefer....
;
; A_Args[3]: (Optional. Default = True. show_status_tooltip.) 
;   Shows the final state the control is in after any changes in a tooltip (On / Off)
;
; A_Args[4]: (Optional. Default = False. save_to_clipboard.) 
;   Saves the final state the control is in after any changes on the Clipboard (0 / 1)
;
; Examples:
;   1) Run, Toggle Preferences Setting.ahk toggle Button9         - show / hide Document List Panel 
;
;   2) Run, Toggle Preferences Setting.ahk 0 Auto-indent          - turns off auto indent (Settings/Preferences/MISC/Auto-indent), display tooltip, don't save result to clipboard
;   3) Run, Toggle Preferences Setting.ahk Off Auto-indent                    ""   
;   4) Run, Toggle Preferences Setting.ahk Uncheck Auto-indent                ""      
;   5) Run, Toggle Preferences Setting.ahk Unchecked Auto-indent              ""      
;   6) Run, Toggle Preferences Setting.ahk False Auto-indent True False       ""      
;                                                                           
;   7) Run, Toggle Preferences Setting.ahk 1 Button54 False True              ""   doesn't display tooltip, saves result on clipboard   
;
;   8) Run, Toggle Preferences Setting.ahk On Button141 1        - Turn on Autocomplete, show tooltip result, don't save result on clipboard
;
;   9) RunWait, Toggle Preferences Setting.ahk On Button141 0 1      - Turn on Autocomplete, don't show tooltip result, save result on clipboard
;      autocomplete_flag := (Clipboard = 1)         ; notice RunWait used to ensure script has stored
;                                                   ; return code on the clipboard
; Note: 
;    If any of the parameters have spaces they will needed to be wrapped in quotemarks:
;    (ie: Run, Toggle Preferences Setting.ahk On "Enable auto-completion on each input" 0 1
;         Turn On auto-completion, doesn't display tooltip, saves status to clipboard)
;------------------------------------------------------------------------------------
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
#NoTrayIcon
saved_titlematchmode := A_TitleMatchMode
saved_detect_hidden_windows := A_DetectHiddenWindows
SetTitleMatchMode 1
DetectHiddenWindows, On

; OutputDebug, DBGVIEWCLEAR
; Loop, 4
    ; OutputDebug, % Format("A_Args[{}] = {}", A_Index, A_Args[A_Index]) 

; active window loses focus when Control Check/Uncheck command is executed so save it to activate at end
active_hwnd := WinExist("A")    

; check access to Settings/Preferences window.
preferences_wintitle = Preferences ahk_class #32770 ahk_exe notepad++.exe
If Not WinExist(preferences_wintitle)
{
    OutputDebug, % "Did not exist: " preferences_wintitle " - Line#" A_LineNumber " - " A_LineFile " - " A_ScriptName
    WinMenuSelectItem, A,, Settings, Preferences  ; displaying the window must reinitalize it 
    Sleep 100
    ControlClick, Button1, %preferences_wintitle%,, Left, 1,,,NA   ; Close the window - can't use Winhide...
    Sleep 100
    If Not WinExist(preferences_wintitle)
    {
        MsgBox, 48, Unexpected Error, % "Couldn't access or initialize Settings/Preferences Window."
        Goto TOGGLE_EXIT
    }
}
preferences_hwnd := WinExist(preferences_wintitle)

; Param 1 - (Required) set requested_state 
If RegExMatch(A_Args[1], "i)\b(Toggle|GetState)\b")
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
; Param 2 - (Required) check if control exists (Classnn or Text ie Button54 or "Auto-indent") 
control_id := A_Args[2]
ControlGet, control_hwnd, Hwnd,, %control_id%, ahk_id %preferences_hwnd%
If Not control_hwnd
{
    MsgBox, 48,, % "Bad Param #2: " A_Args[2]
    Goto TOGGLE_EXIT    
}
;
; Param 3 - (Optional. Default = True) Show control's status Tooltip
show_status_tooltip := (A_Args[3] == "") ? True : A_Args[3]
If RegExMatch(show_status_tooltip, "i)\b(0|False|Off)\b")
    show_status_tooltip := False
Else If RegExMatch(show_status_tooltip, "i)\b(1|True|On)\b")
    show_status_tooltip := True
Else
{
    MsgBox, 48,, % "Bad Param #3: " A_Args[3]
    Goto TOGGLE_EXIT
}
;
; Param 4 - (Optional. Default = False) save On / Off status to clipboard 
save_to_clipboard := (A_Args[4] == "") ? False : A_Args[4]
If RegExMatch(save_to_clipboard, "i)\b(0|False|Off)\b")
    save_to_clipboard := False
Else If RegExMatch(save_to_clipboard, "i)\b(1|True|On)\b")
    save_to_clipboard := True
Else
{
    MsgBox, 48,, % "Bad Param #4: " A_Args[4]
    Goto TOGGLE_EXIT
}
;---------------------------
; end of parameter settings
;---------------------------

; Get current state
ControlGet, control_state, Checked,,,ahk_id %control_hwnd%
; Set desired state
If (requested_state = "GetState")
    Goto TOGGLE_EXIT  ; no more processing required just return the state
Else If (requested_state = "Toggle")
    control_toggle := control_state ? "Uncheck" : "Check"
Else
    ; user requested a specific state: 0=Uncheck 1=Check 
    control_toggle := (requested_state = 0) ? "Uncheck" : "Check"
; make state change
Control, %control_toggle%,,, ahk_id %control_hwnd%
; get final state after change. 
ControlGet, control_state, Checked,,, ahk_id %control_hwnd%

TOGGLE_EXIT:
; optionally display status tooltip and save status to clipboard
; control_state will be empty if there was a parameter error above.
If RegExMatch(control_state, "(0|1)")
{
    control_classnn := get_classnn(preferences_hwnd, control_hwnd)
    ControlGetText, control_text,,ahk_id %control_hwnd%
    status_on_off := control_state ? "ON" : "OFF"
    display_text := control_text "  ( " control_classnn " )    `r`n`r`n     is " status_on_off "      " 

    If show_status_tooltip
        ttip("`r`n`r`n    " display_text "`r`n`r`n ", 1500, 500, 300)
    
    If save_to_clipboard
    {
        Clipboard := control_state  
        ClipWait, 2
    }
}
WinActivate, ahk_id %active_hwnd%
SetTitleMatchMode %A_TitleMatchMode%
DetectHiddenWindows, %saved_detect_hidden_windows%
ExitApp

