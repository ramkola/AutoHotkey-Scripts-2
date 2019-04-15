; Needs #Include lib\strings.ahk
goto_line(p_line_num,p_wintitle)
{        
    ; OutputDebug, % "A_TitleMatchMode: " A_TitleMatchMode
    ; OutputDebug, % "p_line_num: " p_line_num " - p_wintitle: " p_wintitle
REPOSITION:
    goto_wintitle = Go To... ahk_class #32770 ahk_exe notepad++.exe 
    WinMenuSelectItem, %p_wintitle%,, Search, Go to...
    Sleep 100
    ControlSetText, Edit1, %p_line_num%, %goto_wintitle%
    ; mark Line radio button
    ControlGet, is_checked, Checked,, Button1, %goto_wintitle%
    If Not is_checked
        Control, Check,, Button1, %goto_wintitle% 
    While WinActive(goto_wintitle)
    {
        ControlClick, Button3, %goto_wintitle%,,,, NA  ; Go  Button
        Sleep 100
    }
    If (A_CaretY > A_ScreenHeight * .70)
    {
        SendInput, {PgDn}
        Goto REPOSITION
    }
    MouseMove, A_CaretX, A_CaretY
    cur_line_num := get_statusbar_info("curline") 
    Return (cur_line_num = p_line_num)
}
