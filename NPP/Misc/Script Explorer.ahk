#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\npp.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%
SetCapsLockState, AlWaysOff
#NoTrayIcon
Menu, Tray, Icon, ..\resources\32x32\Signs\milestone.png    ; displays icon on control

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

; global variables
Global g_file_names := []
Global g_hwnd_editor := ""
Global g_font_size := 12
Global g_sorted := False
Global g_ini_file := A_ScriptDir "\" A_ScriptName ".ini"
WinGet, g_hwnd_editor, ID, A
Global g_script_file := npp_get_current_filename()
Global g_script_explorer_wintitle := "Script Explorer ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe"
; load ini settings
gui_dimensions = X200 Y200 W400 H400
If FileExist(g_ini_file)
{
    Loop, Read, %g_ini_file%
    {
        If (A_Index = 1)
            gui_dimensions := A_LoopReadLine
        If (A_Index = 2)
            g_font_size := A_LoopReadLine
        If (A_Index = 3)
            always_on_top := A_LoopReadLine
    }
}
;--------------------------------
; build file map & load treeview
;--------------------------------
OnExit("GuiClose")
OnMessage(0x100, "on_key_down") ; monitor WM_KEYDOWN
create_context_menu()
get_includes()
get_file_map(g_script_file)
Gui, Font, s%g_font_size%  
GuiControl, Font, tv_proc_text
Gui, Add, TreeView, r20 w400 0x400 vtv_proc_text gtv_proc       ; TVS_SINGLEEXPAND = 0x400
load_treeview()

; main window
Try
    Gui, Show, %gui_dimensions%, Script Explorer
Catch
{
    FileDelete, %g_ini_file%
    Gui, Show, X200 Y200 W400 H400, Script Explorer
}
Gui, +Resize +Owner %always_on_top%
if always_on_top()
    Menu, context_menu, Check, &Always On Top              
else
    Menu, context_menu, UnCheck, &Always On Top              

Return

;--------------- Hotkeys ---------------------------------;
#If Not WinExist(g_script_explorer_wintitle)
Capslock & s::  ; toggles Hide/Show Script Explorer window
    WinRestore, %g_script_explorer_wintitle%   ; in case window was minimized
    WinShow, %g_script_explorer_wintitle%   ; in case window was hidden
    WinActivate, %g_script_explorer_wintitle%
    Return

#If WinExist(g_script_explorer_wintitle)
Capslock & s::  ; toggles Hide/Show Script Explorer window
HIDE_SCRIPT_EXPLORER:
    WinRestore, %g_script_explorer_wintitle%   ; in case window was minimized
    WinHide, %g_script_explorer_wintitle%
    Return

Capslock & f::  ; toggles focus between Script Explorer and Notepad++
    WinGetTitle, active_win, A
    If  (active_win != "script explorer")
        WinActivate, %g_script_explorer_wintitle%
    else
        WinActivate, ahk_id %g_hwnd_editor%
    Return

#If WinActive(g_script_explorer_wintitle)
^WheelUp::
^NumpadAdd::
    g_font_size++
    Gui, Font, s%g_font_size%
    GuiControl, Font, tv_proc_text
    Return

^WheelDown::
^NumpadSub::
    g_font_size--
    Gui, Font, s%g_font_size%
    GuiControl, Font, tv_proc_text
    Return

;---------- Gui Event Handlers -----------------------;
GuiEscape:
    GuiClose()

GuiClose()
{
    WinRestore, %g_script_explorer_wintitle%   ; in case window was minimized
    WinShow, %g_script_explorer_wintitle%   ; in case window was hidden
    WinGetPos, x, y, w, h, %g_script_explorer_wintitle%
    write_string := "X"x " Y"y " W"(w-6) " H"(h-29) "`n"
    write_string .= g_font_size "`n"
    write_string .= always_on_top() ? "+AlwaysOnTop" : "-AlwaysOnTop"
    FileDelete, %g_ini_file%
    FileAppend, %write_string% `n, %g_ini_file%
    WinActivate, ahk_id %g_hwnd_editor%
    ExitApp
}

GuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y)
{
    If (A_GuiControl = "tv_proc_text")
    {
        If IsRightClick And (A_EventInfo != 0)
            Click   ; select item that was rightclicked on. A_EventInfo has the item_id when an item is clicked.
        Menu, context_menu, Show
    }
}

GuiSize(GuiHwnd, EventInfo, Width, Height)
{
    Static countx := 0
    Static save_width := 0
    Static save_height := 0
    if (Width = save_width) and (Height = save_height)
        return
    else
        save_width = Width, save_height = Height
    countx++
    ; OutputDebug, % "countx: " countx
    If (A_EventInfo = 1)  ; The window has been minimized. No action needed.
        Return
    ; Otherwise, the window has been resized or maximized. Resize the controls to match.
    GuiControl, Move, tv_proc_text, % "w" (Width - 30) "h" (Height - 30)
    Return
}

on_key_down(wParam)
{
    If (A_Gui = 1)
    {
        GuiControlGet, got_focus, FocusV
        If (got_focus = "tv_proc_text") And (wParam = 13)               ; VK_ENTER := 13
            locate_proc_call()
    }
}
;---------- g-subroutines ----------------------------;
tv_proc()
{
    If (A_GuiControlEvent = "DoubleClick")
        locate_proc_call()
}

;---------- Procedures ------------------------------;
locate_proc_call()
{
    ;-----------------------------------------------------------------------------
    ; This procedure gathers all the necessary info needed to get the code line #
    ; and the parent fullpath information from the g_file_names array.
    ;-----------------------------------------------------------------------------
    parent_node_clicked := 0
    category_node_clicked := 1
    child_item_clicked := 2

    ; find parent node - needed to get the filepath 
    selected_id := TV_GetSelection()
    tv_item_ids := [] 
    parent_check_id := selected_id
    While (parent_check_id != 0)
    {
        parent_id := parent_check_id
        parent_check_id := TV_GetParent(parent_id)
        If (parent_check_id != 0)
        {
            TV_GetText(item_text, parent_check_id)     
            tv_item_ids.Push([parent_check_id, item_text])
        }
    }
    ; selection_type = 0 means parent node was clicked ie: filename.ahk
    ; selection_type = 1 means category node was clicked ie: Procedure/HotKey/Label
    ; selection_type = 2 means specific child item was clicked ie: myprocedure(param1,param2)
    selection_type := tv_item_ids.Length()

    If (selection_type = parent_node_clicked)   
        TV_GetText(parent_name, selected_id)
    Else
        parent_name := tv_item_ids[tv_item_ids.MaxIndex()][2]
    result := get_fullpath(parent_name)
    info := StrSplit(result, Chr(7))
    parent_fullpath := info[1]
    parent_index := info[2]

    ; find category index
    If (selection_type = category_node_clicked)
        TV_GetText(category_name, selected_id)
    Else
    {
        category_id := tv_item_ids[tv_item_ids.MaxIndex() - 1][1]
        category_name := tv_item_ids[tv_item_ids.MaxIndex() - 1][2]
    }
    If (category_name == "Procedures")
        category_index := 5
    Else If (category_name == "Hotkeys")
        category_index := 3
    Else If (category_name == "Labels")
        category_index := 4
    Else
        If (selection_type != parent_node_clicked)   
        {
            category_index := 0
            OutputDebug, % A_ThisFunc " - unexpected category_name: " category_name 
        }

    ; find child item key which will match g_file_names' associative array key
    ; i.e. if user clicked on myprocedure(param1) in script explorer it will
    ; go to that procedure call which is a key name in g_file_names array.
    If (selection_type > 1)
        TV_GetText(item_key_name, selected_id)

    ; find code line number
    If (selection_type = parent_node_clicked) or (selection_type = category_node_clicked)
        code_line_num := 0  ; no specific procedure was picked so go to beginning of file
    Else
        code_line_num := g_file_names[parent_index][category_index][2][item_key_name] - 1

    ; run (pythonscript) procedure to activate the file and go to the code line number
    result := npp_activate_and_goto_line(code_line_num, parent_fullpath)
    If (result == "True")
    {
        WinActivate, ahk_id %g_hwnd_editor%
        OutputDebug, % A_ThisFunc " - Success, code_line_num:" code_line_num " parent: ..." SubStr(parent_fullpath, -30)
    }
    Else
        OutputDebug, % A_ThisFunc " - Failed, result: "  result " - " item_key_name " " code_line_num
}

get_fullpath(p_fname)
{
    result := ""
    For i_index, file_name_rec in g_file_names
    {
        If (p_fname = file_name_rec[1])
        {
            result := file_name_rec[2]
            Break
        }
    }
    result := result Chr(7) i_index
    Return %result%
}

get_includes()
{
    FileRead, in_file_var, %g_script_file%
    Loop, Parse, in_file_var, `n, `r 
    {
        If (SubStr(A_LoopField, 1, 8) = "#include")
        {
            include_param := SubStr(A_LoopField, 10)
            file_attribs := FileExist(include_param)
            If InStr(file_attribs, "D")
                include_library_path := include_param
            Else 
            {
                If include_library_path
                    library_path := include_library_path "\" include_param
                Else If InStr(include_param,"%A_ScriptDir%")
                {
                    relative_path := StrReplace(include_param,"%A_ScriptDir%","")
                    SplitPath, g_script_file,,script_dir
                    library_path := script_dir relative_path
                }
                ;
                If !FileExist(library_path)
                {
                    OutputDebug, % "Invalid library_path: " library_path
                    Continue
                }
                Else 
                    get_file_map(library_path)
            }
        }
    }
}

create_context_menu()
{
    Menu, context_menu, Add, &Open, context_menu_handler
    Menu, context_menu, Add, &Copy, context_menu_handler
    Menu, context_menu, Add, &Insert, context_menu_handler
    Menu, context_menu, Add
    Menu, context_menu, Add, &Always On Top, context_menu_handler
    Menu, context_menu, Add, &Sorted, context_menu_handler
    Menu, context_menu, Add
    Menu, context_menu, Add, &Collapse, context_menu_handler
    Menu, context_menu, Add, &Expand, context_menu_handler
    Menu, context_menu, Add, Co&llapse All, context_menu_handler
    Menu, context_menu, Add, E&xpand All, context_menu_handler
    Menu, context_menu, Add
    Menu, context_menu, Add, &Hide, context_menu_handler
    Menu, context_menu, Add, &Reload, context_menu_handler
    Menu, context_menu, Add, &Exit, context_menu_handler
}

context_menu_handler()
{
    selected_id := TV_GetSelection()
    parent_id := TV_GetParent(selected_id)
    TV_GetText(proc_call, selected_id)
    If (A_ThisMenuItem = "&Insert")     
    {
        Clipboard := proc_call
        WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
        SendInput {End}{Enter}^v
    }
    Else If (A_ThisMenuItem = "&Copy")
        Clipboard := proc_call
    Else If (A_ThisMenuItem = "&Open")
        locate_proc_call()
    Else If (A_ThisMenuItem = "&Always on top")
    {
        If always_on_top()
        {
            Gui -AlwaysOnTop
            Menu, context_menu, Uncheck, &Always On Top        
        }
        Else
        {
            Gui +AlwaysOnTop
            Menu, context_menu, Check, &Always On Top        
        }
    }
    Else If (A_ThisMenuItem = "&Sorted")
        sort_treeview()
    Else If (A_ThisMenuItem = "&Collapse")
        TV_Modify(parent_id, "-Expand")
    Else If (A_ThisMenuItem = "&Expand")
        TV_Modify(parent_id, "Expand")
    Else If (A_ThisMenuItem = "Co&llapse All")
        expand_treeview("Collapse")
    Else If (A_ThisMenuItem = "E&xpand All")
        expand_treeview("Expand")
    Else If (A_ThisMenuItem = "&Hide")
        Gosub HIDE_SCRIPT_EXPLORER
    Else If (A_ThisMenuItem = "&Reload")
        Reload
    Else If (A_ThisMenuItem = "&Exit")
        GuiClose()
    Return
}

always_on_top()
{
    WinGet, ex_style, ExStyle, %g_script_explorer_wintitle%
    return (ex_style & 0x8)   ; 0x8 is WS_EX_TOPMOST returns 8 (true) if topmost  or 0 (false) if not topmost 
}

sort_treeview()
{
OutputDebug, % A_ThisFunc " - doesn't work yet" 
    If g_sorted
    {
        g_sorted := False
        Menu, context_menu, Uncheck, &Sorted
        TV_Modify(TV_GetParent(A_EventInfo), "-Sort")
        ; TV_Modify(0, "-Sorted")
    }
    Else
    {
        g_sorted := True
        Menu, context_menu, Check, &Sorted
        TV_Modify(TV_GetParent(A_EventInfo), "+Sort")
        ; TV_Modify(0, "Sort")
    }
}

expand_treeview(p_expand)
{
    item_id = 0  ; Causes the loop's first iteration to start the search at the top of the tree.
    Loop
    {
        item_id := TV_GetNext(item_id, "Full")
        If Not item_id  ; No more items in tree.
            Break
        parent_id := TV_GetParent(item_id)
        If (parent_id = 0)  ; item_id is a parent node
        {
            If (p_expand = "collapse")
                TV_Modify(item_id, "-Expand")
            Else
                TV_Modify(item_id, "+Expand")
        }
    }
}

load_treeview()
{
    For file_index, file_name in g_file_names
    {
        file_display_name := file_name[1]
        file_fullpath := file_name[2]
        hotkey_info := file_name[3]
        label_info := file_name[4]
        procedure_info := file_name[5]
        
        parent_id := TV_Add(file_display_name)
        hotkey_id := TV_Add(hotkey_info[1], parent_id)
        For key, value in hotkey_info[2]
            TV_Add(key, hotkey_id)
    
        label_id := TV_Add(label_info[1], parent_id)
        For key, value in label_info[2]
            TV_Add(key, label_id)
    
        procedure_id := TV_Add(procedure_info[1], parent_id)
        For key, value in procedure_info[2]
            TV_Add(key, procedure_id)
        
        ; expand procedures for script being explored
        If (file_index = g_file_names.MaxIndex())
            TV_Modify(procedure_id, "Expand Select") 
    }
}

get_file_map(p_in_file)
{
    hotkeys := {}
    labels := {}
    procedures := {}
    FileRead, in_file_var, %p_in_file% 
    Loop, Parse, in_file_var, `n, `r 
    {
        If RegExMatch(A_LoopField, "mO)^\w+\(.*\)", match, 1) ; find procedures
            procedures[match.value] := A_Index 
        Else If RegExMatch(A_LoopField, "mO)^.*[^""]::.*", match, 1) ; find hotkeys
        {
            If Not InStr(A_LoopField, Chr(34))
                hotkeys[match.value] := A_Index
        }
        Else If RegExMatch(A_LoopField, "mO)^\w+:$", match, 1) ; find labels
            labels[match.value] := A_Index
    }

    SplitPath, p_in_file, fname    
    g_file_names.Push([fname, p_in_file
        , ["Hotkeys", hotkeys]
        , ["Labels", labels]
        , ["Procedures", procedures]])
}


^x::ExitApp

; Traverse treeview
; Global g_treeview_itemids := {}
; Global g_treeview_itemids := []
; ItemID = 0  ; Causes the loop's first iteration to start the search at the top of the tree.
; Loop
; {
    ; ItemID := TV_GetNext(ItemID, "Full")  ; Replace "Full" with "Checked" to find all checkmarked items.
    ; if not ItemID  ; No more items in tree.
        ; break
    ; TV_GetText(ItemText, ItemID)
    ; ; g_treeview_itemids[ItemID] := ItemText
    ; g_treeview_itemids[ItemID] := ItemText
; }
; for key, value in g_treeview_itemids
; {
    ; OutputDebug, % key ": " value
; }