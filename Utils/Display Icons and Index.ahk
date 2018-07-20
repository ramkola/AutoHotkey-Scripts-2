#SingleInstance Force

A_Args[1] := "c:\windows\system32\imageres.dll"

EnvGet, win_dir, windir
Menu, Tray, Icon, % win_dir "\System32\SHELL32.dll",324
If (A_Args[1] == "")
    icon_file := win_dir "\System32\SHELL32.dll"
Else
{
    If FileExist(A_Args[1])
        icon_file := A_Args[1]
    Else
    {
        MsgBox, 48,, % "File does not exist:`n`n" A_Args[1], 10
        ExitApp
    }
}
Menu, Main, Add,, MENUHANDLER
icon_index := 0     ; icons are numbered from zero not 1
Loop         
{
    Menu, Main, Add, %icon_index%, MENUHANDLER
    Try
        Menu, Main, Icon, %icon_index%, %icon_file%, %icon_index%, 32 
    Catch
    {
        ; handle last icon that shows no new icons after this.
        Menu, Main, Delete, %icon_index%
        Menu, Main, Add, No More Icons, MENUHANDLER
        Break
    }
    
    If Mod(icon_index, 20) = 0
        Menu, Main, Add, %icon_index%, MENUHANDLER, Break 

    icon_index++
}

MouseMove 100,100
Menu, Main, Show
Return

^RAlt:: 
    MouseMove 100,100
    Menu, Main, Show
    Return

MENUHANDLER:
    Clipboard := icon_file "," A_ThisMenuItem
    OutputDebug, % icon_file "," A_ThisMenuItem
    Return

