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
:*:phnx::9803518125
:*:pcx::V4N5V4
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

:*:msgx::MsgBox, 48,, % "", 10{Left 5}
:*:msghe::MsgBox, 48,, % "Here 1 - ", 10{Left 5}
:*:msgel::MsgBox, % "ErrorLevel: " ErrorLevel " - Line{#}" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
:*:msgue::MsgBox, 48, Unexpected Error, % A_ThisLabel " - " A_ScriptName `"``r``n<msg>`"{Left}+{Left 5}
:*:odbg::OutputDebug, % 
:*:odhe::OutputDebug, % "Here 1 - " A_ThisLabel " (" A_ScriptName ")"{Left}{Right}
:*:odel::OutputDebug, % "ErrorLevel: " ErrorLevel " - Line{#}" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
:*:odxy::OutputDebug, % x ", " y " - " A_CoordModeMouse{Left}{Right}
:*:odwh::OutputDebug, % x ", " y ", " w ", " h " - " A_CoordModeMouse{Left}{Right}
:*:odyn::{Home}If <xxxx>`n`tOutputDebug, Yes `n{Home}Else `n`tOutputDebug, No {Home} +{Tab}!{Home}{Up 3}{Right 3}+{End}
:*:odthis::OutputDebug, % "A_ThisHotkey: " A_ThisHotkey " - A_ThisLabel: " A_ThisLabel " - A_ThisFunc: " A_ThisFunc " - A_ScriptName: " A_ScriptName{Left}{Right}
:*:odge::OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event ", event_info: " event_info ", error_level: " error_level!{Home}
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
