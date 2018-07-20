#SingleInstance Force
#NoTrayIcon

file_array := []
file_list := ""
SetWorkingDir C:\Users\Mark\Documents\Launch
Loop, Files, *.*, R
{
    If A_LoopFileAttrib contains H  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). 
        Continue  
    
    file_list .= A_LoopFileDir "|" A_LoopFileName "|" A_LoopFileExt "|" A_LoopFileLongPath "`n"
}
Sort, file_list
Loop, Parse, file_list, "`n"
{
    field := StrSplit(A_LoopField, "|")
    field[2] := RegExReplace(field[2], "(^.*)(\.\w+$)", "$1")  ; remove file extension
    file_array.Push([field[1], field[2], field[3], field[4]])
}  

Menu, MainMenu, Add, Explore Launch, MenuHandler
Menu, MainMenu, Add
; create main menu and submenus 
For i, field in file_array
{
    menu_label := field[1]
    item_label := field[2]
    if (field[3] = "lnk")
    {
        filegetshortcut, % field[4], out_target,,,, out_icon, out_icon_num
        if (out_icon == "")
            out_icon := out_target
        if (out_icon_num == "")
            out_icon_num := 1
    }
    ;
    If (menu_label == "") 
    {
        ; create main menu and/or add item to main menu
        Menu, MainMenu, Add, %item_label%, MenuHandler
        Try 
            Menu, MainMenu, Icon, %item_label%, %out_icon%, %out_icon_num%
    }
    Else
    {
        ; create submenu and/or add item to submenu
        Menu, %menu_label%, Add, %item_label%, MenuHandler   
        Try 
            Menu, %menu_label%, Icon, %item_label%, %out_icon%, %out_icon_num%
        ; add submenu to main menu (ignores submenu if it already exists)
        Menu, MainMenu, Add, %menu_label%, :%menu_label%    
    }
}

Return

MenuHandler:
    if (A_ThisMenuItem == "Explore Launch")
        Run, %A_WorkingDir%
    else
        for i, field in file_array
        {
            if (field[2] == A_ThisMenuItem)
            {
                Run, % field[4]
                break
            }
        }
    Return

MButton:: Menu, MainMenu, Show 
