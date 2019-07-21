#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%

export_dir = C:\Users\Mark\Desktop
in_file := export_bookmarks(export_dir)
If !FileExist(in_file)
{
    MsgBox, 48,, % "Could not create exported bookmarks file:`r`n" in_file
    ExitApp
}
FileRead, in_file_var, %in_file%
qt := chr(34)
; only want bookmarks in the TV Shows root folder 
tv_shows_pos := RegExMatch(in_file_var, "isO).*(<DT><H3 ADD_DATE=.*>TV Shows</H3>\s*<DL><p>.*)", match, 1)
tv_show_bookmarks := match.value(1)
; delete unwanted bookmarks within TV Shows folder
eob_tv_shows = <DT><A HREF="http://dummysite/" ADD_DATE=.*>zzzzz END OF BOOKMARKS TV SHOWS zzzzz</A>.*
tv_show_bookmarks := RegExReplace(tv_show_bookmarks, "is)" eob_tv_shows, "")
unwanted_folders = <DT><H3.*?</H3>\s*<DL><p>.*?</DL><p>
tv_show_bookmarks := RegExReplace(tv_show_bookmarks, "is)" unwanted_folders, "")
;
show_info := []
start_pos = 1
found_pos = 99999
While found_pos
{
    found_pos := RegExMatch(tv_show_bookmarks
        , "iO)<DT><A HREF=" qt "(.*)" qt "\s*ADD_DATE=.*>(.*)</A>" 
        , match, start_pos)     
    If found_pos
    {
        show_url   := match.value(1)
        show_title := SubStr(match.value(2), 1, 50)
        show_title := StrReplace(show_title, "&#39;", "'")
        show_info.push([show_title, show_url])
        start_pos := match.pos(2) + match.len(2)
    }
}

For i, j In show_info
    write_string .= Format("{:-50} - {}`r`n", j[1], j[2])
display_text(write_string, show_info.Count()+1)
ExitApp

export_bookmarks(p_export_dir)
{
    bookmarks_wintitle = Bookmarks - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    saved_clipboard := ClipboardAll
    Clipboard := ""
    Run, MyScripts\Utils\Web\Activate Browser.ahk %False% %False%
    WinWaitActive, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,2
    Sleep 1000
    SendInput ^+o   ; open bookmarks manager
    Sleep 1000
    If !WinActive(bookmarks_wintitle)
        Return
    SendInput {Tab}{Space}{Down 5}{Enter}   ; export bookmarks
    Sleep 500
    SendInput ^x
    ClipWait, 1
    fname := Clipboard
    fname := p_export_dir "\" fname
    FileDelete, %fname%
    Clipboard := fname
    SendInput ^v
    Sleep 100
    SendInput {Enter}
    While WinExist("Save As ahk_class #32770 ahk_exe chrome.exe")
        Sleep 10
    Sleep 1000
    Clipboard := saved_clipboard
    WinActivate, %bookmarks_wintitle%
    If WinActive(bookmarks_wintitle)
        SendInput ^w
    backup_fname := fname ".bak"
    FileCopy, %fname%, %backup_fname%, 1    ; overwrite
    Return fname
}