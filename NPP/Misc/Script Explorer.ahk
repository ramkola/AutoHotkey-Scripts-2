#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#Include lib\npp.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%
StringCaseSense Off
Menu, Tray, Icon, ..\resources\32x32\Signs\milestone.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

OnMessage(0x100, "on_key_down") ; monitor WM_KEYDOWN
; context_menu
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
Global g_procedures := {}
Global g_hwnd_editor := ""
Global g_in_fname := ""
Global g_font_size := 12
Global g_sorted := False
Global g_ini_file := A_ScriptDir "\" A_ScriptName ".ini"
WinGet, g_hwnd_editor, ID, A
g_hwnd_editor := "ahk_id " g_hwnd_editor
; build procedures array
in_file := get_current_npp_filename() 
SplitPath, in_file, g_in_fname 
FileRead, in_file_var, %in_file% 
Loop, Parse, in_file_var, `n, `r 
{
    If (SubStr(A_LoopField, 1, 8) != "#include")
    {
        g_procedures := {}
        g_file_names.Push([g_in_fname, in_file, g_procedures])
        get_procedures(in_file)
        Break
    }
    If (SubStr(A_LoopField, 1, 8) = "#include")
    {
        include_param := SubStr(A_LoopField, 10)
        file_attribs := FileExist(include_param)
        If InStr(file_attribs, "D")
            include_library_path := include_param
        Else If include_library_path
        {
            library_path := include_library_path "\" include_param
            If !FileExist(library_path)
            {
                OutputDebug, % "Invalid library_path: " library_path
                Continue
            }
            Else 
            {
                g_procedures := {}
                SplitPath, library_path, fname
                g_file_names.Push([fname, library_path, g_procedures])
                get_procedures(library_path)
            }    
        }
    }
}

Gui, Font, s%g_font_size%  
; load treeview with procedure calls
Gui, Add, TreeView, r20 w400 0x400 vtv_proc_text gtv_proc       ; TVS_SINGLEEXPAND = 0x400
For i_index, file_name in g_file_names
{
    parent_id := TV_Add(file_name[1])
    For key, value in file_name[3]
        TV_Add(key,parent_id, First) 
    If (i_index = g_file_names.MaxIndex())
        TV_Modify(parent_id, "Expand Select")
}

If FileExist(g_ini_file)
{
    Loop, Read, %g_ini_file%
    {
        if (A_Index = 1)
            gui_dimensions := A_LoopReadLine
        if (A_Index = 2)
            g_font_size := A_LoopReadLine 
    }
}
Gui, Font, s%g_font_size%
GuiControl, Font, tv_proc_text
Gui, +Resize +AlwaysOnTop
Gui, Show, %gui_dimensions%, Script Explorer
Return

;--------------- Hotkeys ---------------------------------;

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
GuiClose:
    WinGetPos, x, y, w, h, Script Explorer ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
    write_string = X%x% Y%y% W%w% H%h% `n
    write_string .= g_font_size
    FileDelete, %g_ini_file%
    FileAppend, %write_string% `n, %g_ini_file%
    ExitApp

GuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y)
{
    If (A_GuiControl = "tv_proc_text")
        Menu, context_menu, Show
}

GuiSize(GuiHwnd, EventInfo, Width, Height)
{
    If (A_EventInfo = 1)  ; The window has been minimized. No action needed.
        Return
    ; Otherwise, the window has been resized or maximized. Resize the controls to match.
    GuiControl, Move, tv_proc_text, % "w"(Width - 30) "h" (Height - 30)
    Return
}

;---------- Procedures & g-subroutines -------------------;

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
        Gosub GuiClose
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

locate_proc_call()
{
    selected_id := TV_GetSelection()
    parent_id := TV_GetParent(selected_id)
    If Not parent_id
        Return  ; user doubleclick or pressed enter on a parent node
    TV_GetText(fname, parent_id) 
    result := get_fullpath(fname)
    info := StrSplit(result, Chr(7))
    parent_fullpath := info[1]
    parent_index := info[2]
    TV_GetText(proc_call, selected_id)
    code_line_num := g_file_names[parent_index][3][proc_call]

    WinActivate, %g_hwnd_editor% 
    Sleep 10
    WinGetTitle, win_title, A
    If Not InStr(win_title, parent_fullpath)
    {
        ; opening an external file (ie #Include)
        WinMenuSelectItem, %g_hwnd_editor%,,File,Open 
        Sleep 500
        SendInput %parent_fullpath%{Enter}
        Sleep 500
        WinMenuSelectItem, %g_hwnd_editor%,,Edit,Set Read-Only
    }
    WinMenuSelectItem, %g_hwnd_editor%,,Search,Go to...
    Sleep 10
    SendInput %code_line_num%{Enter}
    Sleep 10
    SendInput +{End}
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

get_procedures(p_path)
{
    If !FileExist(p_path)
        Return
    FileRead, in_file_var, %p_path% 
    Loop, Parse, in_file_var, `n, `r 
    {
        found_pos := RegExMatch(A_LoopField, "mO)^\w+\(.*\)", match)
        If found_pos
            g_procedures[match.value] := A_Index
        Else
            Continue        
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

