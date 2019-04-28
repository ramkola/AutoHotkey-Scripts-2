#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\Code Snippets.txt
#NoTrayIcon
key_word := select_and_copy_word()
If (key_word = "")
{
    MsgBox, 48,, % "Selection must be 1 word only."
    Return
}

insert_code_snippet(key_word, code_snippetz)

ExitApp

insert_code_snippet(p_key_word, p_code_snippet_array)
{
    ; MsgBox, % "p_key_word: " p_key_word "`r`n`r`n" p_code_snippet_array[p_key_word]
    If RegExMatch(p_key_word, "i)\bCoord.*\b")
        code_snippet := p_code_snippet_array["CoordMode"]
    Else If RegExMatch(p_key_word, "i)\bzztest\b")
        code_snippet := p_code_snippet_array["zztest"]
    Else If RegExMatch(p_key_word, "i)\bClipb.*\b")
        code_snippet := p_code_snippet_array["Clipboard"]
    Else If RegExMatch(p_key_word, "i)\bDetectH.*\b")
        code_snippet := p_code_snippet_array["DetectHiddenWindows"]
    Else If RegExMatch(p_key_word, "i)\bSetWor.*\b")
        code_snippet := p_code_snippet_array["SetWorkingDir"]
    Else If RegExMatch(p_key_word, "i)\bWinG.*\b")
        code_snippet := p_code_snippet_array["WinGetPos"]
    Else If RegExMatch(p_key_word, "i)\bMouseG.*\b")
        code_snippet := p_code_snippet_array["MouseGetPos"]
    Else If RegExMatch(p_key_word, "i)\b(restore|set_sys|cursor).*\b")
        code_snippet := p_code_snippet_array["set_system_cursor"]
    Else If RegExMatch(p_key_word, "i)\bAuto.*\b")
        code_snippet := p_code_snippet_array["AutoTrim"]
    Else If RegExMatch(p_key_word, "i)\bdeleteme.*\b")
        code_snippet := p_code_snippet_array["deleteme"]
    Else If RegExMatch(p_key_word, "i)\b(dbg|cls).*\b")
        code_snippet := p_code_snippet_array["dbgclear"]
    Else If RegExMatch(p_key_word, "i)\bErr.*\b")
        code_snippet := p_code_snippet_array["ErrorLevel"]
    Else If RegExMatch(p_key_word, "i)\bTool.*\b")
        code_snippet := p_code_snippet_array["Tooltip"]
    Else If RegExMatch(p_key_word, "i)\bSing.*\b")
        code_snippet := p_code_snippet_array["#SingleInstance"]
    Else If RegExMatch(p_key_word, "i)\bSetTit.*\b")
        code_snippet := p_code_snippet_array["SetTitleMatchMode"]
    Else If RegExMatch(p_key_word,"i)\bClick.*\b")
        code_snippet := p_code_snippet_array["Click"]
    Else If RegExMatch(p_key_word,"i)\bcomm.*\b")
        code_snippet := p_code_snippet_array["commands"]
    Else
    ; #### DO NOT REMOVE THIS COMMENT. IT IS USED TO FIND THIS LINE NUMBER IN THIS CODE BY OTHER PROGRAMS ### 
    {
        MsgBox, 48,, % "ERROR: No code snippet found for: " p_key_word 
        Return
    }
    ;
    ; remove escape characters from code_snippet - see lib\misc.ahk create_code_snippet_entry()
    code_snippet := StrReplace(code_snippet, "````", "``")
    code_snippet := StrReplace(code_snippet, "``)", ")")
    saved_clipboard := ClipboardAll
    Clipboard := code_snippet
    ClipWait, 2
    If (ErrorLevel = 0)
    {
        ; paste snippet into code (faster and more consistent results than SendInput, %code_snippet%)
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