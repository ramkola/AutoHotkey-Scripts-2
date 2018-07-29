;------------------------------------------------------------------------------------------------
;
; This function requires PythonScript plugin with pyperclip installed in python's site_packages
;
; get_npp_tab_list(p_npp_tab_list)
; 
; Retrieves all filenames opened in Notepad++ with their associated tab number
;
;------------------------------------------------------------------------------------------------
get_npp_tab_list(p_npp_tab_list)
{
    saved_clipboard := ClipboardAll
    Clipboard := ""
    WinMenuSelectItem, A,,Plugins,Python Script,Scripts,AHK Modules,Get_Npp_Open_Files
    Sleep 60
    notepad_getfiles := SubStr(Clipboard, 1, -1)    ; truncate eof blank line
    Loop, Parse, notepad_getfiles, `n, `r 
    {
        tab_info := StrSplit(A_LoopField, chr(7))
        p_npp_tab_list.push([tab_info[1], tab_info[2]])
    }
    Clipboard := saved_clipboard
    Return %p_npp_tab_list%
}
