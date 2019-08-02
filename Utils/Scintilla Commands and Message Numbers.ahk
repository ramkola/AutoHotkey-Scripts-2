#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\Get Scintilla Constants and Message Numbers.ahk
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\Scintilla.ico

load_sci_constants()

Global scintilla_hwnd, npp_hwnd, txt_kb_hwnd
script_wintitle = Scintilla Commands and Message Numbers ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
npp_hwnd := WinExist("A")
ControlGetFocus, scintilla_classnn, ahk_id %npp_hwnd%
ControlGet, scintilla_hwnd, Hwnd,,%scintilla_classnn%, ahk_id %npp_hwnd%

Menu,context_menu, Add, % "SendMessage", MENU_HANDLER
Menu,context_menu, Add, Help, MENU_HANDLER
Menu,context_menu, Add, Constant, MENU_HANDLER
Menu,context_menu, Add, Keyboard Only, MENU_HANDLER
Menu,context_menu, Add, % "All Constants", MENU_HANDLER
Menu,context_menu, Add, 
Menu,context_menu, Add, DbgView, MENU_HANDLER

Gui, Font, S12, Consolas
Gui, Add, Edit, hwnded_search ved_search ged_search -Wrap -WantTab -WantReturn -HScroll
Gui, Font, S10
Gui, Add, Text, hwndtxt_kb_hwnd xp+200 yp w50 cBlue +Wrap , Keyboard Constants
GuiControl, Hide, %txt_kb_hwnd%
Gui, Font, S10
Gui, Add, ListView, hwndlv_hwnd vlv_sci_constant glv_update xm r10 w300, Constant|Msg Num
For constant, msg_num In sci_constants
    LV_Add("", constant, msg_num)
LV_ModifyCol(1, 225)
LV_ModifyCol(2, 70) 
LV_Modify(1, "+Focus +Select")
;
Gui, Show, x950 y0, % Substr(A_ScriptName, 1, -4)
Return

#If WinActive(script_wintitle)

~Enter::
    lv_update(lv_hwnd, "DoubleClick", 0)
    Return

F1:: 
    row_num := 0
    row_num := LV_GetNext(row_num)
    row_num := (row_num = 0) ? 1 : row_num
    LV_GetText(constant, row_num, 1)
    Clipboard := constant
    get_help(constant)
    Return

AppsKey::
RButton:: 
    Menu, context_menu, Show
    Return
;----------------------------------------

MENU_HANDLER:
    If (A_ThisMenuItem = "SendMessage")
        send_message()
    Else If (A_ThisMenuItem = "Help")
        Goto F1
    Else If (A_ThisMenuItem = "Constant")
        Goto ~Enter
    Else If (A_ThisMenuItem = "Keyboard Only")
        lv_update(npp_hwnd, "USER UPDATE EVENT", sci_keyboard_commands, 99999 )
    Else If (A_ThisMenuItem = "All Constants")
        lv_update(npp_hwnd, "USER UPDATE EVENT", sci_constants )
    Else If (A_ThisMenuItem = "DbgView")
        WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Return
;----------------------------------------
; Gui Event Handlers (formerly g-labels)
;----------------------------------------
ed_search(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="") 
{
    ControlGetText, ed_search,,ahk_id %ctrl_hwnd%
    GuiControlGet, kb_flag, Visible, %txt_kb_hwnd% 
    cur_sci_array := kb_flag ? sci_keyboard_commands : sci_constants
    filtered_sci_commands := {}
    For key, value In cur_sci_array
    {
        If RegExMatch(key, "i)^.*" ed_search ".*")
            filtered_sci_commands[key] := value
    }
    error_level := kb_flag ? 99999 : ""
    lv_update(ctrl_hwnd, "USER UPDATE EVENT", filtered_sci_commands, error_level)
    Return
}

lv_update(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    ; OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event ", event_info: " event_info ", error_level: " error_level
    If (gui_event = "USER UPDATE EVENT")
    {
        ; event_info is the current array of constants
        LV_Delete()
        For constant, msg_num In event_info
            LV_Add("", constant, msg_num)
        If (error_level = 99999)
            GuiControl, Show, %txt_kb_hwnd%
        Else
            GuiControl, Hide, %txt_kb_hwnd%
        LV_Modify(1, "+Focus +Select")
    }
    Else If (gui_event = "DoubleClick")
    {
        row_num := event_info
        If (row_num = 0)
        {
            row_num := LV_GetNext(row_num)
            row_num := (row_num = 0) ? 1 : row_num
        }
        LV_Modify(row_num, "+Focus +Select")
        LV_GetText(constant, row_num, 1)
        LV_GetText(msg_num,  row_num, 2)
        Clipboard :=  constant " = " msg_num
        ClipWait, 1
        MsgBox, , Copied to Clipboard:, %Clipboard%
    }
    Return
}

GuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y)
{
    OutputDebug, % "GuiHwnd: " GuiHwnd ", CtrlHwnd: " CtrlHwnd ", EventInfo: " EventInfo ", IsRightClick: " IsRightClick ", " x ", " y " - " A_CoordModeMouse " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    Return
}
;--------------------
; G-Labels & Hotkeys
;-------------------
Escape::
GuiEscape:
GuiClose:
    ExitApp
    
GuiSize:
    Return
;--------------------
; Subroutines
;-------------------
send_message()
{
    row_num := 0
    row_num := LV_GetNext(row_num)
    row_num := (row_num = 0) ? 1 : row_num
    LV_GetText(constant, row_num, 1)
    LV_GetText(msg_num, row_num, 2)
    Clipboard := constant " = " msg_num 
              .  "`r`nwParam := 0, lparam := 0"
              .  "`r`nSendMessage, " constant ", wParam, lParam,, ahk_id %scintilla_hwnd%" 
              .  "`r`nMsgBox, % ""ErrorLevel: "" ErrorLevel"
    MsgBox,,% "Copied to Clipboard", %Clipboard%
    Return
}

    
    
    