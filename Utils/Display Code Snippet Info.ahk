#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\Code Snippets.txt
#Include lib\Center MsgBox To Active Window.ahk
#NoTrayIcon

OutputDebug, DBGVIEWCLEAR

Global text_snippet_hwnd        ; handle - text_snippet (Edit) control
Global snippet_saved := True    ; boolean - tracks whether changes to code snippet have been saved or not
WM_COMMAND = 0x111
OnMessage(WM_COMMAND,"MessageHandler")

; Listview
lv_visible_lines := 5
lv_width := 150
text_width := (lv_width * 1.5) - 3 
btn_width := 50
Gui, Font, s12, Consolas
lv_options = 
(Join`s LTrim 
    hwndlv_snippet_hwnd vlv_snippet glv_snippet 
    r%lv_visible_lines% w%lv_width% 
    Backgroundfeffcd AltSubmit Sort +ReadOnly
    x3 y3
)
Gui, Add, ListView, %lv_options%, Key Word|Snippet
LV_ModifyCol(1, lv_width)    ; Key Words sized so that it is the only visible column
LV_ModifyCol(2, 0) 
For key_word, snippet in code_snippetz
    LV_ADD("", key_word, snippet)
; Edit box
Gui, Font, S9, %textFont%
Gui, Add, Edit, vtext_snippet gtext_snippet hwndtext_snippet_hwnd xp+%lv_width% yp w%text_width% hp -Wrap -WantTab -HScroll
; Buttons
ControlGetPos,,,, lv_height,, ahk_id %lv_snippet_hwnd% 
btn_y := lv_height + 5
Gui, Add, Button, hwndbtn_save_hwnd vbtn_save gbtn_save x3 y%btn_y% w%btn_width% -TabStop, &Save
Gui, Add, Button, hwndbtn_copy_hwnd vbtn_copy gbtn_copy wp xp+%btn_width% yp -TabStop, &Copy
;
; Focus on first key word in listview
GuiControl, Focus, lv_snippet
LV_Modify(1, "+Focus +Select")
;

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
sleep 10

; Gui Window
ControlGetPos,,lv_y, lv_width, lv_height,, ahk_id %lv_snippet_hwnd% 
ControlGetPos,,, edit_width,,, ahk_id %text_snippet_hwnd% 
ControlGetPos,,btn_y,, btn_height,, ahk_id %btn_save_hwnd% 
gui_width := lv_width + edit_width + 6              
gui_height := btn_y + btn_height - lv_y + 6
gui_x := A_ScreenWidth - gui_width - 5      ; top right corner of screen
Gui, +AlwaysOnTop 
Gui, Show, x%gui_x% y0 w%gui_width% h%gui_height%, Code Snippets
Return

;------------------------------------------

MessageHandler(wParam_notifycode_ctrlid, lParam_ctrl_hwnd, msg_num, win_hwnd)
{
    EN_KILLFOCUS=0x200
    hi_word := (wParam_notifycode_ctrlid & 0xFFFF0000) >> 16
    lo_word := (wParam_notifycode_ctrlid & 0x0000FFFF)
    ; OutputDebug, % "text_snippet_hwnd: " text_snippet_hwnd
    ; OutputDebug, % Format("0x{:X}=(0x{:X}|0x{:X}), 0x{:X}, 0x{:X}, 0x{:X}", wParam_notifycode_ctrlid, hi_word, lo_word, lParam_ctrl_hwnd, msg_num, win_hwnd)
    IF  (hi_word = EN_KILLFOCUS) 
    and (lParam_ctrl_hwnd = text_snippet_hwnd) 
    and (snippet_saved == False)
        ; this to avoid having the MessageHandler wait for a proc call ( save_changes_check() ) to return
        SetTimer, CALL_SAVE_CHANGES_CHECK, -1    
    Return 
}

SAVE_CHANGES_CHECK:
    save_changes_check()
    Return

save_changes_check()
{
    Gui, +OwnDialogs
    MsgBox,% 3+32, Modified Snippet, % "Save changes?`r`n`r`n      No =`tLose changes`r`nCancel =`tContinue editing"
    IfMsgBox Yes
        Gosub btn_save
    Else IfMsgBox Cancel
        GuiControl, Focus, text_snippet
    Else IfMsgBox No
    {
        snippet_saved := True   ; snippet reverts back to it's original text, so it is considered saved.
        Gosub lv_snippet
        tooltip_msg(text_snippet_hwnd, "Changes Cancelled")
    }
    ; Return
}
    
tooltip_msg(p_hwnd, p_msg, p_offset_x=20, p_offset_y=20, p_display_time=1000)
{
    ControlGetPos, x, y,,,,ahk_id %p_hwnd%
    x := x + p_offset_x
    y := y + p_offset_y 
    
    Tooltip, `r`n    %p_msg%    `r`n %A_Space%, x, y
    Sleep p_display_time
    Tooltip
    Return
}

;------------------------------------------

GuiEscape:
GuiClose:
    If Not snippet_saved
        save_changes_check()
    Else
        ExitApp

GuiSize:
    OutputDebug, % "A_ThisLabel: " A_ThisLabel " " A_GuiWidth
    g_center_to_this_hwnd := WinExist("A")    ; Global variable used in Center Msgbox To Active Window.ahk
    Return
    
lv_snippet:
    ; OutputDebug, % A_GuiEvent " - " A_ThisLabel
    If RegExMatch(A_GuiEvent,"i)(Normal|K)") Or snippet_saved
    {
        ; refresh / replace text_snippet with listview snippet
        row_num := 0
        row_num := LV_GetNext(row_num)
        LV_GetText(lv_snippet, row_num, 2)
        GuiControl,, text_snippet, %lv_snippet%
    }
    Return
    
text_snippet:   
    If (A_GuiEvent = "Normal")
    {
        OutputDebug, % A_GuiEvent " - " A_ThisLabel
        row_num := 0
        row_num := LV_GetNext(row_num)
        LV_GetText(lv_snippet, row_num, 2)
        ControlGetText, current_snippet,,ahk_id %text_snippet_hwnd%
        snippet_saved := (lv_snippet == text_snippet)
        ttip("snippet_saved: " snippet_saved ", current_snippet: " current_snippet,500,500) 
    }
    Return

btn_copy:    
    Gui, Submit, NoHide
    Clipboard := text_snippet
    ClipWait, 2
    IF (ErrorLevel) or (Clipboard <> text_snippet)
       MsgBox, 48,, % "Couldn't copy snippet."
    Else
       tooltip_msg(text_snippet_hwnd, "Snippet copied to Clipboard.")
    Return
    
btn_save:
    Gui, +OwnDialogs
    Gui, Submit, NoHide
    row_num := 0
    row_num := saved_row_num := LV_GetNext(row_num)
    LV_Modify(saved_row_num, "+Focus +Select")
    If (row_num = 0)    ;   Or snippet_saved
    {
        MsgBox, 48, Unexpected Error, % "ListView does not have focus and or no row selected...Try again!", 3
        Return
    }
    LV_GetText(save_keyword, row_num, 1)
    LV_Insert(row_num,, save_keyword, text_snippet) ; insert new text line at row_num pushing old text line to row_num+1
    LV_Delete(row_num+1)    ; row_num+1 is the old text line, regardless of the sort option, because col1 unchanged.
    LV_GetText(new_text, row_num, 2)  
    Sleep 0
    ;
    snippet_saved := (new_text == text_snippet)
    If snippet_saved
        tooltip_msg(text_snippet_hwnd, "Snippet saved.")
    Else
        MsgBox, 48,, % "Something went wrong saving code snippet. Changes have not been saved."   
    LV_Modify(saved_row_num, "+Focus +Select")
    Return 