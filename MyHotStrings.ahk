;-------------------------------------------------
; Note: {Left}{Right} at the end of hotstrings 
;       is to get rid of autocomplete box 
;-------------------------------------------------
#SingleInstance Force
#NoEnv
#NoTrayIcon
;-----------------------------
; Misc 
;-----------------------------
:*:pws::PowerShell
:*:rnhx::rnhbs59970
:*:tnx::6046746082
:*:hdx::210144
:*:hdpx::6045756600
:*:phnx::9803518125
:*:pcx::V4N5V4
:*:60x::6032086    ; Chelsea
:*:mlx::mark_leibson@hotmail.com
:*:gitd::C:\Users\Mark\Documents\GitHub{Left}{Right}
;-----------------------------
; SciTE specific
;-----------------------------
:*:scix::C:\Program Files\AutoHotkey\SciTE\SciTE.exe
:*:scid::C:\Users\Mark\Documents\AutoHotkey\SciTE
:*:sciw::C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\SciTE
;-----------------------------
; Notepad++ specific
;-----------------------------
:*:n++::Notepad{+}{+}
:*:nppx::C:\Program Files (x86)\Notepad{+}{+}\notepad{+}{+}.exe
:*:nppcl::C:\Users\Mark\Google Drive\Misc Backups\Notepad{+}{+}\backup
:*:npppl::C:\Users\Mark\AppData\Roaming\Notepad{+}{+}\plugins\Config\      ; customize toolbar plugin icon directory

; regex to remove duplicate lines in Search/Replace dialog. 
:R*:remdupx::^(.*?)$\s+?^(?=.*^\1$)   ; Enter in 'Find what:', blank out 'Replace with;'
;-----------------------------
; AutoHotkey directories 
;-----------------------------
:*:ahkd::C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts 
:*:ahky::AutoHotkey
:X*:ahkx::SendInput %A_AHKPath%
:*:resx::C:\Users\Mark\Desktop\Misc\Resources
;------------------------------------------------
; AutoHotkey programming
;------------------------------------------------
:R*:lrx::{Left}{Right}
:R*:fmtd::Format("{:02}", <xxx>)         ; 0 pad fill 
:R*:fmth::Format("0x{:X}", <xxx>)        ; hex
:R*:wfe::Input,ov,,{Escape}
:*:singx::{#}SingleInstance Force{Left}{Right} 
:*:noic::{#}NoTrayIcon
:*:ucic::Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

:*:asfl::" - Line{#}" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
:*:asfx::" - Line{#}" A_LineNumber " - " A_ThisFunc{Left 39} 
:*:aslx::" - Line{#}" A_LineNumber " - " A_ThisLabel{Left 40} 
:*:ashx::" - Line{#}" A_LineNumber " - " A_ThisHotkey{Left 41} 

:*:geparams::(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="") ; gui event functions params
:*:omparams::(wParam, lParam, msg, hWnd)    ; WM_<Message> functions params
:*:imagex::ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 filename`nIf (ErrorLevel = 0)`n`tMouseMove, x, y{Up 2}{End}^+{Left}
:*:ascr:: A_ScreenWidth, A_ScreenHeight{Left}{Right}
:*:msgx::MsgBox, 48,, % "", 2{Left 4}
:*:msghe::MsgBox, 48,, % "Here 1 - ", 2{Left 4}
:*:msgel::MsgBox, % "ErrorLevel: " ErrorLevel " - Line{#}" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
:*:msgue::MsgBox, 48, Unexpected Error, % A_ThisLabel " - " A_ScriptName `"``r``n<msg>`"{Left}+{Left 5}
:*:odbg::output_debug(<expr>){Left}+{Left 6}
:*:odhe::output_debug("Here 1 - " A_ThisLabel " (" A_ScriptName ")")
:*:odel::output_debug("ErrorLevel: " ErrorLevel " - Line{#}" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
:*:odxy::output_debug(x ", " y " - " A_CoordModeMouse)
:*:odwh::output_debug(x ", " y ", " w ", " h " - " A_CoordModeMouse)
:*:odyn::{Home}If <xxxx>`n`tOutputDebug, Yes `n{Home}Else `n`tOutputDebug, No {Home} +{Tab}!{Home}{Up 3}{Right 3}+{End}
:*:odthis::output_debug("A_ThisHotkey: " A_ThisHotkey " - A_ThisLabel: " A_ThisLabel " - A_ThisFunc: " A_ThisFunc " - A_ScriptName: " A_ScriptName)
:*:odge:output_debug("ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event ", event_info: " event_info ", error_level: " error_level)!{Home}
:*:odz::OutputDebug, % 
:*:aar::A_Args[x]{Left}+{Left}
:*:parsev::Loop, Parse, <var>, ``n, ``r`n`tOutputDebug, % A_LoopField{Left}{Right}
:*:'n::``n
:*:'r::``r                   
:*:'t::``t
:*:'s::`"``r``n``r``n{Space 4}PASTEYOURTEXTHERE{Space 4}``r``n``r``n{Space}`"{Left 14}^+{Left}
:*:rnx::``r``n
:*:anow::FormatTime, end_time,,yyyy-MM-dd HH:mm
:R*:rescx::`; out of character class: \.*?+[{|()^$   |||   in character class: ^-]\
:R*:curx::#Include lib\utils.ahk `nOnExit("restore_cursors")`nset_system_cursor("IDC_WAIT")`nrestore_cursors()
; :*:ahkpy::WinMenuSelectItem, A,,Plugins,Python Script,Scripts,AHK Modules,<PYTHONSCRIPT MODULE HERE>+{Left 26}
