#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\Code Snippets.txt
#NoTrayIcon

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
Gui, Add, Edit, xp+%lv_width% yp w%text_width% hp vtext_snippet -Wrap WantTab -HScroll 
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

Escape:
GuiEscape:
GuiClose:
    ExitApp

GuiSize:
    OutputDebug, % "A_ThisLabel: " A_ThisLabel " " A_GuiWidth
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
    
 btn_save:
    Gui, Submit, NoHide
    row_num := 0
    row_num := LV_GetNext(row_num)
    LV_GetText(save_col1, row_num, 1)
    LV_Delete(row_num)
    LV_Insert(row_num,, save_col1, text_snippet)
    Return