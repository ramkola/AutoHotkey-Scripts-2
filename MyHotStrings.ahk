;-------------------------------------------------
; Note: {Left}{Right} at the end of hotstrings 
;       is to get rid of autocomplete box 
;-------------------------------------------------
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_ROOT_DIR%
;-----------------------------
; Misc 
;-----------------------------
:*:pws::PowerShell
:*:gitd::C:\Users\Mark\Documents\GitHub{Left}{Right}
:X*:moff::SendMessage, 0x112, 0xF170, 2,, Program Manager   ; turn monitors off
;-----------------------------
; SciTE specific
;-----------------------------
:*:scix::C:\Program Files\AutoHotkey\SciTE\SciTE.exe
:*:scid::C:\Users\Mark\Documents\AutoHotkey\SciTE
:*:sciw::C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\SciTE
;-----------------------------
; Notepad++ specific
;-----------------------------
:R*:n++::Notepad++
:R*:nppx::C:\Program Files (x86)\Notepad++\notepad++.exe
:R*:nppcl::C:\Users\Mark\Google Drive\Misc Backups\Notepad++\backup
:R*:cusic::C:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\      ; customize toolbar plugin icon directory
;-----------------------------
; AutoHotkey directories 
;-----------------------------
:*:ahkd::C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts 
:*:ahky::AutoHotkey
:X*:ahks::Run, C:\Program Files\Everything\Everything.exe  -search "^.*\.ahk$" -regex -nomatchpath -sort "date modified" -sort-descending 
:X*:ahkx::SendInput %A_AHKPath%
:*:resx::C:\Users\Mark\Desktop\Misc\Resources
;------------------------------------------------
; AutoHotkey programming
;------------------------------------------------
:R*:lrx::{Left}{Right}
:R*:fmtd::Format("{:02}", <xxx>)         ; 0 pad fill 
:R*:fmth::Format("0x{:X}", <xxx>)        ; hex
:R*:wfe::Input,ov,,{Escape}
:R:sing::#SingleInstance Force 
:R*:noic::#NoTrayIcon
:*:ucic::Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
:R*:asfl::"ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " in " A_LineFile " | " A_ThisFunc " (" A_ScriptName ")"
:*:asfx::" - " A_ThisFunc " (" A_ScriptName ")"{Left 37}
:*:aslx::" - " A_ThisLabel " (" A_ScriptName ")"{Left 38}
:*:ashx::" - " A_ThisHotkey " (" A_ScriptName ")"{Left 39}
:*:geparams::(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="") ; gui event functions params
:*:omparams::(wParam, lParam, msg, hWnd)    ; OnMessage functions params
:*:msgx::MsgBox, 48,, % "", 10{Left 5}
:*:msghe::MsgBox, 48,, % "Here 1 - ", 10{Left 5}
:*:msgue::MsgBox, 48, Unexpected Error, % A_ThisLabel " - " A_ScriptName `"``r``n<msg>`"{Left}+{Left 5}
:*:imagex::ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 filename`nIf (ErrorLevel = 0)`n`tMouseMove, x, y{Up 2}{End}^+{Left}
:*:odbg::OutputDebug, % 
:*:odhe::OutputDebug, % "Here 1 - " A_ThisLabel " (" A_ScriptName ")"{Left}{Right}
:*:odel::OutputDebug, % "ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " in " A_LineFile " | " A_ThisFunc " (" A_ScriptName ")"
:*:odxy::OutputDebug, % x ", " y " - " A_CoordModeMouse{Left}{Right}
:*:odwh::OutputDebug, % x ", " y ", " w ", " h " - " A_CoordModeMouse{Left}{Right}
:*:odyn::{Home}If <xxxx>`n`tOutputDebug, Yes `n{Home}Else `n`tOutputDebug, No {Home} +{Tab}!{Home}{Up 3}{Right 3}+{End}
:*:odthis::OutputDebug, % "A_ThisHotkey: " A_ThisHotkey " - A_ThisLabel: " A_ThisLabel " - A_ThisFunc: " A_ThisFunc " - A_ScriptName: " A_ScriptName{Left}{Right}
:*:aar::A_Args[x]{Left}+{Left}
:*:parsev::Loop, Parse, <var>, ``n, ``r`n`tOutputDebug, % A_LoopField{Left}{Right}
:*:'n::``n
:*:'r::``r                   
:*:'t::``t
:*:'s::`"``r``n``r``n{Space 4}PASTEYOURTEXTHERE{Space 4}``r``n``r``n{Space}`"{Left 14}^+{Left}
:*:rnx::``r``n
:*:anow::FormatTime, end_time,,yyyy-MM-dd HH:mm
:R*:rescx::`;       \.*?+[{|()^$      ;regex escape characters
:R*:curx::#Include lib\utils.ahk `nOnExit("restore_cursors")`nset_system_cursor("IDC_WAIT")`nrestore_cursors()
:*:ahkpy::WinMenuSelectItem, A,,Plugins,Python Script,Scripts,AHK Modules,<PYTHONSCRIPT MODULE HERE>+{Left 26}
;---------------
; Code snippets
;---------------
:X*:actwin::Run, lib\code_snippets.ahk "xactwin"
:X*:clipx::Run, lib\code_snippets.ahk "xclip"
:X*:clsre::Run, lib\code_snippets.ahk "xclsre"
:X*:clsx::Run, lib\code_snippets.ahk "xcls"
:X*:consx::Run, lib\code_snippets.ahk "xcons"
:X*:forkx::Run, lib\code_snippets.ahk "xfork"
:X*:forx::Run, lib\code_snippets.ahk "xfor"
:X*:inx::Run, lib\code_snippets.ahk "xin"
:X*:lhx::Run, lib\code_snippets.ahk "xlh"
:X*:newsc::Run, lib\code_snippets.ahk "xnewsc"
:X*:outx::Run, lib\code_snippets.ahk "xout"
:X*:pexit::Run, lib\code_snippets.ahk "xpexit"
:X*:procx::Run, lib\code_snippets.ahk "xproc"
:X*:strix::Run, lib\code_snippets.ahk "xstrings"
:X*:tipx::Run, lib\code_snippets.ahk "xttip"
:X*:utilx::Run, lib\code_snippets.ahk "xutils"
;
:X*:brkp::  ; sets a line up in code to be used as a conditional breakpoint for debugging.
{
    ControlGetFocus, which_scintilla, A
    SendInput {End}{Enter}
    RunWait, lib\code_snippets.ahk "xbrkp"
    save_x := A_CaretX
    save_y := A_CaretY
    start_dbgp()  
    sleep 500
    ControlFocus, %which_scintilla%, ahk_class Notepad++
    MouseMove, save_x, save_y
    ; marks line as breakpoint
    SendInput ^{F9}
    ; removes automatic indent
    SendInput {Up}{Home}+{Tab}
    Sleep 50
    SendInput {Up}^{Right}+{Tab}
    ; highlights expression to be changed
    SendInput {Down}{End}{Left}^+{Left} 
    Return
}
