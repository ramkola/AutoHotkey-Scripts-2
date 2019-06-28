#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\ping.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

Global tray_icon_only := True
Menu, Tray, Icon, ..\Resources\32x32\Knobs\Knob Orange.ico
Menu, Tray, Add,
Menu, Tray, Add,
If tray_icon_only
    Menu, Tray, Add, Icon Only, tray_icon
Else
    Menu, Tray, Add, Window+Icon, tray_icon

Gui, Font, s24
Gui, Add, Text, vtxt_ping_status r7 w1000 r7, Testing Internet Connection
Gui, -AlwaysOnTop -ToolWindow -Caption

SetTimer, ping_connection, 5000
tray_icon()
ping_connection()

Return

tray_icon() 
{
    tray_icon_only := !tray_icon_only
    If tray_icon_only
    {
        Menu, Tray, Rename, Window+Icon, Icon Only
        Gui, Show
    }
    Else
    {
        Menu, Tray, Rename, Icon Only, Window+Icon
        Gui, Hide
    }
    Return
}

ping_connection()
{
    Static start_time=0
    Static end_time=0
    Try 
    {
        connection := Ping("8.8.8.8") 
        If (connection = 0) or (connection > 5000)     ; more than 5 seconds is not worth connecting
            Throw, % "Connection 0 ms error."
    }
    Catch exception_details
    {
        write_string := "*** NO INTERNET CONNECTION *** - " A_ScriptName "`r`n" 
        For key, value in exception_details
            write_string .= key ": " value "`r`n"
        If (end_time = 0)
            FormatTime, end_time,,yyyy-MM-dd HH:mm
        write_string .= "`r`n`t`t`t`t" end_time
        GuiControl,, txt_ping_status, %write_string%
        Gui, Color, Red
        Menu, Tray, Icon, ..\Resources\32x32\Knobs\Knob Orange.ico
        Return
    }    
    If (start_time = 0)
        FormatTime, start_time,,yyyy-MM-dd HH:mm
    GuiControl,, txt_ping_status, Connected at    >>>    %start_time%
    Gui, Color, Green
    Menu, Tray, Icon, ..\Resources\32x32\Knobs\Knob Green.ico
    Return
}

GuiEscape:
GuiClose:
    ExitApp
    
