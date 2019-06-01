#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\npp.ahk
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
    If RegExMatch(p_key_word, "i)\bCoord.*\b")
        code_snippet := p_code_snippet_array["CoordMode"]
    Else If RegExMatch(p_key_word, "i)\bzztest\b")
        code_snippet := p_code_snippet_array["zztest"]
    Else If RegExMatch(p_key_word, "i)\bClip.*\b")
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
    Else If RegExMatch(p_key_word,"i)\bactwin.*\b")
        code_snippet := p_code_snippet_array["actwin"]
    Else If RegExMatch(p_key_word,"i)\bcons.*\b")
        code_snippet := p_code_snippet_array["constants"]
    Else If RegExMatch(p_key_word,"i)\bfork.*\b")
        code_snippet := p_code_snippet_array["Fork"]
    Else If RegExMatch(p_key_word,"i)\bFor.*\b")
        code_snippet := p_code_snippet_array["For"]
    Else If RegExMatch(p_key_word,"i)\bInx.*\b")
        code_snippet := p_code_snippet_array["Inx"]
    Else If RegExMatch(p_key_word,"i)\bLhx.*\b")
        code_snippet := p_code_snippet_array["Lhx"]
    Else If RegExMatch(p_key_word,"i)\bNewsc.*\b")
        code_snippet := p_code_snippet_array["Newsc"]
    Else If RegExMatch(p_key_word,"i)\bPexit.*\b")
        code_snippet := p_code_snippet_array["Pexit"]
    Else If RegExMatch(p_key_word,"i)\bProc.*\b")
        code_snippet := p_code_snippet_array["Processes"]
    Else If RegExMatch(p_key_word,"i)\bStri.*\b")
        code_snippet := p_code_snippet_array["Strings"]
    Else If RegExMatch(p_key_word,"i)\bUtil.*\b")
        code_snippet := p_code_snippet_array["Utils"]
    Else If RegExMatch(p_key_word,"i)\bNpp.*\b")
        code_snippet := p_code_snippet_array["Npp"]
    Else If RegExMatch(p_key_word,"i)\bc.*cli.*\b")
        code_snippet := p_code_snippet_array["Controlclick"]
    Else If RegExMatch(p_key_word,"i)\bTipel.*\b")
        code_snippet := p_code_snippet_array["Tipel"]
    Else If RegExMatch(p_key_word,"i)\bOutx.*\b")
        code_snippet := p_code_snippet_array["Outx"]
    Else If RegExMatch(p_key_word,"i)\bSplitp.*\b")
        code_snippet := p_code_snippet_array["Splitpath"]
    Else If RegExMatch(p_key_word,"i)\bSci.*\b")
        code_snippet := p_code_snippet_array["Scintilla"]
    Else If RegExMatch(p_key_word,"i)\bGuiEs.*\b")
        code_snippet := p_code_snippet_array["Guiescape"]
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
    Clipboard := ""
    Clipboard := code_snippet
    ClipWait, 1
    If (Clipboard == code_snippet)
    {
        ; paste snippet into code (faster and more consistent results than SendInput, %code_snippet%)
        SendInput, !{Home}
        WinMenuSelectItem, A,, Edit, Paste
        Sleep 10
        SendInput {Enter}+{End}{Delete}   
        ; SendInput {End}{Enter}   
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