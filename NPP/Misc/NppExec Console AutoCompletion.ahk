#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\npp.ahk
#Include lib\NppExec Console Word Lists.txt

word_list := npp_envars "`r`n" scintilla_keywords
cb_options = 
(Join`s LTrim 
    vcb_keyword gcb_update hwndcb_hwnd
    r5 w200
    Backgroundfeffcd Sort +ReadOnly
    x3 y3
)
Gui, Font, s9, Consolas
Gui, Add, Combobox, %cb_options%, %word_list%
; Gui Window
Gui, +AlwaysOnTop -SysMenu 
Gui, Show,, % SubStr(A_ScriptName, 1, -4)
Return

Enter::
    GuiControlGet, cb_keyword
    Goto GuiClose
    Return
;----------------------------------------
; Gui Event Handlers (formerly g-labels)
;----------------------------------------
cb_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    OutputDebug, % "gui_event: " gui_event " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    SendMessage, 0x014F, 1, , , ahk_id %ctrl_hwnd% ; CB_SHOWDROPDOWN = 0x014F
    Return
}

;----------
; G-Labels
;----------
Escape::
GuiEscape:
GuiClose:
    Exitapp

GuiSize:
    g_center_to_this_hwnd := WinExist("A")    ; Global variable used in Center Msgbox To Active Window.ahk
    Return