#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%
; Menu, Tray, NoIcon

fname := AHK_MY_ROOT_DIR . "\Misc\Shortcut Mapper List - Formatted.txt"
if !FileExist(fname)
{
    MsgBox, 48,, % "Missing shortcut file: `n`n" fname
    Return
}
    
WinMenuSelectItem, A,, File, Open
Sleep 500
SendInput %fname%{Enter}

Sleep 500
WinMenuSelectItem, A,, Search, Find
; SendInput ^f    ;find
Sleep 500

MsgBox, 64,,Place cursor anywhere on line of `nthe shortcut you want to find.`n`nHit Alt+Shift+F7 to find that shortcut in shortcut mapper.
SendInput {Control Down}{Home}{Control Up}

WinGetTitle, win_title, A
current_fname := StrReplace(win_title," - Notepad++")
; #IF (current_fname == fname)

Return

; Place cursor anywhere on the line in the file you are interested in. 
; Hit the hotkey to go to that line in Notepad++ Shortcut Mapper.
!+F7:: 
    WinGetTitle, win_title, A
    current_fname := StrReplace(win_title," - Notepad++")
    If (current_fname != fname)
    {
        MsgBox, 64,, % "Wrong file: `n" current_fname "`n`nShould be: `n" fname
        Goto EXITNOW
   }
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput {Home}+{End}^c{Home}
    Clipwait, 1
    line := Clipboard
    line:= StrReplace(line, "|", "|", countx, -1)
    if countx <> 3
    {
        MsgBox 48, Unexpected format, % "Can't use this line.`n`n" countx " delimeters found instead of 3.`nCheck your cursor placement."
        Goto EXITNOW
    }

    fields := StrSplit(line,"|")
    name := trim(fields[1])
    shortcut := trim(fields[2])
    category := trim(fields[3])
    tab_name := trim(fields[4])
    StringLower, name, name
    StringLower, shortcut, shortcut
    StringLower, category, category
    StringLower, tab_name, tab_name
    ;
    if (tab_name == "main menu")
        send_cmd := ""
    else if (tab_name == "macros")
        send_cmd := "{Right 1}"
    else if (tab_name == "run commands")
        send_cmd := "{Right 2}"
    else if (tab_name == "plugin commands")
        send_cmd := "{Right 3}"
    else if (tab_name == "scintilla commands")
        send_cmd := "{Right 4}"
    else
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
    SetTimer
    Return 
    
