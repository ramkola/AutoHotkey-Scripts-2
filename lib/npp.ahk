#Include lib\strings.ahk
;------------------------------------------------------------
npp_open_file(p_filename)
{
    If Not FileExist(p_filename)
    {
        MsgBox, 48,, % "File does not exist:`r`n" p_filename
        Return False
    }
    npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
    WinActivate, %npp_wintitle%
    WinWaitActive, %npp_wintitle%,,2

    file_open_wintitle = Open ahk_class #32770 ahk_exe notepad++.exe
    WinMenuSelectItem, A,, File, Open
    WinWaitActive, %file_open_wintitle%,, 2
    ControlSetText, Edit1, %p_filename%, %file_open_wintitle%
    Sleep 10
    ; While WinActive(file_open_wintitle)
    ; {
        ControlClick, &Open, %file_open_wintitle%,, Left, 1, NA
        ; Sleep 100
    ; }
    WinWaitActive, %npp_wintitle%,,2
    WinGetActiveTitle, active_wintitle 
    Return Instr(active_wintitle, p_filename)
}
;------------------------------------------------------------
; Returns a list of all fullpaths opened in Notepad++
;------------------------------------------------------------
npp_get_open_tabs(p_fname_only := False)
{
    npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
    If Not WinActive(npp_wintitle)
        Return 
    WinMenuSelectItem, A,, Window, Windows...    ; PostMessage, 0x111, 11001,,, A ;WM_COMMAND := 0x111 ;Windows...
    WinWaitActive, Windows ahk_class #32770
    tablist_hwnd := WinExist("A")
    ControlGet, tab_list, List,, SysListView321, ahk_id %tablist_hwnd%
    WinClose, ahk_id %tablist_hwnd%
    write_string := ""
    Loop, Parse, tab_list, `n, `r
    {
        fields := StrSplit(A_LoopField, "`t")
        If !p_fname_only
            write_string .= fields[2] "\" fields[1] "`r`n"
        Else
            write_string .= fields[1] "`r`n"
    }
    Return write_string
}
;------------------------------------------------------------
; Needs #Include lib\strings.ahk for get_statusbar_info()
;------------------------------------------------------------
npp_goto_line(p_line_num,p_wintitle)
{   
    npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
    saved_titlematchmode := A_TitleMatchMode
    SetTitleMatchMode 2
    retry_reposition := True
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
    If (A_CaretY > (h * .70) and retry_reposition)
    {
        retry_reposition := False
        SendInput, {PgDn}
        Goto REPOSITION
    }
GOTO_LINE_EXIT:
    MouseMove, A_CaretX, A_CaretY
    cur_line_num := get_statusbar_info("curline") 
    SetTitleMatchMode %A_TitleMatchMode%
    Return (cur_line_num = p_line_num)
}

nppexec_goto_line(p_line_num)
{
    line_num := p_line_num - 1
    commands = 
    (Join`r`n LTrim
        SCI_SENDMSG SCI_GOTOLINE %line_num%
        SCI_SENDMSG SCI_SETFIRSTVISIBLELINE %line_num%
        ; SCI_SENDMSG SCI_SCROLLCARET
    )
    nppexec_script(commands)
}

; p_show_console - 0, 1, "?"  (or True, False, "?") "?" = keep current state
nppexec_script(p_commands, p_show_console := "?")
{
    If (p_commands == "")
        Return
    commands := "NPP_CONSOLE " p_show_console "`r`n" p_commands 
    nppexec_wintitle = Execute... ahk_class #32770 ahk_exe notepad++.exe
    WinMenuSelectItem, A,, Plugins, NppExec, Execute...
    Sleep 100
    ControlSetText, Edit1, %commands%, %nppexec_wintitle%
    ControlClick, OK, %nppexec_wintitle%,, Left, 1, NA     
    ; alternative to controlclick - ControlSend, OK, {Enter}, %nppexec_wintitle%
    Return
}