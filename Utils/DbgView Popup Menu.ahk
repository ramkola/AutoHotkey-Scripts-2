#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\npp.ahk 
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
#NoTrayIcon
; Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
; g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

OnExit("exit_check")
SetTimer, exit_check, 1000

Global auto_scroll, always_on_top, in_file
Global dbgview_wintitle := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
#If WinActive(dbgview_wintitle)

Menu, dbgview, Add, Auto Scroll, MENUHANDLER
Menu, dbgview, Add, Always On Top, MENUHANDLER
Menu, dbgview, Add, Clear Display, MENUHANDLER
Menu, dbgview, Add, Copy, MENUHANDLER

in_file := create_script_outfile_name(A_WorkingDir, A_ScriptName) 
FileRead, in_file_var, %in_file% 
Loop, Parse, in_file_var, `n, `r 
{
    If InStr(A_LoopField, "auto_scroll")
        auto_scroll := RegExReplace(A_LoopField,"i)^auto_scroll:([0|1])$","$1")
    If InStr(A_LoopField, "always_on_top")
        always_on_top := RegExReplace(A_LoopField,"i)^always_on_top:([0|1])$","$1")
}

If auto_scroll
    menu_checkmark_toggle(auto_scroll, "Auto Scroll")
If always_on_top
    menu_checkmark_toggle(always_on_top, "Always On Top")

Return


RButton::
AppsKey:: 
    Menu, dbgview, Show
    Return

MENUHANDLER:
    If (A_ThisMenuItem = "Auto Scroll")
    {
        WinMenuSelectItem, %dbgview_wintitle%,,Options,Auto Scroll
        auto_scroll := !auto_scroll
        menu_checkmark_toggle(auto_scroll, "Auto Scroll")
        Sleep 10
        SendInput !o
    }
    Else If (A_ThisMenuItem = "Always On Top")
    {
        WinMenuSelectItem, %dbgview_wintitle%,,Options,Always On Top
        always_on_top := !always_on_top
        menu_checkmark_toggle(always_on_top, "Always On Top")
        Sleep 10
        SendInput !o
    }
    Else If (A_ThisMenuItem = "Clear Display")
        WinMenuSelectItem, %dbgview_wintitle%,,Edit,Clear Display
    Else If (A_ThisMenuItem = "Copy")
        WinMenuSelectItem, %dbgview_wintitle%,,Edit,Copy
    Else    
        OutputDebug, % "Unexpected menu item: " A_ThisMenuItem
    Return

menu_checkmark_toggle(p_checkmark, p_menu_item)
{
    If p_checkmark
        Menu, dbgview, Check, %p_menu_item%
    Else
        Menu, dbgview, UnCheck, %p_menu_item%
    Return
}

exit_check()
{
    If WinExist(dbgview_wintitle)
        Return
    Else
    {
        save_settings(auto_scroll, always_on_top, in_file)
        ExitApp
    }
}

save_settings(p_auto_scroll, p_always_on_top, p_out_file)
{
    write_string := "auto_scroll:" p_auto_scroll "`r`n"
    write_string .= "always_on_top:" p_always_on_top "`r`n"
    FileDelete, %p_out_file% 
    FileAppend, %write_string%, %p_out_file% 
    ; Run Notepad.exe "%p_out_file%"
   Return
}
