#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

; Leave this in for testing
A_Args[1] := "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7"
A_Args[2] := ""     ; g_show_readonly
A_Args[3] := ""     ; g_show_hidden
A_Args[4] := ""     ; g_show_system
A_Args[5] := ""     ; g_show_icons


; command line parameter handling
Global g_show_readonly 
Global g_show_hidden   
Global g_show_system   
Global g_show_icons    

If (A_Args[1] = "")
{
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput ^c
    ClipWait,1,1
    A_Args[1] := Clipboard  
    Clipboard := saved_clipboard    
}
file_attribs := FileExist(A_Args[1])
If InStr(file_attribs,"D")
    SetWorkingDir, % A_Args[1] 
Else
    error_handler("Directory does not exist: `n" A_Args[1])

g_show_readonly := (A_Args[2] = "") ? True  : A_Args[2]
g_show_hidden   := (A_Args[3] = "") ? False : A_Args[3]
g_show_system   := (A_Args[4] = "") ? False : A_Args[4]
g_show_icons    := (A_Args[5] = "") ? False : A_Args[5]

If Not ((g_show_readonly = False) or (g_show_readonly = True))
    error_handler("Show Read Only parameter must be True or False or left blank.")
If Not ((g_show_hidden = False) or (g_show_hidden = True))
    error_handler("Show Hidden parameter must be True or False or left blank.")
If Not ((g_show_system = False) or (g_show_system = True))
    error_handler("Show System parameter must be True or False or left blank.")
If Not ((g_show_icons = False) or (g_show_icons = True))
    error_handler("Show Icons parameter must be True or False or left blank.")


; check if possible to create menus  
Loop, Files, *.*, D R
    total_dirs := A_Index
; Loop, Files, *.*, F R
    ; total_files := A_Index
menu_items_to_create := total_dirs ;  + total_files + 1
If (menu_items_to_create > 15000)
    error_handler("Too many menus to create.`nChoose a smaller directory.")

; process can take time for deep directory structures
OnExit("restore_cursors")
set_system_cursor("IDC_WAIT")

; environment variables
Global g_com_spec 
Global g_win_dir
Global g_system_root 
EnvGet, g_com_spec, ComSpec
EnvGet, g_win_dir, windir
EnvGet, g_system_root, SystemRoot

; Menu options that appear at the top of each menu & submenu
Global menu_option1 := "Explore this folder"
Global menu_option2 := "Copy folder path"
Global menu_option3 := "Cmd prompt here"
add_menu_options(A_WorkingDir, g_show_icons)

; start recursive build of menus based on directory structure (lowest level (0) of stack) 
create_tree(A_WorkingDir "\*.*", 0)

restore_cursors()
Menu, %A_WorkingDir%, Show
Return

create_tree(p_dir, p_stack_level)
{
    attrib_filter := ""
    If Not g_show_hidden
        attrib_filter .= "H,"
    If Not g_show_readonly
        attrib_filter .= "R,"
    If Not g_show_system
        attrib_filter .= "S,"
    attrib_filter := SubStr(attrib_filter, 1, -1) ; truncate last comma

    parent_menu := StrReplace(p_dir,"\*.*","")
    parent_menu := (parent_menu = A_WorkingDir) ? A_WorkingDir : A_LoopFileFullPath
    Loop, Files, %p_dir%, D 
    {
        If A_LoopFileAttrib contains %attrib_filter%
            Continue
        add_menu_options(A_LoopFileFullPath, g_show_icons)
        Menu, %parent_menu%, Add, %A_LoopFileName%, :%A_LoopFileFullPath%       ; attach submenu to parent menu
        If g_show_icons
        {
            icon_info := add_folder_icon(A_LoopFileFullPath)
            Menu, %parent_menu%, Icon, %A_LoopFileName%, % icon_info[1], % icon_info[2]
        }
        
        ; recursive call stack increases for each new sub directory and decreases when all items for that
        ; subdirectory have been processed. 
        create_tree(A_LoopFileFullPath . "\*.*", p_stack_level + 1)
    }
    
    Loop, Files, %p_dir%, F 
    {
        If A_LoopFileAttrib contains %attrib_filter%
            Continue
        Menu, %parent_menu%, Add, %A_LoopFileName%, MENUHANDLER             ; add item to current menu
        If g_show_icons
        {
            icon_info := add_file_icon(A_LoopFileFullPath)
            Try
                Menu, %parent_menu%, Icon, %A_LoopFileName%, % icon_info[1], % icon_info[2]
            Catch
            {
                OutputDebug, % "pmenu: " parent_menu " file: " A_LoopFileName
                Menu, %parent_menu%, Icon, %A_LoopFileName%, % g_win_dir "\system32\imageres.dll", 182
            }
        }
    }
}

MENUHANDLER:
    If (A_ThisMenuItem == menu_option1)
        Run, % A_ThisMenu
    Else If (A_ThisMenuItem == menu_option2)
        Clipboard := A_ThisMenu
    Else If (A_ThisMenuItem == menu_option3)
        Run, %g_com_spec% %A_ThisMenu%
    Else
    {
        Clipboard :=  A_ThisMenu "\" A_ThisMenuItem
        If StrLen(A_ThisMenu) > 50
            partial_path := "..." StrReplace(A_ThisMenu, A_WorkingDir, "")
        Else
            partial_path := A_ThisMenu
        OutputDebug, % "Run," partial_path "\" A_ThisMenuItem
    }
    Return

add_file_icon(p_filename)
{

If InStr(p_filename, "txt")
    dbgp_breakpoint := True

    icon_info := ["",0]
    ext_pos := instr(p_filename, ".",,-1)
    file_ext := SubStr(p_filename, ext_pos + 1)

    if (file_ext != "lnk")
    {
        icon_file := assoc_query_app(file_ext)
        icon_index := 0
    }
    
    ; get icons from shortcuts
    If (file_ext = "lnk")
    {
        FileGetShortcut, % p_filename, out_target,,,, icon_file, icon_index
        icon_file := StrReplace(icon_file,"%SystemRoot%",g_system_root)
        icon_file := StrReplace(icon_file,"%windir%",g_win_dir)
        icon_file := StrReplace(icon_file,"%ComSpec%",g_com_spec)
        If Not FileExist(icon_file)
        {
            icon_index := 0
            target_ext := SubStr(out_target, -2)
            icon_file := assoc_query_app(target_ext)
            If Not FileExist(icon_file)
                If (target_ext = "bat")
                {
                    icon_file := g_win_dir "\system32\imageres.dll"
                    icon_index := 263
                }
                Else
                    icon_file := out_target
        }
    }
    icon_info[1] := icon_file
    icon_info[2] := icon_index
    Return %icon_info%
}

add_folder_icon(p_folder)
{
    ini_file := p_folder "\desktop.ini"
    If FileExist(ini_file)
        IniRead, icon_info, %ini_file%, .ShellClassInfo, IconResource
    Else
        icon_info := "ERROR"
    If (icon_info == "ERROR")
    {
        icon_info := []
        icon_info[1] := g_win_dir "\System32\SHELL32.dll"
        icon_info[2] := 4
    }
    Else
    {
        icon_info := StrSplit(icon_info, ",")
        icon_info[2]++  ;  there is a 1 offset difference, it was returning the wrong icon
    }
    Return %icon_info%
}

add_menu_options(p_menu_name, g_show_icons)
{
    Menu, %p_menu_name%, Add, %menu_option1%, MENUHANDLER
    Menu, %p_menu_name%, Add, %menu_option2%, MENUHANDLER
    Menu, %p_menu_name%, Add, %menu_option3%, MENUHANDLER
    Menu, %p_menu_name%, Add
    if g_show_icons
    {
        Menu, %p_menu_name%, Icon, %menu_option1%, % g_win_dir "\explorer.exe", 0
        Menu, %p_menu_name%, Icon, %menu_option2%, % g_win_dir "\System32\SHELL32.dll",261
        Menu, %p_menu_name%, Icon, %menu_option3%, % g_win_dir "\System32\cmd.exe", 0
    }
    Return
}

error_handler(p_msg)
{
    MsgBox, 48,, % p_msg
    restore_cursors()
    ExitApp
}

RAlt:: Menu, %A_WorkingDir%, Show 

^x::ExitApp


