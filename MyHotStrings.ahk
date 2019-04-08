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
:R*:pws::PowerShell
:R*:gitd::C:\Users\Mark\Documents\GitHub
:X*:moff::SendMessage, 0x112, 0xF170, 2,, Program Manager   ; turn monitors off
;-----------------------------
; SciTE specific
;-----------------------------
:R*:scix::C:\Program Files\AutoHotkey\SciTE\SciTE.exe
:R*:scid::C:\Users\Mark\Documents\AutoHotkey\SciTE
:R*:sciw::C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\SciTE
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
:R*:ahkd::C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts 
:X*:ahks::Run, C:\Program Files\Everything\Everything.exe  -search "^.*\.ahk$" -regex -nomatchpath -sort "date modified" -sort-descending 
:X*:ahkx::SendInput %A_AHKPath%
:R*:ahky::AutoHotkey
:R*:resx::C:\Users\Mark\Desktop\Misc\Resources
;-----------------------------
; PythonScript directories 
;-----------------------------
:R*:pssx::C:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\PythonScript\scripts\
:R*:psox::C:\Users\Mark\Desktop\Misc\PythonScript
;-----------------------------
; PythonScript programming
;-----------------------------
:*:mainx::if __name__ == "__main__":{Enter}{Tab}
:*:docx::print(.__doc__){Left 9}
:*:psx::PythonScript
:*:edx::editor.(){Left 2}
:*:cox::console.(){Left 2} 
:*:cowx::console.write('' p '\n'){Left 9}
:*:nox::notepad.(){Left 2}
:*:clearx::console.clear(){Enter}
:*:cwdx::import os;os.getcwd(){Enter}
:*:ccb::notepad.clearCallbacks(){Enter}
:*:cb32::import win32clipboard;win32clipboard.OpenClipboard();win32clipboard.CloseClipboard(){Enter}
;-----------------------------
; AutoHotkey programming
;-----------------------------
:R*:fmt::Format("{:02}", <xxx>)         ; 0 pad fill 
:R*:wfe::Input,ov,,{Escape}
:*:lenght::length
:R:sing::#SingleInstance Force
:R*:noic::#NoTrayIcon
:R*:ucic::Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
:*:msgb::MsgBox, 48,, % "", 10{Left 5} 
:*:msgue::MsgBox, 48, Unexpected Error, % A_ThisFunc " - " A_ScriptName`"``r``n<msg>`"{Left}+{Left 5}
:*:imagex::ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 filename`nIf (ErrorLevel = 0)`n`tMouseMove, x, y{Up 2}{End}^+{Left}
:R*:odbg::OutputDebug, % 
:*:odhe::OutputDebug, % "Here 1 - " A_ScriptName{Space}
:*:odel::OutputDebug, % "ErrorLevel: " ErrorLevel " - countx: " countx{Space}
:R*:odxy::OutputDebug, % "x, y: " x ", " y
:R*:odwh::OutputDebug, % "x, y, w, h: " x ", " y ", " w ", " h
:*:odyn::{Home}If <xxxx>`n`tOutputDebug, Yes `n{Home}Else `n`tOutputDebug, No {Home} +{Tab}!{Home}{Up 3}{Right 3}+{End}
:*:odth::OutputDebug, % "A_ThisHotkey: " A_ThisHotkey " - A_ThisLabel: " A_ThisLabel " - A_ThisFunc: " A_ThisFunc " - A_ScriptName: " A_ScriptName{Space}
:*:aar::A_Args[x]{Left}+{Left}
:R*:parsev::Loop, Parse, <var>, ``n, ``r`n`tOutputDebug, % A_LoopField
:R*:'n::``n
:R*:'r::``r                   
:R*:'t::``t
:R*:rnx::``r``n
:R*:anow::FormatTime, end_time,,yyyy-MM-dd HH:mm
:R*:rescx::`;       \.*?+[{|()^$      ;regex escape characters
:R*:curx::OnExit("restore_cursors")`nset_system_cursor("IDC_WAIT")
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
