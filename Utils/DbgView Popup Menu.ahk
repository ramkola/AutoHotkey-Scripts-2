#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
#NoTrayIcon

execute_menuitem := A_Args[1]

OnExit("exit_check")
SetTimer, exit_check, 1000
Global auto_scroll, always_on_top, in_file
Global dbgview_wintitle := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
#If WinActive(dbgview_wintitle)

Menu, dbgview, Add, Always On Top, MENUHANDLER
Menu, dbgview, Add, Auto Scroll, MENUHANDLER
Menu, dbgview, Add
Menu, dbgview, Add, Check Options, MENUHANDLER
Menu, dbgview, Add, Connect Local, MENUHANDLER
Menu, dbgview, Add
Menu, dbgview, Add, Clear Display, MENUHANDLER
Menu, dbgview, Add, Copy, MENUHANDLER
Menu, dbgview, Add, Go to N++ Line#, MENUHANDLER

in_file := create_script_outfile_name(A_WorkingDir, A_ScriptName) 
FileRead, in_file_var, %in_file% 
Loop, Parse, in_file_var, `n, `r 
{
    If InStr(A_LoopField, "auto_scroll")
        auto_scroll := RegExReplace(A_LoopField,"i)^auto_scroll:([01])$","$1")
    If InStr(A_LoopField, "always_on_top")
        always_on_top := RegExReplace(A_LoopField,"i)^always_on_top:([01])$","$1")
}

If auto_scroll
    menu_checkmark_toggle(auto_scroll, "Auto Scroll", dbgview_wintitle)
If always_on_top
    menu_checkmark_toggle(always_on_top, "Always On Top", dbgview_wintitle)

If execute_menuitem
    Goto MENUHANDLER

Return

RButton::
AppsKey:: 
    Menu, dbgview, Show
    Return

MENUHANDLER:
    menu_item := (A_ThisMenuItem == "") ? execute_menuitem : A_ThisMenuItem
    If (menu_item = "Auto Scroll")
    {
        WinMenuSelectItem, %dbgview_wintitle%,,Options,Auto Scroll
        auto_scroll := !auto_scroll
        menu_checkmark_toggle(auto_scroll, "Auto Scroll", dbgview_wintitle)
        save_settings(auto_scroll, always_on_top, in_file)
    }
    Else If (menu_item = "Always On Top")
    {
        WinMenuSelectItem, %dbgview_wintitle%,,Options,Always On Top
        always_on_top := !always_on_top
        menu_checkmark_toggle(always_on_top, "Always On Top", dbgview_wintitle)
        save_settings(auto_scroll, always_on_top, in_file)
    }
    Else If (menu_item = "Connect Local")
        WinMenuSelectItem, %dbgview_wintitle%,,Computer,Connect Local
    Else If (menu_item = "Clear Display")
        WinMenuSelectItem, %dbgview_wintitle%,,Edit,Clear Display
    Else If (menu_item = "Copy")
    {
        WinMenuSelectItem, %dbgview_wintitle%,,Edit,Copy
        ttip("Copied to Clipboard: `r`n" Clipboard, 2000) 
    }
    Else If (menu_item = "Go to N++ Line#")
        Run, MyScripts\NPP\Misc\Goto line from DbgView debug msg.ahk
    Else If (menu_item = "Check Options")
        SendInput !o    ; opens menu to view auto_scroll and always_on_top settings
    Else    
        OutputDebug, % "Unexpected menu item: " A_ThisMenuItem " / " execute_menuitem " - " A_ScriptName "(" A_ThisLabel ")"
    Return
    
menu_checkmark_toggle(p_checkmark, p_menu_item, p_wintitle)
{
    image_dir = C:\Users\Mark\Desktop\Misc\resources\Images\DbgView
    If p_checkmark
        Menu, dbgview, Check, %p_menu_item%
    Else
        Menu, dbgview, UnCheck, %p_menu_item%

    ; ; verify popmenu is in sync with native dbgview menu/options
    ; check_type := p_checkmark ? "Checked" : "Unchecked"
    ; image_name = %image_dir%\Pango 80 - %p_menu_item% - %check_type%.png
    ; WinMenuSelectItem, %p_wintitle%,,Options
    ; Sleep 1000
    ; ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 %image_name%
    ; If (ErrorLevel > 0)
        ; OutputDebug, % "ErrorLevel: " ErrorLevel
    ; SendInput {Escape}     ; close options menu
    Return
}

exit_check()
{
    If WinExist(dbgview_wintitle)
        Return
    Else
    {
        OnExit("exit_check", 0)
        SetTimer, exit_check, Delete
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
    Return
}
