#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
; #Include lib\processes.ahk
; #Include lib\strings.ahk
; #Include lib\utils.ahk
#Include lib\constants.ahk
#Include lib\npp.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%
#NoTrayIcon
Menu, Tray, Icon, ..\resources\32x32\Signs\milestone.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

OnExit("GuiClose")
OnMessage(0x100, "on_key_down") ; monitor WM_KEYDOWN
; create context_menu
Menu, context_menu, Add, &Insert, context_menu_handler
Menu, context_menu, Add, &Copy, context_menu_handler
Menu, context_menu, Add, &Open, context_menu_handler
Menu, context_menu, Add
Menu, context_menu, Add, &Always On Top, context_menu_handler
Menu, context_menu, Add, &Sorted, context_menu_handler
Menu, context_menu, Add
Menu, context_menu, Add, &Collapse, context_menu_handler
Menu, context_menu, Add, &Expand, context_menu_handler
Menu, context_menu, Add, Co&llapse All, context_menu_handler
Menu, context_menu, Add, E&xpand All, context_menu_handler
Menu, context_menu, Add
Menu, context_menu, Add, &Reload, context_menu_handler
Menu, context_menu, Add, &Exit, context_menu_handler
Menu, context_menu, Check, &Always On Top                       ; initialize with a checkmark because Gui +AlwaysOnTop is initial state

; global variables
Global g_file_names := []
Global g_hwnd_editor := ""
Global g_font_size := 12
Global g_sorted := False
Global g_ini_file := A_ScriptDir "\" A_ScriptName ".ini"
WinGet, g_hwnd_editor, ID, A
g_hwnd_editor := "ahk_id " g_hwnd_editor
Global npp_tab_list := []
Global g_in_file := get_current_npp_filename()
;---------------------------------------
; build procedures array
;---------------------------------------
FileRead, in_file_var, %g_in_file% 
; get_includes(in_file_var)

categories := ["Hotkeys", "Labels", "Procedures"]
hotkeys := {}
labels := {}
procedures := {}
SplitPath, g_in_file, fname    
Loop, Parse, in_file_var, `n, `r 
{
    If RegExMatch(A_LoopField, "mO)^\w+\(.*\)", match, 1) ; find procedures
        procedures[match.value] := A_Index 
    Else If RegExMatch(A_LoopField, "mO)^.*[^""]::.*", match, 1) ; find hotkeys
        if not instr(A_LoopField, chr(34))
            hotkeys[match.value] := A_Index
    Else If RegExMatch(A_LoopField, "mO)^.*:\s*", match, 1) ; find labels
        if not instr(A_LoopField, chr(34))
            labels[match.value] := A_Index
}
g_file_names.Push([fname, g_in_file
    , ["Hotkeys", hotkeys]
    , ["Labels", labels]
    , ["Procedures", procedures]])

Gui, Font, s%g_font_size%  
; load treeview with procedure calls
Gui, Add, TreeView, r20 w400 0x400 vtv_proc_text gtv_proc       ; TVS_SINGLEEXPAND = 0x400
For file_index, file_name in g_file_names
{
    file_display_name := file_name[1]
    file_fullpath := file_name[2]
    hotkey_info := file_name[3]
    label_info := file_name[4]
    procedure_info := file_name[5]
    
    parent_id := TV_Add(file_display_name)
    hotkey_id := TV_Add(hotkey_info[1], parent_id)
    for key, value in hotkey_info[2]
        tv_add(key, hotkey_id)

    label_id := TV_Add(label_info[1], parent_id)
    for key, value in label_info[2]
        tv_add(key, label_id)

    procedure_id := TV_Add(procedure_info[1], parent_id)
    for key, value in procedure_info[2]
        tv_add(key, procedure_id)

    If (file_index = g_file_names.MaxIndex())
        TV_Modify(parent_id, "Expand Select")
}

If FileExist(g_ini_file)
{
    Loop, Read, %g_ini_file%
    {
        If (A_Index = 1)
            gui_dimensions := A_LoopReadLine
        If (A_Index = 2)
            g_font_size := A_LoopReadLine 
    }
}



Gui, Font, s%g_font_size%
GuiControl, Font, tv_proc_text
Gui, +Resize +AlwaysOnTop
Gui, Show, %gui_dimensions%, Script Explorer
Return

update_npp_tab_list:
    npp_tab_list := get_npp_tab_list(npp_tab_list)
    OutputDebug, % "npp_tab_list: " npp_tab_list.length()
    return

;--------------- Hotkeys ---------------------------------;
#If WinActive("Script Explorer ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe")

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
    WinGetPos, x, y, w, h, Script Explorer ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    write_string := "X"x " Y"y " W"w " H"h "`n"
    write_string .= g_font_size
    FileDelete, %g_ini_file%
    FileAppend, %write_string% `n, %g_ini_file%
    ExitApp
}

GuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y)
{
    If (A_GuiControl = "tv_proc_text")
    {
        If IsRightClick And (A_EventInfo != 0)
            Click   ; select item that was rightclicked on
        Menu, context_menu, Show
    }
}

GuiSize(GuiHwnd, EventInfo, Width, Height)
{
    Static countx := 0
    countx++
    OutputDebug, % A_ThisFunc " - countx: " countx
    If (A_EventInfo = 1)  ; The window has been minimized. No action needed.
        Return
    ; Otherwise, the window has been resized or maximized. Resize the controls to match.
    GuiControl, Move, tv_proc_text, % "w"(Width - 30) "h" (Height - 30)
    Return
}

;---------- Procedures & g-subroutines -------------------;

locate_proc_call()
{
    Gosub update_npp_tab_list   ;*************************************** TESTING ****************************

    selected_id := TV_GetSelection()
    parent_id := TV_GetParent(selected_id)
    If (parent_id = 0) 
        TV_GetText(fname, selected_id)
    Else
        TV_GetText(fname, parent_id) 
    result := get_fullpath(fname)
    info := StrSplit(result, Chr(7))
    parent_fullpath := info[1]
    parent_index := info[2]
    TV_GetText(proc_call, selected_id)
    If parent_id 
        code_line_num := g_file_names[parent_index][3][proc_call]
    Else
        code_line_num := 1

    ; open file and select the line of code 
    if open_file(parent_fullpath)
    {
        WinMenuSelectItem, %g_hwnd_editor%,,Search,Go to...
        Sleep 100
        SendInput %code_line_num%{Enter}
        Sleep 100
        If parent_id
            SendInput +{End}
    }
    else
        OutputDebug, % "Open file didn't work"
}

open_file(p_fullpath)
{
    found := False
    For i_index, tab_info in npp_tab_list 
    {
        ; file is already open so select the correct tab 
        file_name := tab_info[1]
        buffer_id := tab_info[2]
        If InStr(file_name, p_fullpath)
        {
            found := True
            npp_activate_bufferid(buffer_id)
            Break
        }
    }
    If Not Found
    {
        ; file needs to be opened
        WinActivate, %g_hwnd_editor% 
        WinMenuSelectItem, %g_hwnd_editor%,,File,Open 
        Sleep 500
        SendInput %p_fullpath%{Enter}
        Sleep 500
        ; WinMenuSelectItem, %g_hwnd_editor%,,Edit,Set Read-Only
    }
    ; fname := npp_get_current_filename() ; pythonscript version
    fname := get_current_npp_filename()
    result := instr(fname, p_fullpath)
    Return %result%
}

context_menu_handler()
{
    selected_id := TV_GetSelection()
    parent_id := TV_GetParent(selected_id)
    TV_GetText(proc_call, selected_id)
    If (A_ThisMenuItem = "&Insert")     
    {
        Clipboard := proc_call
        OutputDebug, % A_ThisFunc " - " A_ThisMenuItem " not programmed yet."
    }
    Else If (A_ThisMenuItem = "&Copy")
        Clipboard := proc_call
    Else If (A_ThisMenuItem = "&Open")
        locate_proc_call()
    Else If (A_ThisMenuItem = "&Always on top")
    {
        WinGet, ex_style, ExStyle, Script Explorer
        If (ex_style & 0x8)                         ; 0x8 is WS_EX_TOPMOST.
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
    Else If (A_ThisMenuItem = "&Reload")
        Reload
    Else If (A_ThisMenuItem = "&Exit")
        GuiClose()
    Return
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

tv_proc()
{
    OutputDebug, % A_ThisFunc " - " A_GuiControlEvent
    selected_id := TV_GetSelection()
    parent_id := TV_GetParent(selected_id)
    TV_GetText(fname, parent_id) 
    result := get_fullpath(fname)
    info := StrSplit(result, Chr(7))
    parent_fullpath := info[1]
    parent_index := info[2]
    TV_GetText(proc_call, selected_id)
    code_line_num := g_file_names[parent_index][3][proc_call]
    ;
    If (A_GuiControlEvent = "DoubleClick")
        locate_proc_call()
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

get_procedures(p_path, p_procedures)
{
    If !FileExist(p_path)
        Return
    FileRead, in_file_var, %p_path% 
    Loop, Parse, in_file_var, `n, `r 
    {
        found_pos := RegExMatch(A_LoopField, "mO)^\w+\(.*\)", match)
        If found_pos
            p_procedures[match.value] := A_Index
        Else
            Continue        
    }
}

get_includes(p_in_file_var)
{
    Loop, Parse, p_in_file_var, `n, `r 
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
                    SplitPath, g_in_file,,script_dir
                    library_path := script_dir relative_path
                }
                ;
                If !FileExist(library_path)
                {
                    OutputDebug, % "Invalid library_path: " library_path
                    Continue
                }
                Else 
                {
                    procedures := {}
                    get_procedures(library_path, procedures)
                    SplitPath, library_path, fname
                    g_file_names.Push([fname, library_path, procedures])
                }    
            }
        }
    }
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


