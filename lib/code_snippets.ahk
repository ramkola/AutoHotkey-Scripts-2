;
; See MyHotStrings.ahk for where the hotstring is defined.
; Advantage to doing it this way is that autocompletion doesn't
; interfere and doesn't need to be toggled. It is also quicker than
; Send commands because it does a copy/paste instead.
;
; Example in MyHotStrings:
;   :X:actwin::Run, lib\code_snippets.ahk "xactwin"
;   typing "actwin" will execute the snippet "xactwin"
;
p_hotstring := A_Args[1]
saved_clipboard := ClipboardAll
Clipboard := ""
%p_hotstring%()     ; execute the subroutine passed as a parameter.
ClipWait,1,1
SendInput, ^v
sleep 10
Clipboard := saved_clipboard 
ExitApp

;----------------
; Code Snippets  
;----------------
xttip()
{
    ClipBoard = MouseGetPos, x, y
    Clipboard = %Clipboard%`nToolTip, Hit Escape to exit``n``nErrorLevel: `%ErrorLevel`%, x+10, y+10
    Clipboard = %Clipboard%`nInput, out_var,,{Escape}
    Clipboard = %Clipboard%`nToolTip
}

xcls()
{
    Clipboard = WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe  
    Clipboard = %Clipboard%`nWinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Clipboard = %Clipboard%`nOutputDebug, DBGVIEWCLEAR
    Return
}

xclsre()
{
    Clipboard := chr(59) " SetTitleMatchMode RegEx"
    Clipboard = %Clipboard%`nWinActivate, .*Notepad\+\+.* ahk_class Notepad\+\+ ahk_exe notepad\+\+\.exe
    Clipboard = %Clipboard%`nWinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Clipboard = %Clipboard%`nOutputDebug, DBGVIEWCLEAR
    Return
}

xutils()
{     
    Clipboard .= "#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts`n"
    Clipboard .= "#Include lib\utils.ahk`n"
    Clipboard .= "`; g_TRAY_<xxx>_ON_LEFTCLICK := True      `; set only 1 to true to enable, see lib\utils.ahk`n"
    Return
}

xconst()
{     
    Clipboard .= "#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts`n"
    Clipboard .= "#Include lib\constants.ahk`n"
    Clipboard .= "SetWorkingDir %AHK_ROOT_DIR%`n"
    Return
}

xstrings()
{
    Clipboard .= "#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts`n"
    Clipboard .= "#Include lib\strings.ahk"
    Return
}

xahkw()
{
    Clipboard .= "#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts`n"
    Clipboard .= "#Include lib\ahk_word_lists.ahk"
    Return
}

xactwin()
{
    Clipboard = #Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
    Clipboard = %Clipboard%`n#Include lib\utils.ahk`n
    Clipboard = %Clipboard%`nWinGetTitle, i_title, A
    Clipboard = %Clipboard%`nWinGetClass, i_class, A
    Clipboard = %Clipboard%`nWinGet, i_hwnd, ID, A
    Clipboard = %Clipboard%`nWinGet, i_procname, ProcessName, A
    Clipboard = %Clipboard%`ni_class := "ahk_class " . i_class
    Clipboard = %Clipboard%`ni_hwnd := "ahk_id " . i_hwnd
    Clipboard = %Clipboard%`ni_procname := "ahk_exe " . i_procname
    Clipboard = %Clipboard%`nactive_win := i_title A_Space i_class A_Space i_procname
    Clipboard = %Clipboard%`nWinActivate, `%active_win`%
    Clipboard = %Clipboard%`nControlGetFocus, got_focus, A
    Clipboard = %Clipboard%`noutput_debug(active_win "``n" got_focus)
    Clipboard = %Clipboard%`nWinGet, control_list, ControlList, A
    Clipboard = %Clipboard%`nsort control_list
    Clipboard = %Clipboard%`nLoop, parse, control_list, "``r``n`"
    Clipboard = %Clipboard%`n{
    Clipboard = %Clipboard%`n    ControlGet, is_visible, Visible,, `%A_LoopField`%, A
    Clipboard = %Clipboard%`n    if is_visible
    Clipboard = %Clipboard%`n        OutputDebug `% A_LoopField
    Clipboard = %Clipboard%`n}
    Return                  
}

xclip()
{
    Clipboard .= "saved_clipboard := ClipboardAll`n" 
    Clipboard .= "Clipboard := """"`n"
    Clipboard .= "Clipboard .=`n"
    Clipboard .= "Clipboard := saved_clipboard"
    Return
}

xconsole()
{
    Clipboard .= "#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts`n"
    Clipboard .= "#Include lib\utils.ahk`n"
    Clipboard .= "#SingleInstance Force`n"
    Clipboard .= "#Persistent`n`n`n"
    Clipboard .= "Wait_for_Escape(" . """msg""" . ")`n"
    Clipboard .= "ExitApp`n`n`n" 
    Clipboard .= "^p::Pause`n" 
    Clipboard .= "^x::ExitApp`n" 
    Return
}

xnewsc()
{
    Clipboard .= "#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts`n"
    Clipboard .= "#Include lib\processes.ahk`n"
    Clipboard .= "#Include lib\strings.ahk`n"
    Clipboard .= "#Include lib\constants.ahk`n"
    Clipboard .= "#Include lib\utils.ahk`n"
    Clipboard .= "#NoEnv`n"
    Clipboard .= "; #NoTrayIcon`n"
    Clipboard .= "#SingleInstance Force`n"
    Clipboard .= "SendMode Input`n"
    Clipboard .= "SetWorkingDir %AHK_ROOT_DIR%`n"
    Clipboard .= "StringCaseSense Off`n"
    Clipboard .= "Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png`n"
    Clipboard .= "`; g_TRAY_<xxx>_ON_LEFTCLICK := True      `; set only 1 to true to enable, see lib\utils.ahk`n"
    Clipboard .= "`nWinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe`n"
    Clipboard .= "OutputDebug, DBGVIEWCLEAR`n"
    Clipboard .= "WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe`n"
    Clipboard .= "`n`n`nExitApp`n"
    Clipboard .= "`n`n`n^p::Pause`n"
    Clipboard .= "^x::ExitApp`n" 
    Return
}

xpexit()
{
    Clipboard .= "ExitApp`n`n" 
    Clipboard .= "^p::Pause`n" 
    Clipboard .= "^+x::ExitApp`n" 
    Return
}

xfor()
{
    Clipboard .= "for i, j in x`n"
    Clipboard .= "{`n"
    Clipboard = %Clipboard%    OutputDebug, `% Format("{:02}) ", i) j `n
    Clipboard .= "}`n"
    Return
}

xfork()
{
    Clipboard .= "for key, value in <kv_array>`n"
    Clipboard .= "{`n"
    Clipboard = %Clipboard%    OutputDebug, `% key ": " value`n
    Clipboard .= "}`n"
    Return
}

xbrkp()
{
    Clipboard .= "save_a_index := A_Index`n"
    Clipboard .= "If (save_a_index = xxx)`n"
    Clipboard .= "    dbgp_breakpoint := True"
    Return
}

xout()
{
    Clipboard = %Clipboard% `nout_file := create_script_outfile_name(A_WorkingDir, A_ScriptName)
    Clipboard = %Clipboard% `nFileDelete, `%out_file`%
    Clipboard = %Clipboard% `nFileAppend, `%write_string`%, `%out_file`%
    Clipboard = %Clipboard% `nSendInput !fo
    Clipboard = %Clipboard% `nSleep 300
    Clipboard = %Clipboard% `nSendInput `%out_file`%{Enter}
}

xin()
{
    Clipboard = %Clipboard% `n#Include lib\npp.ahk
    Clipboard = %Clipboard% `nin_file := npp_get_current_filename()
    Clipboard = %Clipboard% `nSplitPath, in_file, fname
    Clipboard = %Clipboard% `nFileRead, in_file_var, `%in_file`%
    Clipboard = %Clipboard% `nLoop, Parse, in_file_var, ``n, ``r
    Clipboard = %Clipboard% `n{`n`n`n}
}
