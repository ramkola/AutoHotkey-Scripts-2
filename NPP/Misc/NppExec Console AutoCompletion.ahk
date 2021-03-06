#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\npp.ahk
#Include lib\NppExec Console Word Lists.txt
SetTitleMatchMode 3

word_list := npp_envars "`r`n" npp_envars_plain "`r`n" nppexec_commands "`r`n" 
          .  scintilla_keywords "`r`n" scintilla_keywords_no_prefix

npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
nppexec_execute_wintitle = Execute... ahk_class #32770 ahk_exe notepad++.exe
active_hwnd := WinExist("A")

; set control that will receive the autocompleted text
ControlGetFocus, active_classnn, A 

If WinActive(nppexec_execute_wintitle)  ; user entering commands in NppExec Execute Dialog
    ControlGet, control_hwnd, Hwnd,, Edit1, %nppexec_execute_wintitle% 
Else If (active_classnn = "RichEdit20W1")   ; user enterting commands in NppExec Console
    ControlGet, control_hwnd, Hwnd,, RichEdit20W1, %npp_wintitle% 
Else If InStr(active_classnn,"Scintilla")   ; user entering commands in Notepad++ (any Scintilla) editor
    ControlGet, control_hwnd, Hwnd,, %active_classnn%, %npp_wintitle% 
Else
{
    WinGetActiveTitle, wt
    MsgBox, 48,, % "Unexpected window / control has focus...exiting`r`n`r`nActive Wintitle:`r`n" wt "`r`n`r`nActive Control: " active_classnn 
    Return
}
; Gui
cb_options = 
(Join`s LTrim 
    vcb_keyword gcb_update hwndcb_hwnd
    r5 w300
    Sort +ReadOnly
)
Gui, Font, s12, Consolas
Gui, Add, Combobox, %cb_options%, %word_list%
; Gui Window
Gui, +AlwaysOnTop -SysMenu 
Gui, Show,, % SubStr(A_ScriptName, 1, -4)
Return

Enter::
    GuiControlGet, cb_keyword
    If Not InStr(active_classnn, "Scintilla")
        Control, EditPaste, %cb_keyword%,, ahk_id %control_hwnd%
    Else
    {
        saved_clipboard := ClipboardAll
        Clipboard := ""
        Clipboard := cb_keyword
        ClipWait,1
        ControlFocus,,ahk_id %control_hwnd%
        SendInput ^v
        Clipboard := saved_clipboard
    }
    Goto GuiClose
    Return
;----------------------------------------
; Gui Event Handlers (formerly g-labels)
;----------------------------------------
cb_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Static first_time := True
    ; OutputDebug, % "gui_event: " gui_event " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    If first_time
    {
        ; this is to prevent losing the first letter typed when
        ; sendmessage drops the the combobox.
        GuiControlGet, letters_typed,, cb_keyword
        SendMessage, 0x014F, 1, , , ahk_id %ctrl_hwnd% ; CB_SHOWDROPDOWN = 0x014F
        GuiControl, Text, cb_keyword, %letters_typed%
        SendInput {End}
        first_time := False
    }
    Return
}
;----------
; G-Labels
;----------
Escape::
GuiEscape:
GuiClose:
    If (active_classnn == "" )
        WinActivate, ahk_id %active_hwnd%
    Else
        ControlFocus, %active_classnn%, ahk_id %active_hwnd%
    Exitapp

GuiSize:
    Return