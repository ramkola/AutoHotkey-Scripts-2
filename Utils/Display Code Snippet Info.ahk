#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#Include lib\npp.ahk
#Include lib\strings.ahk
#Include lib\misc.ahk
#Include lib\Code Snippets.txt
#Include lib\Center MsgBox To Active Window.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\order.png

OutputDebug, DBGVIEWCLEAR

Global code_snippetz_file :=  A_WorkingDir "\lib\Code Snippets.txt"
Global ed_snippet
Global lv_snippet_hwnd          ; handle  - Listview control
Global ed_snippet_hwnd        ; handle  - Edit control
Global snippet_saved := True    ; boolean - tracks whether changes to code snippet have been saved or not
Global active_control_hwnd      ; control that will be receiving the inserted code snippet (Scintilla in Notepad++)
ControlGetFocus, active_control_classnn, A
ControlGet, active_control_hwnd, Hwnd,,%active_control_classnn%, A

OnMessage(WM_COMMAND, "MessageHandler")

; Listview
lv_w := 150
lv_options = 
(Join`s LTrim 
    hwndlv_snippet_hwnd vlv_snippet glv_snippet_update
    r5 w%lv_w% 
    BackgroundFEFFCD AltSubmit Sort +ReadOnly
    x3 y3
)
Gui, Font, s9, Consolas
Gui, Add, ListView, %lv_options%, Key Word|Snippet
LV_ModifyCol(1, lv_w-21)    ; Key Words sized so that it is the only visible column. -21 gets rid of HScroll.
LV_ModifyCol(2, 0) 
For key_word, snippet in code_snippetz
{
    ; remove escape characters from snippet to show code the way it would appear
    ; when inserted into a program. Escape characters are there only so that 
    ; lib\Code Snippets.txt can build the array "code_snippetz" properly.
    snippet := StrReplace(snippet, "````", "``")
    snippet := StrReplace(snippet, "``)", ")")
    LV_ADD("", key_word, snippet)
}
;
; Edit box
Gui, Font, S9
ed_w := (lv_w * 1.5) - 3 
Gui, Add, Edit, ved_snippet ged_snippet_modify hwnded_snippet_hwnd xp+%lv_w% yp w%ed_w% hp -Wrap -WantTab -HScroll
; Buttons
Gui, Add, Button, hwndbtn_insert_hwnd vbtn_insert gbtn_insert x3 w50 h18 -TabStop, &Insert
Gui, Add, Button, hwndbtn_save_hwnd vbtn_save gbtn_save       wp hp x+0 yp -TabStop, &Save
Gui, Add, Button, hwndbtn_revert_hwnd vbtn_revert gbtn_revert wp hp x+0 yp -TabStop, &Revert
Gui, Add, Button, hwndbtn_delete_hwnd vbtn_delete gbtn_delete wp hp x+0 yp -TabStop, &Delete
Gui, Add, Button, hwndbtn_copy_hwnd vbtn_copy gbtn_copy       wp hp x+0 yp -TabStop, &Copy
; Focus on first key word in listview
GuiControl, Focus, lv_snippet
LV_Modify(1, "+Focus +Select")

OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

; Gui Window
ControlGetPos,,lv_y,,,, ahk_id %lv_snippet_hwnd% 
ControlGetPos,,, edit_w,,, ahk_id %ed_snippet_hwnd% 
ControlGetPos,,btn_y,, btn_h,, ahk_id %btn_save_hwnd% 
gui_w := lv_w + edit_w + 6              
gui_height := btn_y + btn_h - lv_y + 6
gui_x := A_ScreenWidth - gui_w - 5      ; top right corner of screen
Gui, +AlwaysOnTop 
Gui, Show, x%gui_x% y0 w%gui_w% h%gui_height%, Code Snippets
Return

;----------------------------------------
; Gui Event Handlers (formerly g-labels)
;----------------------------------------
ed_snippet_modify(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    ; OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event ", event_info: " event_info ", error_level: " error_level 
    ; OutputDebug, % "gui_event: " gui_event " - Line#" A_LineNumber " - " A_ThisFunc
    Gui, +OwnDialogs
    If (gui_event = "Normal")
    {
        row_num := 0
        row_num := LV_GetNext(row_num)
        row_num := (row_num = 0) ? 1 : row_num
        LV_GetText(lv_snippet, row_num, 2)
        ControlGetText, current_snippet,,ahk_id %ed_snippet_hwnd%
        snippet_saved := (lv_snippet == current_snippet)
    }
    Return
}

lv_snippet_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    ; OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event ", event_info: " event_info ", error_level: " error_level 
    Gui, +OwnDialogs
    If RegExMatch(gui_event,"(Normal|I|F)") Or snippet_saved
    {
        ; refresh / replace ed_snippet with lv_snippet 
        row_num := 0
        row_num := LV_GetNext(row_num)
        row_num := (row_num = 0) ? 1 : row_num
        LV_GetText(code_text, row_num, 2)
        GuiControl,, ed_snippet, %code_text%
    }
    If (gui_event = "DoubleClick")
        btn_insert()
    Return    
}

btn_insert(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    GuiControlGet, ed_snippet
    ; Can't use Control, EditPaste.... only pastes 1 character in Scintilla control: Control, EditPaste, %ed_snippet%,, ahk_id %active_control_hwnd% 
    saved_clipboard := ClipboardAll
    Clipboard := ed_snippet
    ClipWait, 1 
    ControlFocus,,ahk_id %active_control_hwnd%
    If (Clipboard == ed_snippet)
        WinMenuSelectItem, A,, Edit, Paste
    Else
        SendInput % ed_snippet
    SendInput {Enter}
    Clipboard := saved_clipboard    
    Return
}
    
btn_copy(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    GuiControlGet, ed_snippet 
    Clipboard := ed_snippet
    ClipWait, 2
    IF (ErrorLevel) or (Clipboard <> ed_snippet)
       MsgBox,% 0+48+4096,, % "Couldn't copy snippet. ErrorLevel: " ErrorLevel "`r`n" ed_snippet 
    Else
       tooltip_msg(ed_snippet_hwnd, "Snippet copied to Clipboard.")
    Return
}
    
btn_save(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    Gui, Submit, NoHide
    row_num := 0
    row_num := LV_GetNext(row_num)
    ; row_num := (row_num = 0) ? 1 : row_num
    If (row_num = 0)
    {
        MsgBox, 48, Unexpected Error, % "ListView does not have focus and or no row selected...Try again!", 3
        Return
    }
    LV_Modify(row_num,,,ed_snippet)
    LV_GetText(new_text, row_num, 2)  
    snippet_saved := (new_text == ed_snippet)
    If snippet_saved
        tooltip_msg(ed_snippet_hwnd, "Snippet saved.")
    Else
        MsgBox, 48, Unexpected Error, % "Something went wrong saving code snippet. Changes have not been saved."   
    LV_Modify(row_num, "+Focus +Select")
    Return 
}

btn_revert(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    lv_snippet_update()
    snippet_saved := True   ; snippet reverts back to it's last saved text, so it is considered saved.
    tooltip_msg(lv_snippet_hwnd, "Unsaved changes have been canceled`r`n`r`nViewing the last saved version of Code Snippet", 3000)
    Return 
}

btn_delete(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui, +OwnDialogs
    row_num := 0
    row_num := LV_GetNext(row_num)
    If (row_num = 0)
        MsgBox, 48,, % "No keyword selected"
    Else
    {   
        MsgBox,% 4+32,, % "Are you sure you want to delete this snippet?"
        IfMsgBox, Yes
        {
            LV_Delete(row_num)
            snippet_saved := ErrorLevel
            If (ErrorLevel = 0)
                MsgBox, 48,, % "Could not delete this snippet. Try again..."
            Else
                tooltip_msg(ed_snippet_hwnd, "Snippet Deleted")
        }
    }
    Return 
}
;----------
; G-Labels
;----------
Escape::
GuiEscape:
GuiClose:
    If Not snippet_saved
    {
        tooltip_msg(lv_snippet_hwnd, "Save or revert changes before trying to exit...")
        Return
    }
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    If save_code_snippetz()
        ExitApp
    Else
    {
        MsgBox, 48,, % "Could not save Code Snippets file:`r`n" code_snippetz_file
        Return
    }

GuiSize:
    g_center_to_this_hwnd := WinExist("A")    ; Global variable used in Center Msgbox To Active Window.ahk
    Return
;------------------------------------------
;  Subroutines - Functions, Procedures
;------------------------------------------
MessageHandler(wParam_notifycode_ctrlid, lParam_ctrl_hwnd, msg_num, win_hwnd)
{
    EN_KILLFOCUS=0x200                        
    hi_word := (wParam_notifycode_ctrlid & 0xFFFF0000) >> 16
    lo_word := (wParam_notifycode_ctrlid & 0x0000FFFF)
    
    ; ; keep for debugging
    ; control_hwnd := Format("0x{:X}", lParam_ctrl_hwnd) 
    ; IF (hi_word = EN_KILLFOCUS) and (lParam_ctrl_hwnd = ed_snippet_hwnd)
    ; {
        ; OutputDebug, % Format("0x{:X}=(0x{:X}|0x{:X}), 0x{:X}, 0x{:X}, 0x{:X}", wParam_notifycode_ctrlid, hi_word, lo_word, lParam_ctrl_hwnd, msg_num, win_hwnd) "- " A_ThisFunc " (" A_ScriptName ")"
        ; OutputDebug, % "hi_word: " Format("0x{:X}", hi_word) " - control_hwnd: " control_hwnd " - snippet_saved: " snippet_saved " - " A_ThisFunc " (" A_ScriptName ")"
    ; }

    IF  (hi_word = EN_KILLFOCUS) 
    and (lParam_ctrl_hwnd = ed_snippet_hwnd) 
    and (snippet_saved == False)
    {
        ; this to avoid having the MessageHandler wait for the proc call "save_changes_check()" to return
        SetTimer, CALL_SAVE_CHANGES_CHECK, -1    
    }
    Return 
}

CALL_SAVE_CHANGES_CHECK:
    save_changes_check()
    Return

save_changes_check()
{
    Gui, +OwnDialogs
    MsgBox,% 3+32+512, Modified Snippet, % "Save changes?`r`n`r`n      No =`tRevert changes`r`nCancel =`tContinue editing"
    IfMsgBox Yes
        btn_save()
    Else IfMsgBox Cancel
        GuiControl, Focus, ed_snippet
    Else IfMsgBox No
        btn_revert()
    Return
}

save_code_snippetz()
{
    code_snippet := "/*`r`n    This file sets the code_snippetz array with the key and code needed to insert a snippet`r`n*/`r`n`r`n"
    code_snippet .= "code_snippetz := {}`r`n"
    Loop % LV_GetCount()
    {
        LV_GetText(keyword, A_Index, 1)
        LV_GetText(snippet, A_Index, 2)
        code_snippet .= create_code_snippet_entry(keyword, snippet)     ; see lib\misc.ahk
    }
    source := code_snippetz_file
    dest := source ".old"
    FileCopy, %source%, %dest%, 1
    FileDelete, %source%
    FileAppend, %code_snippet%, %source%
    Return FileExist(source)
}
    
tooltip_msg(p_hwnd, p_msg, p_display_time=1000, p_offset_x=20, p_offset_y=20)
{
    ControlGetPos, x, y,,,,ahk_id %p_hwnd%
    x := x + p_offset_x
    y := y + p_offset_y 
    
    Tooltip, `r`n    %p_msg%    `r`n %A_Space%, x, y
    Sleep p_display_time
    Tooltip
    Return
}
