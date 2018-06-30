#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%

; These are here for documentation purposes
; ~^Space::^Space      ; Function autocomplete
; ~^!Space::^!Space    ; Path autocomplete
; ~^Enter::^Enter      ; Word autocomplete

;-----------------------------
; Misc 
;-----------------------------
:R*:pws::PowerShell
:R*:gith::C:\Users\Mark\Documents\GitHub
;-----------------------------
; Notepad++ specific
;-----------------------------
:R C:npp::Notepad++
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
;-----------------------------
; AutoHotkey programming
;-----------------------------
:R*:fmt::Format("{:02}", <xxx>)         ; 0 pad fill 
:*:wfe::wait_for_escape()`nexitapp 
:R*:shit::Shift
:R:sing::#SingleInstance Force
:R*:noic::#NoTrayIcon
:R*:ucic::Menu, Tray, Icon, resources\32x32\icons8-under-construction-32.png
:R*:msgb::MsgBox, 48,, % "", 10 
:R*:outp::OutputDebug, % 
:*:args::A_Args[x]{Left}+{Left}
:R*:'n::``n
:R*:'r::``r                   
:R*:'t::``t
:*:hkr::hotkey_rec[""]{Left 2}
:*:pcr::proc_call_rec[""]{Left 2}
;----------------
; Code snippets
;---------------
:X*:actwin::Run, lib\code_snippets.ahk "xactwin"
:X*:utilx::Run, lib\code_snippets.ahk "xutils"
:X*:clipx::Run, lib\code_snippets.ahk "xclip"
:X*:consx::Run, lib\code_snippets.ahk "xconsole"
:X*:newsc::Run, lib\code_snippets.ahk "xnewsc"
:X*:pexit::Run, lib\code_snippets.ahk "xpexit"
:X*:clsx::Run, lib\code_snippets.ahk "xcls"
:X*:forx::Run, lib\code_snippets.ahk "xforx"
:X*:brkp::  ; sets a line up in code to be used as a conditional breakpoint for debugging.
{
    ControlGetFocus, which_scintilla, A
    SendInput {End}{Enter}
    RunWait, lib\code_snippets.ahk "xbrkp"
    save_x := A_CaretX
    save_y := A_CaretY
    start_dbgp()  
    sleep 1000
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
