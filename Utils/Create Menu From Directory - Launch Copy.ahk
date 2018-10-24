#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%
if (A_Args[1] != "C:\Users\Mark\Documents\Launch")
    Menu, Tray, Icon, ..\resources\32x32\Folders\SHELL32_16784.ico
else
    Menu, Tray, Icon, ..\resources\32x32\Misc\star (2).png

start_time := A_Now

; Leave this in for testing
; A_Args[1] := "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\SDK"
; A_Args[1] := "C:\Program Files (x86)\Microsoft Visual Studio"
; A_Args[1] := "C:\Users\Mark\Documents\GitHub\Windows-universal-samples\SharedContent"
; A_Args[1] := "C:\Users\Mark\Documents\Launch"
; A_Args[1] := ""
; A_Args[2] := ""     ; show_readonly
; A_Args[3] := ""     ; show_hidden
; A_Args[4] := ""     ; show_system
; A_Args[5] := True     ; g_show_icons
; A_Args[5] := ""     ; g_show_icons

; command line parameter handling
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

Global g_show_icons
show_readonly := (A_Args[2] = "") ? True  : A_Args[2]
show_hidden   := (A_Args[3] = "") ? False : A_Args[3]
show_system   := (A_Args[4] = "") ? False : A_Args[4]
g_show_icons  := (A_Args[5] = "") ? False : A_Args[5]

If Not ((show_readonly = False) or (show_readonly = True))
    error_handler("Show Read Only parameter must be True or False or left blank.")
If Not ((show_hidden = False) or (show_hidden = True))
    error_handler("Show Hidden parameter must be True or False or left blank.")
If Not ((show_system = False) or (show_system = True))
    error_handler("Show System parameter must be True or False or left blank.")
If Not ((g_show_icons = False) or (g_show_icons = True))
    error_handler("Show Icons parameter must be True or False or left blank.")

Global g_attrib_filter
g_attrib_filter := ""
If Not show_hidden
    g_attrib_filter .= "H,"
If Not show_readonly
    g_attrib_filter .= "R,"
If Not show_system
    g_attrib_filter .= "S,"
g_attrib_filter := SubStr(g_attrib_filter, 1, -1) ; truncate last comma

OnExit("restore_cursors")
set_system_cursor("IDC_WAIT")

; check if possible to create menus  
max_menus := 34589
Loop, Files, *.*, D R
    total_dirs := A_Index
Loop, Files, *.*, F R
    total_files := A_Index
menu_items_to_create := total_dirs + total_files + 1
If (menu_items_to_create > max_menus)
    error_handler("Too many menus to create`nChoose a smaller directory`n`nMaximum menus: " 1000s_sep(max_menus))

OutputDebug, % "menu_items_to_create: " menu_items_to_create

; Create Root menu with options that appear at the top of each menu & submenu
Global menu_option1 := "Copy folder path"
Global menu_option2 := "Explore this folder"
Global menu_option3 := "Cmd prompt here"
add_menu_options(A_WorkingDir, g_show_icons)

; start recursive build of menus based on directory structure 
; (this the lowest level (0) of the stack) 
create_tree(A_WorkingDir "\*.*", 0)

end_time := A_Now 
OutputDebug, % "Run time: " format_seconds(end_time - start_time)

restore_cursors()
Menu, %A_WorkingDir%, Show
Return

create_tree(p_dir, p_stack_level)
{
    parent_menu := StrReplace(p_dir,"\*.*","")
    parent_menu := (parent_menu = A_WorkingDir) ? A_WorkingDir : A_LoopFileFullPath ; ensures root menu's fullpath (A_WorkingDir) is used as parent_menu name.
    Loop, Files, %p_dir%, D 
    {
        If A_LoopFileAttrib contains %g_attrib_filter%
            Continue
        add_menu_options(A_LoopFileFullPath, g_show_icons)
        Menu, %parent_menu%, Add, %A_LoopFileName%, :%A_LoopFileFullPath%       ; attach submenu to parent menu
        ; Don't bother loading folder icons for directories that haven't been hardcoded here.
        If g_show_icons And (A_WorkingDir = "C:\Users\Mark\Documents\Launch")
        {
            icon_info := add_folder_icon(A_LoopFileFullPath)
            Menu, %parent_menu%, Icon, %A_LoopFileName%, % icon_info[1], % icon_info[2]
        }
        else if g_show_icons
            Menu, %parent_menu%, Icon, %A_LoopFileName%, % A_WinDir "\system32\imageres.dll", 6
        
        ; recursive call stack level increases for each new sub directory and decreases when 
        ; all items for that subdirectory have been processed. 
        create_tree(A_LoopFileFullPath . "\*.*", p_stack_level + 1)
    }

    Loop, Files, %p_dir%, F 
    {
        If A_LoopFileAttrib contains %g_attrib_filter%
            Continue
        Menu, %parent_menu%, Add, %A_LoopFileName%, MENUHANDLER             ; add item to current menu
        If g_show_icons
        {
            hicon := get_file_icon(A_LoopFileFullPath)
            Menu, %parent_menu%, Icon, %A_LoopFileName%, HICON:%hicon% 
        }
    }
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
    ; options at the top of every menu and submenu for each directory
    Menu, %p_menu_name%, Add, %menu_option1%, MENUHANDLER
    Menu, %p_menu_name%, Add, %menu_option2%, MENUHANDLER
    Menu, %p_menu_name%, Add, %menu_option3%, MENUHANDLER
    Menu, %p_menu_name%, Add
    If g_show_icons
    {
        Try 
        {
            Menu, %p_menu_name%, Icon, %menu_option1%, % A_WinDir "\System32\SHELL32.dll",261
            Menu, %p_menu_name%, Icon, %menu_option2%, % A_WinDir "\explorer.exe", 0
            Menu, %p_menu_name%, Icon, %menu_option3%, % A_WinDir "\System32\cmd.exe", 0
        }
        catch
            OutputDebug, % "*** Unknown reason for failed icon load in: " A_ThisFunc
    }
    Return
}

MENUHANDLER:
{
    If (A_ThisMenuItem == menu_option1)
        Clipboard := A_ThisMenu
    Else If (A_ThisMenuItem == menu_option2)
        Run, % A_ThisMenu
    Else If (A_ThisMenuItem == menu_option3)
        Run, %A_ComSpec% %A_ThisMenu%
    Else
    {
        ; Clipboard :=  A_ThisMenu "\" A_ThisMenuItem
        ; If StrLen(A_ThisMenu) > 50
            ; partial_path := "..." StrReplace(A_ThisMenu, A_WorkingDir, "")
        ; Else
            ; partial_path := A_ThisMenu
        ; OutputDebug, % "Run," partial_path "\" A_ThisMenuItem
        Run,  %A_ThisMenu%\%A_ThisMenuItem%
    }
    Return
}

error_handler(p_msg)
{
    restore_cursors()
    MsgBox, 48,, % p_msg
    ExitApp
}

+MButton::
^AppsKey:: Menu, %A_WorkingDir%, Show 

^!+r::restore_cursors()