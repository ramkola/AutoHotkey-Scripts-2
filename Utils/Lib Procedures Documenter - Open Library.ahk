#SingleInstance Force 
StringCaseSense Off

!+F7::
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput !{Home}+{End}^c
    ClipWait,,1
    library_found := RegExMatch(Clipboard, "i)^library:.*$")
    
    countx := 0
    While not library_found and countx < 20
    {
        if library_found
            break                   
        SendInput {Up}!{Home}+{End}^c
        Sleep 100
        library_found := RegExMatch(Clipboard, "i)^library:.*$")
        countx++
    }
    
    library := trim(SubStr(Clipboard, StrLen("library:") + 1))
    Clipboard := saved_clipboard
    
    if fileexist(library)
    {    SendInput !fo
        Sleep 500
        SendRaw %library%
        SendInput {Enter}
    }
    ExitApp