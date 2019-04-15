#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\Code Snippets.txt
#NoTrayIcon

Global text_snippet_hwnd        ; handle - text_snippet (Edit) control
Global snippet_saved := True    ; boolean - tracks whether changes to code snippet have been saved or not
WM_COMMAND = 0x111
OnMessage(WM_COMMAND,"MessageHandler")

; create gui
lv_width := 200
text_width := lv_width * 1.5
Gui, Font, s14, Consolas
Gui, Add, ListView
    , r5 w%lv_width% vlv_snippet glv_snippet Backgroundfeffcd AltSubmit Sort +ReadOnly 
    , Key Word|Snippet
LV_ModifyCol(1, lv_width)    ; Key Words sized so that it is the only visible column
LV_ModifyCol(2, 0) 
For key_word, snippet in code_snippetz
    LV_ADD("", key_word, snippet)

Gui, Font, S9, %textFont%
Gui, Add, Edit, vtext_snippet gtext_snippet hwndtext_snippet_hwnd xp+%lv_width% yp w%text_width% hp -Wrap -WantTab -HScroll 
Gui, Add, Button, w100 xm vbtn_save gbtn_save, &Save

; Focus on first script in list
If LV_GetCount()
{
    GuiControl, Focus, lv_snippet
    LV_Modify(1, "+Focus +Select")
    SendInput {Down}{Up}
}
;
Gui +AlwaysOnTop
gui_x := A_ScreenWidth - 534
Gui, Show, x%gui_x% y0
Return

;------------------------------------------
MessageHandler(wParam_notifycode_ctrlid, lParam_ctrl_hwnd, msg_num, win_hwnd)
{
    EN_KILLFOCUS=0x200
    hi_word := (wParam_notifycode_ctrlid & 0xFFFF0000) >> 16
    lo_word := (wParam_notifycode_ctrlid & 0x0000FFFF)
    ; OutputDebug, % "text_snippet_hwnd: " text_snippet_hwnd
    ; OutputDebug, % Format("0x{:X}=(0x{:X}|0x{:X}), 0x{:X}, 0x{:X}, 0x{:X}", wParam_notifycode_ctrlid, hi_word, lo_word, lParam_ctrl_hwnd, msg_num, win_hwnd)
    IF (hi_word = EN_KILLFOCUS) and (lParam_ctrl_hwnd = text_snippet_hwnd) and (snippet_saved == False)
    {
        ; OutputDebug, % "Text Snippet edit control has lost focus"
        update_code_snippet()
    }
    Return 
}

update_code_snippet()
{
    If Not snippet_saved
    {
        MsgBox, 36,, % "Save changes?"
        IfMsgBox Yes
            Gosub btn_save
    }
    Return
}
;------------------------------------------


Escape:
GuiEscape:
GuiClose:
    ExitApp

GuiSize:
    ; OutputDebug, % "A_ThisLabel: " A_ThisLabel " " A_GuiWidth
    Return
    
lv_snippet:
    row_num := 0
    If RegExMatch(A_GuiEvent,"i)(Normal|K)")
    {
        row_num := LV_GetNext(row_num)
        LV_GetText(lv_snippet, row_num, 2)
        GuiControl,, text_snippet, %lv_snippet%
    }
    Return
    
text_snippet:   
    If (A_GuiEvent = "Normal")
        OutputDebug, % A_GuiEvent " - " A_ThisLabel
        snippet_saved := False  ; user has changed the code snippet and has not saved the changes yet.
    Return
    
btn_save:
    Gui, Submit, NoHide
    row_num := 0
    row_num := saved_row_num := LV_GetNext(row_num)
    LV_Modify(saved_row_num, "+Focus +Select")
    if (row_num = 0)    ;   Or snippet_saved
    {
        MsgBox, 48,, % "Nothing to save.`r`n`r`nListView does not have focus and or no row selected", 3
        Return
    }
    LV_GetText(save_keyword, row_num, 1)
    LV_Insert(row_num,, save_keyword, text_snippet) ; insert new text line at row_num pushing old text line to row_num+1
    MsgBox, 48,, % "about to delete"
    ; LV_Delete(row_num+1)    ; row_num+1 is the old text line, regardless of the sort option, because col1 unchanged.
    LV_GetText(new_text, row_num, 2)   
    If (new_text == text_snippet)
    {
        snippet_saved := True
        MsgBox, 64,, % "Snippet saved.", 1
    }
    Else
    {
        snippet_saved := False
        MsgBox, 48,, % "Something went wrong saving code snippet. Changes have not been saved."
    }

    ; GuiControl, Focus, lv_snippet
    LV_Modify(saved_row_num, "+Focus +Select")
    Return 