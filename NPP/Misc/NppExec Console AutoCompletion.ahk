#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\npp.ahk
#Include lib\NppExec Console Word Lists.txt
SetTitleMatchMode 3
npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
active_hwnd := WinExist("A")
ControlGetFocus, active_control, A 
word_list := npp_envars "`r`n" npp_envars_plain "`r`n" nppexec_commands "`r`n" 
          .  scintilla_keywords "`r`n" scintilla_keywords_no_prefix

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
    Control, EditPaste, %cb_keyword%, RichEdit20W1, %npp_wintitle%
    Goto GuiClose
    Return
;----------------------------------------
; Gui Event Handlers (formerly g-labels)
;----------------------------------------
cb_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Static first_time := True
    OutputDebug, % "gui_event: " gui_event " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    If first_time
    {
        ; this is to prevent losing the first letter typed when
        ; sendmessage drops the the combobox.
        GuiControlGet, letters_typed,, cb_keyword
        SendMessage, 0x014F, 1, , , ahk_id %ctrl_hwnd% ; CB_SHOWDROPDOWN = 0x014F
        GuiControl, Text, cb_keyword, %letters_typed%
        SendInput ^{Right}
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
    If (active_control == "" )
        WinActivate, ahk_id %active_hwnd%
    Else
        ControlFocus, %active_control%, ahk_id %active_hwnd%
    Exitapp

GuiSize:
    Return