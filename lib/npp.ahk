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
; Returns a list of all files opened in Notepad++ 
;   p_fname_only - True  = Filnames with extensions 
;                  False = Fullpaths (default)
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
;-----------------------------------------------------------------------------
; *** Constants to be plugged in "commands" strings in other procedure calls
;   This avoids having to run NppExec's Execute... box for every set of 
;   common commands. Instead, these commands are plugged into the main
;   procedure call "commands" script and NppExec Execute is run only 1 time.
;-----------------------------------------------------------------------------
Global NPPEXEC_COMMANDS_GET_CURRENT_LINE_NUMBER, NPPEXEC_COMMANDS_COPY_MSGRESULT_TO_CLIPBOARD  
NPPEXEC_COMMANDS_GET_CURRENT_LINE_NUMBER = 
(Join`r`n LTrim
    SCI_SENDMSG SCI_GETCURRENTPOS
    SCI_SENDMSG SCI_LINEFROMPOSITION $(MSG_RESULT)
)
;
NPPEXEC_COMMANDS_COPY_MSGRESULT_TO_CLIPBOARD = 
(Join`r`n LTrim
    set local clip_board_string = $(MSG_RESULT)
    set local buffer_len ~ strlen $(clip_board_string)
    SCI_SENDMSG SCI_COPYTEXT $(buffer_len) "$(clip_board_string)"
)
;-----------------------------------------------------------------------------
nppexec_get_indentation(p_line_num:=-999, p_addon_commands:="")
{
    If (p_line_num = -999)
        line_num := "SCI_SENDMSG SCI_GETCURRENTPOS`r`n"
        .           "SCI_SENDMSG SCI_LINEFROMPOSITION $(MSG_RESULT)"
    Else
        line_num := "set MSG_RESULT = " p_line_num - 1

    commands = 
    (Join`r`n LTrim
        NPP_CONSOLE ?
        %line_num%
        SCI_SENDMSG SCI_GETLINEINDENTATION $(MSG_RESULT)
        set local indentation = $(MSG_RESULT)
        set local buffer_len ~ strlen $(indentation)
        SCI_SENDMSG SCI_COPYTEXT $(buffer_len) "$(indentation)"
        %p_addon_commands%
    )
    Return nppexec_return_code(commands)
}
;-------------------------------------------------------------------------------------
;
;   If nothing is currently selected it will select and return the word at the current
;   caret position. Otherwise, it returns whatever is currently selected.
;
;-----------------------------------------------------------------------------
nppexec_select_and_copy_word()
{
    commands = 
    (Join`r`n LTrim
        NPP_CONSOLE ?
        SCI_SENDMSG SCI_GETSELTEXT
        set local sel_length = $(MSG_RESULT)
        If $(sel_length) < 2       ; sel_length of 1 is null pointer, not selected text. 
            SCI_SENDMSG SCI_GETCURRENTPOS
            set local doc_pos = $(MSG_RESULT)
            SCI_SENDMSG SCI_WORDSTARTPOSITION $(doc_pos) 1
            set local word_start = $(MSG_RESULT)
            SCI_SENDMSG SCI_WORDENDPOSITION $(doc_pos) 1
            set local word_end = $(MSG_RESULT)
            SCI_SENDMSG SCI_SETSEL $(word_start) $(word_end)
        EndIf
        SCI_SENDMSG SCI_COPY
    )
    Return nppexec_return_code(commands)
}
;-----------------------------------------------------------------------------
nppexec_goto_line(p_line_num)
{
    line_num := p_line_num - 1
    commands = 
    (Join`r`n LTrim
        SCI_SENDMSG SCI_GOTOLINE %line_num%
        SCI_SENDMSG SCI_SETFIRSTVISIBLELINE %line_num%
        %NPPEXEC_COMMANDS_GET_CURRENT_LINE_NUMBER%
        %NPPEXEC_COMMANDS_COPY_MSGRESULT_TO_CLIPBOARD%
    )
    Return (nppexec_return_code(commands) = line_num)
}
;-----------------------------------------------------------------------------
nppexec_return_code(p_commands)
{
    saved_clipboard := ClipboardAll
    Clipboard := ""
    nppexec_script(p_commands)
    ClipWait, 0.5
    If (ErrorLevel) and (Clipboard == "")
        OutputDebug, % "ClipWait Timeout - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    return_code := Clipboard
    Clipboard := saved_clipboard
    Return return_code
}
;-----------------------------------------------------------------------------
; p_show_console - 0, 1, "?"  (or True, False, "?") "?" = keep current state
nppexec_script(p_commands, p_show_console := "?")
{
    If (p_commands == "")
        Return
    saved_titlematchmode := A_TitleMatchMode
    SetTitleMatchMode 3
    active_hwnd := WinExist("A")
    commands := "NPP_CONSOLE " p_show_console "`r`n" p_commands 
    nppexec_wintitle = Execute... ahk_class #32770 ahk_exe notepad++.exe
    npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe
    WinActivate, %npp_wintitle%     ; needed to access menu when Notepad++ not active
    WinMenuSelectItem, A,, Plugins, NppExec, Execute...
    WinActivate, ahk_id %active_hwnd%   ; restore active window
    Sleep 100
    ControlSetText, Edit1, %commands%, %nppexec_wintitle%
    countx := 0
    While WinExist(nppexec_wintitle)
    {
        countx++
        ControlClick, OK, %nppexec_wintitle%,, Left, 1, NA
        Sleep 100
    }
    OutputDebug, % "Number of clicks to close " nppexec_wintitle " = " countx " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    ; alternative to controlclick - ControlSend, OK, {Enter}, %nppexec_wintitle%
    SetTitleMatchMode %saved_titlematchmode%
    Return
}