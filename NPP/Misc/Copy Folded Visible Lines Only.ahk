#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#SingleInstance Force
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

nap_time := 100

Sleep %nap_time%
WinMenuSelectItem, A,,Edit,Select All     ; Ctrl+A
WinMenuSelectItem, A,,Edit,Copy           ; Ctrl+C
WinMenuSelectItem, A,,File,New            ; Ctrl+N
Sleep %nap_time%
WinMenuSelectItem, A,,Edit,Paste          ; Ctrl+V
WinMenuSelectItem, A,,File,Save           ; Ctrl+S
Sleep 200
SendInput deletemenow.ahk{Enter}
Sleep %nap_time%
SendInput !y    ; answer yes to overwrite prompt
Sleep 500
WinMenuSelectItem, A,,View,Fold All       ; Alt+0
Sleep 500
WinMenuSelectItem, A,,Edit,Select All     ; Ctrl+A
Sleep %nap_time%
WinMenuSelectItem, A,,TextFX Viz,V:Delete Invisible Selection
Sleep 200
WinMenuSelectItem, A,,Edit,Select All     ; Ctrl+A
Sleep %nap_time%
WinMenuSelectItem, A,,TextFX,TextFX Edit,E:Delete Blank Lines
;
Sleep %nap_time%
SendInput ^{Home}
Sleep %nap_time%

num_lines := get_statusbar_info("numlines")
Loop, %num_lines% {
    sleep 20
    Clipboard := ""
    SendInput +{Right}^c
    ClipWait,,1
    crlf_check := Clipboard

    Clipboard := ""
    SendInput !{Home}+{End}^c
    ClipWait,,1
    SendInput !{Home}

    deleteme1 := RegExMatch(Clipboard, "\A;", match)            ; comment at beginning of line
    deleteme2 := RegExMatch(Clipboard, "\A\s*{|}\s*\Z", match)  ; a blank line that only has a brace { or }
    deleteme3 := RegExMatch(Clipboard, "\A\s*\Z", match)        ; blank line that contains whitespace
    deleteme4 := RegExMatch(crlf_check, "`r`n", match)          ; blank line with no whitespace just crlf 

    if deleteme1 or deleteme2 or deleteme3 or deleteme4
        WinMenuSelectItem, A,,Edit,Delete   ; DEL

    SendInput {Down}!{Home} ; advance to start of next line
}

Loop, 2
{
    Sleep %nap_time%
    WinMenuSelectItem, A,,Edit,Select All     ; Ctrl+A
    Sleep %nap_time%
    WinMenuSelectItem, A,,TextFX,TextFX Edit,E:Delete Blank Lines
}
SendInput {Left} ; cancel selected text


ExitApp

^p::Pause
^x::ExitApp


