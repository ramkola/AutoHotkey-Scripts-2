; Needs #Include lib\strings.ahk for get_statusbar_info()
goto_line(p_line_num,p_wintitle)
{   
    npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
    saved_titlematchmode := A_TitleMatchMode
    SetTitleMatchMode 2
REPOSITION:
    WinActivate, %npp_wintitle%
    WinWaitActive, %npp_wintitle%,,2
    goto_wintitle = Go To... ahk_class #32770 ahk_exe notepad++.exe 
    WinMenuSelectItem, %p_wintitle%,, Search, Go to...
    WinWaitActive, %goto_wintitle%,,2
    ControlSetText, Edit1, %p_line_num%, %goto_wintitle%
    ; mark Line radio button
    ControlGet, is_checked, Checked,, Button1, %goto_wintitle%
    If Not is_checked
        Control, Check,, Button1, %goto_wintitle% 
    Sleep 1
    ControlClick, Button3, %goto_wintitle%,,,, NA  ; Go  Button
    WinGetPos,,,, h, %npp_wintitle%
    If (A_CaretY > (h * .70))
    {
        SendInput, {PgDn}
        Goto REPOSITION
    }
GOTO_LINE_EXIT:
    MouseMove, A_CaretX, A_CaretY
    cur_line_num := get_statusbar_info("curline") 
    SetTitleMatchMode %A_TitleMatchMode%
    Return (cur_line_num = p_line_num)
}
