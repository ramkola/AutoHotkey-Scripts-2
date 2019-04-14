#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\Code Snippets.txt
#NoTrayIcon

the_word := select_and_copy_word()
If the_word
    insert_code_snippet(the_word, code_snippetz)
Else
    MsgBox, 48,, % "Selection must be 1 word only."
ExitApp

insert_code_snippet(p_word, p_code_snippet_array)
{
    If RegExMatch(p_word,"i)\bCoord.*\b")
        code_snippet := p_code_snippet_array["CoordMode"]
    Else If RegExMatch(p_word,"i)\bClipb.*\b")
        code_snippet := p_code_snippet_array["Clipboard"]
    Else If RegExMatch(p_word,"i)\bDetectH.*\b")
        code_snippet := p_code_snippet_array["DetectHiddenWindows"]
    Else If RegExMatch(p_word,"i)\bSetWor.*\b")
        code_snippet := p_code_snippet_array["SetWorkingDir"]
    Else If RegExMatch(p_word,"i)\bWinG.*\b")
        code_snippet := p_code_snippet_array["WinGetPos"]
    Else If RegExMatch(p_word,"i)\bMouseG.*\b")
        code_snippet := p_code_snippet_array["MouseGetPos"]
    Else If RegExMatch(p_word,"i)\b(restore|set_sys|cursor).*\b")
        code_snippet := p_code_snippet_array["set_system_cursor"]
    Else If RegExMatch(p_word,"i)\bAuto.*\b")
        code_snippet := p_code_snippet_array["AutoTrim"]
    Else If RegExMatch(p_word,"i)\bdeleteme.*\b")
        code_snippet := p_code_snippet_array["deleteme"]
    Else If RegExMatch(p_word,"i)\bdbg.*\b")
        code_snippet := p_code_snippet_array["dbgclear"]
    Else If RegExMatch(p_word,"i)\bErr.*\b")
        code_snippet := p_code_snippet_array["ErrorLevel"]
    Else
        code_snippet := "ERROR: No code snippet found for: " p_word 
    ;
    ; paste snippet into code (faster and more consistent results than SendInput, %code_snippet%)
    saved_clipboard := ClipboardAll
    Clipboard := code_snippet
    ClipWait, 2
    If (ErrorLevel = 0)
    {
        SendInput, !{Home}^v
        Sleep 10
        SendInput {Enter}   
    }
    Else
    {
        ; clipwait timed out for some reason
        BlockInput, On
        SendInput, % code_snippet
        BlockInput, Off
    }
    Clipboard := saved_clipboard
    Return
}   