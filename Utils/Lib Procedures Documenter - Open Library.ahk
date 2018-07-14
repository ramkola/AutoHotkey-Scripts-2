#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#NoEnv
#SingleInstance Force 
StringCaseSense Off
SetWorkingDir %AHK_MY_ROOT_DIR%
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
    If Not FileExist(library)
    {
        MsgBox, 48,, % "Library does not exist: `r`n" library, 10
        Goto EXITNOW
    }

    ; find procedure call
    SendInput {Down}!{Home}+{End}^c
    Sleep 100
    proc_pos:= RegExMatch(Clipboard, "iO)\w+\(.*\)", match)
    If proc_pos
    {
        proc_call := match.value   
        line_num := get_proc_line(proc_call, library)
    }

    WinMenuSelectItem, A,, File, Open
    Sleep 500
    SendInput %library%{Enter}
    SendInput {LControl Down}{Shift Down}g{Shift Up}{LControl Up}%line_num%!l{Enter}+{Down}

 
EXITNOW:
    current_file := get_current_npp_filename(True)
    If (current_file == "Lib Procedures Documenter.txt")
        Reload          ; resets the timer and keeps the hotkey available
    Clipboard := saved_clipboard
    ExitApp


get_proc_line(p_proc_call, p_library)
{
    line_num := 0
    FileRead, in_file_var, %p_library%
    file_array := StrSplit(in_file_var, "`n", "`r")
    For line_num, line_text in file_array        
    {
        proc_pos:= InStr(line_text, p_proc_call)
        If proc_pos = 1
        {
            line_num := line_num
            found := True
            Break
        }
    }
    Return %line_num%
}
