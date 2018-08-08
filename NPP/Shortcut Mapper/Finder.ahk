#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\npp.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Search\search (2).png

in_file := AHK_ROOT_DIR . "\Misc\Shortcut Mapper List - Formatted.txt"
If !FileExist(in_file)
{
    MsgBox, 48,, % "Missing shortcut file: `n`n" in_file
    Return
}
    
WinMenuSelectItem, A,, File, Open
Sleep 500
SendInput %in_file%{Enter}
Sleep 500
WinMenuSelectItem, A,, Edit,Set Read-Only
SendInput {Control Down}{Home}{Control Up}  ; go to beginning of file

MsgBox, 64,,Place cursor anywhere On line of `nthe shortcut you want to find.`n`nHit Alt+Shift+F7 to find that shortcut in shortcut mapper.,3

; open find window with accelerator key
Run, MyScripts\NPP\Misc\Find All In Current Document.ahk
Sleep 500


RESETTIMER:
; exit automatically after 10 seconds if I'm not still looking at  
; "Shortcut Mapper List - Formatted.txt"" file. 
SetTimer, EXITNOW, 10000    

Return

; Place cursor anywhere on the line in the file you are interested in. 
; Hit the hotkey to go to that line in Notepad++ Shortcut Mapper.
!+F7:: 
    WinGetTitle, win_title, A
    current_fname := StrReplace(win_title," - Notepad++")
    
    OutputDebug, % "current_fname: |" current_fname "|"
    
    If (current_fname != in_file)
    {
        MsgBox, 64,, % "Wrong file: `n" current_fname "`n`nShould be: `n" in_file
        Goto EXITNOW
   }
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput {Home}+{End}^c{Home}
    ClipWait, 1
    line := Clipboard
    line:= StrReplace(line, "|", "|", countx, -1)
    If countx <> 3
    {
        MsgBox 48, Unexpected Format, % "Can't use this line.`n`n" countx " delimeters found instead of 3.`nCheck your cursor placement."
        Goto EXITNOW
    }

    fields := StrSplit(line,"|")
    name := Trim(fields[1])
    shortcut := Trim(fields[2])
    category := Trim(fields[3])
    tab_name := Trim(fields[4])
    StringLower, name, name
    StringLower, shortcut, shortcut
    StringLower, category, category
    StringLower, tab_name, tab_name
    ;
    If (tab_name == "main menu")
        send_cmd := ""
    Else If (tab_name == "macros")
        send_cmd := "{Right 1}"
    Else If (tab_name == "run commands")
        send_cmd := "{Right 2}"
    Else If (tab_name == "plugin commands")
        send_cmd := "{Right 3}"
    Else If (tab_name == "scintilla commands")
        send_cmd := "{Right 4}"
    Else
    {
        MsgBox 48, Unexpected Menu, % tab_name
        Goto EXITNOW        
    }
    ;
    WinMenuSelectItem, A,, Settings, Shortcut Mapper
    Sleep 50
    SendInput % send_cmd
    SendInput {Shift Down}{Tab 2}{Shift Up}
    SendInput %name%{Tab}

EXITNOW:
    Clipboard := saved_clipboard
    current_file := npp_get_current_filename(True)
    SplitPath, in_file, fname
    If (current_file == fname)
        Goto RESETTIMER          ; resets the timer and keeps the hotkey available
    ExitApp
    

