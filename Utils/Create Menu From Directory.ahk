#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

; A_Args[1] := "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\CommonExtensions"
; A_Args[1] := "C:\Users\Mark\Documents\Launch"

If (A_Args[1] = "")
{
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput ^c
    Clipwait,,1
    A_Args[1] := Clipboard  ; A_WorkingDir
    Clipboard := saved_clipboard    
}
If (A_Args[2] = "")
    A_Args[2] := True ;False      ; p_show_hidden
If (A_Args[3] = "")
    A_Args[3] := True       ; p_show_readonly
If (A_Args[4] = "")
    A_Args[4] := True ;False      ; p_show_system
p_show_hidden := A_Args[2]
p_show_readonly := A_Args[3]
p_show_system := A_Args[4]

file_attribs := FileExist(A_Args[1])
If InStr(file_attribs,"D")
    SetWorkingDir, % A_Args[1] 
Else
{
    MsgBox, 48,, % "Directory does not exist: `n" A_Args[1], 10
    ExitApp
}

OnExit("restore_cursors")
set_system_cursor("IDC_WAIT")
Loop, Files, *.*, D R
    total_dirs := A_Index
Loop, Files, *.*, F R
    total_files := A_Index
menu_items_to_create := total_dirs + total_files + 1
If (menu_items_to_create > 15000)
{
    restore_cursors()
    MsgBox, 48,, % "Too many menus to create.`nChoose a smaller directory."
    ExitApp
}

Global menu_option1 := "- Explore this folder"
Global menu_option2 := "- Copy folder path"
Global menu_option3 := "- Cmd prompt here"
Menu, %A_WorkingDir%, Add, %menu_option1%, MENUHANDLER
Menu, %A_WorkingDir%, Add, %menu_option2%, MENUHANDLER
Menu, %A_WorkingDir%, Add, %menu_option3%, MENUHANDLER
Menu, %A_WorkingDir%, Add
create_tree(A_WorkingDir "\*.*", 0, p_show_hidden, p_show_readonly, p_show_system)

restore_cursors()
Menu, %A_WorkingDir%, Show
Return

create_tree(p_dir, p_stack_level, p_show_hidden, p_show_readonly, p_show_system)
{
    attrib_filter := ""
    If Not p_show_hidden
        attrib_filter .= "H,"
    If Not p_show_readonly
        attrib_filter .= "R,"
    If Not p_show_system
        attrib_filter .= "S,"
    attrib_filter := SubStr(attrib_filter, 1, -1) ; truncate last comma

    parent_menu := StrReplace(p_dir,"\*.*","")
    parent_menu := (parent_menu = A_WorkingDir) ? A_WorkingDir : A_LoopFileFullPath
    Loop, Files, %p_dir%, D 
    {
        If A_LoopFileAttrib contains %attrib_filter%
            Continue
        Menu, %A_LoopFileFullPath%, Add, %menu_option1%, MENUHANDLER
        Menu, %A_LoopFileFullPath%, Add, %menu_option2%, MENUHANDLER
        Menu, %A_LoopFileFullPath%, Add, %menu_option3%, MENUHANDLER
        Menu, %A_LoopFileFullPath%, Add
        Menu, %parent_menu%, Add, %A_LoopFileName%, :%A_LoopFileFullPath%       ; attach submenu to parent menu
        create_tree(A_LoopFileFullPath . "\*.*", p_stack_level + 1, p_show_hidden, p_show_readonly, p_show_system)    ; recursive call
    }
    
    Loop, Files, %p_dir%, F 
    {
        If A_LoopFileAttrib contains %attrib_filter%
            Continue
        Menu, %parent_menu%, Add, %A_LoopFileName%, MENUHANDLER             ; add item to current menu
        ; Menu, %parent_menu%, Icon, %A_LoopFileFullPath%, 1
    }
}

MENUHANDLER:
    ; OutputDebug, % substr(A_ThisMenu,50) "`n" A_ThisMenuItem
    If (A_ThisMenuItem == menu_option1)
        Run, % A_ThisMenu
    Else If (A_ThisMenuItem == menu_option2)
        Clipboard := A_ThisMenu
    Else If (A_ThisMenuItem == menu_option3)
    {
        EnvGet, com_spec, ComSpec
        Run, %com_spec% %A_ThisMenu%
    }
    Else
    {
        Clipboard :=  A_ThisMenu "\" A_ThisMenuItem
        if StrLen(A_ThisMenu) > 50
            partial_path := "..." StrReplace(A_ThisMenu, A_WorkingDir, "")
        else
            partial_path := A_ThisMenu
        OutputDebug, % "Run," partial_path "\" A_ThisMenuItem
    }
    Return


RAlt:: Menu, %A_WorkingDir%, Show 

^x::ExitApp