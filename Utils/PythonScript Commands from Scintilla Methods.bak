#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %PYS_MY_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\search (2).png

online_doc := False
in_file := PYS_MY_ROOT_DIR . "\zzPythonScript - Scintilla Methods.txt"
If !FileExist(in_file)
{
    MsgBox, 48,, % "Missing Scintilla Methods file: `n`n" in_file
    Return
}
    
WinMenuSelectItem, A,, File, Open
Sleep 500
SendInput %in_file%{Enter}
Sleep 500
WinMenuSelectItem, A,, Edit,Set Read-Only
SendInput {Control Down}{Home}{Control Up}  ; go to beginning of file

MsgBox, 64,, % "Place cursor anywhere on the line of the method you want.`n`nALt+Shift+F7 to send the method to the PythonScript Console.`n`nWin+F7 to open the method in online Scintilla documentation."

; open find window with accelerator key
Run, ..\AutoHotkey Scripts\MyScripts\NPP\Misc\Find All In Current Document.ahk
Sleep 500

RESETTIMER:
; exit automatically after 10 seconds if I'm not still looking at  
; "zzPythonScript - Scintilla Methods.txt" file. 
SetTimer, EXITNOW, 10000    

Return

; Place cursor anywhere on the line in the file you are interested in. 
; Hit the !+F7 to execute method in PythonScript Console, #F7 to view online documentation.
#F7::
    online_doc := True
    ; no return here. let execution continue to !+F7
!+F7:: 
    WinGetTitle, win_title, A
    current_fname := StrReplace(win_title," - Notepad++")
    If (current_fname != in_file)
    {
        MsgBox, 64,, % "Wrong file: `n" current_fname "`n`nShould be: `n" in_file
        Goto EXITNOW
   }
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendInput {Home}+{End}^c{Home}
    ClipWait, 1
    line_text := Clipboard 
    line_text := RegExReplace(line_text, "editor.*\(.*\).*http://www.scintilla.org/ScintillaDoc.html#.*", "$0", countx)
    If (countx = 0)
    {
        MsgBox 48, Unexpected Format, % "Unexpected text format, can't use this line.`n`nCheck your cursor placement."
        Goto EXITNOW
    }

    editor_method := RegExReplace(line_text,"(editor.*\(.*\)).*", "$1")
    method_help_url := RegExReplace(line_text,"editor.*\(.*\).*(http://www.scintilla.org/ScintillaDoc.html#.*)", "$1")
    If Not online_doc
    {
        ControlFocus, Edit1, A
        SendInput ^a{Delete}
        SendInput, %editor_method%
    }
    Else
    {
        online_doc := False
        run_command := default_browser() " " method_help_url
        Run, %run_command%
    }
    Return

EXITNOW:
    Clipboard := saved_clipboard
    current_file := get_current_npp_filename(True)
    SplitPath, in_file, fname
    If (current_file == fname)
        Goto RESETTIMER          ; resets the timer and keeps the hotkey available
    ExitApp
    


