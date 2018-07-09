#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#NoEnv
#SingleInstance Force 
StringCaseSense Off
Menu, Tray, Icon, resources\32x32\search (2).png

; exit automatically after 1 minute if I'm not still looking at  
; "Lib Procedures Documenter.txt" file. 
SetTimer, EXITNOW, 60000    

!+F7::
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput !{Home}+{End}^c
    ClipWait,,1
    library_found := RegExMatch(Clipboard, "i)^library:.*$")
    
    countx := 0
    While Not library_found And countx < 20
    {
        If library_found
            Break                   
        SendInput {Up}!{Home}+{End}^c
        Sleep 100
        library_found := RegExMatch(Clipboard, "i)^library:.*$")
        countx++
    }
    
    library := Trim(SubStr(Clipboard, StrLen("library:") + 1))
    Clipboard := saved_clipboard
    
    If FileExist(library)
    {
        SendInput !fo
        Sleep 500
        SendRaw %library%
        SendInput {Enter}
    }

EXITNOW:
    current_file := get_current_npp_filename(True)
    If (current_file == "Lib Procedures Documenter.txt")
        Reload          ; resets the timer and keeps the hotkey available
    ExitApp


