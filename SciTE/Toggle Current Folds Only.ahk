;--------------------------------------------------------------------------------------------
; For Scintilla based editors (ie Notepad++, SCite4AutoHotkey...)
; This will toggle all folds under the current cursor position ONLY (!Numpad1 hotkey)
; or toggle all current fold level under the current cursor position ONLY (!Numpad2 hotkey)
; (as opposed to expanding/contracting folds for the whole document)
;
; Note:
;   If no fold level is found at the current cursor position it will search FORWARD for
;   the first line with a fold level.
;--------------------------------------------------------------------------------------------
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
StringCaseSense, Off
single_fold := (A_Args[1] = "!Numpad2")
;  scintilla flags
SC_FOLDLEVELBASE = 0x400
SC_FOLDLEVELNUMBERMASK = 0x0FFF
SC_FOLDACTION_TOGGLE = 2
; scintilla message numbers
SCI_GETCURRENTPOS = 2008
SCI_LINEFROMPOSITION = 2166
SCI_GETFOLDPARENT = 2225
SCI_FOLDLINE = 2237
SCI_FOLDCHILDREN = 2238
SCI_GETLINECOUNT = 2154
SCI_GETFOLDLEVEL = 2223
SCI_GOTOLINE = 2024
;--------------------------------------
ControlGetFocus, scintilla_classnn, A
ControlGet, scintilla_hwnd, Hwnd, , %scintilla_classnn%, A
; Get current cursor line number as starting point to search for a fold
SendMessage, SCI_GETCURRENTPOS, 0, 0,, ahk_id %scintilla_hwnd%
SendMessage, SCI_LINEFROMPOSITION, ErrorLevel, 0,, ahk_id %scintilla_hwnd%
cur_line := ErrorLevel
; -----------------------------------------------------------------------
; Toggle fold at current cursor position only (!Numpad2 hotkey)
; as opposed to View/Collapse Level (1-8) for the whole document
; -----------------------------------------------------------------------
If single_fold
{
    SendMessage, SCI_FOLDLINE, cur_line, SC_FOLDACTION_TOGGLE,, ahk_id %scintilla_hwnd%
    Goto, TOGGLE_EXIT
}
; -----------------------------------------------------------------------
; Toggle all folds for the root parent (base) fold level found at/or near
; the current cursor position (!Numpad1 hotkey)
; as opposed to View/Collapse Level (1-8) for the whole document
; -----------------------------------------------------------------------
; find a line that has fold level. 
SendMessage, SCI_GETLINECOUNT, 0, 0,, ahk_id %scintilla_hwnd%
doc_line_count := ErrorLevel
Loop
{
    ; If not found at current cursor position then scroll down the document until one is found.
    SendMessage, SCI_GETFOLDPARENT, cur_line, 0,, ahk_id %scintilla_hwnd%
    fold_parent_line := ErrorLevel
    If (cur_line = doc_line_count + 1)
    {
        MsgBox, 48, % "Exiting", % "No folds found at cursor position or beyond."
        ExitApp
    }
    Else If (fold_parent_line > doc_line_count)
        ; current line is not within a fold level (fold_parent_line is some huge number)
        cur_line++
    Else If (fold_parent_line <= doc_line_count)
        ; fold level was found
        Break
}
; Scroll backwards until the line number containing the lowest fold level is found.
While (fold_parent_line > -1)
{
    SendMessage, SCI_GETFOLDLEVEL, fold_parent_line, 0,, ahk_id %scintilla_hwnd%
    line_fold_level := hex(hex(ErrorLevel) & SC_FOLDLEVELNUMBERMASK)
    If (line_fold_level = SC_FOLDLEVELBASE)
        Break  ; lowest fold level found
    Else
        fold_parent_line--
}
; Toggle all folds for the current fold only
SendMessage, SCI_FOLDCHILDREN, fold_parent_line, SC_FOLDACTION_TOGGLE,, ahk_id %scintilla_hwnd%
SendMessage, SCI_GOTOLINE, fold_parent_line, 0,, ahk_id %scintilla_hwnd%
TOGGLE_EXIT:
ExitApp
