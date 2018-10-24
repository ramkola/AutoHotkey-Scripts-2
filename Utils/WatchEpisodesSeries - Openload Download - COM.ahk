#SingleInstance Force
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\WatchEpisodeSeries
image0 := "openload\episode list - next episode.png", x0:=30, y0:=10
; re_needle2 - zzcb1.txt
re_needle2 := ".*<a rel=.*target=.*href=.(https://openload.*?)" Chr(34) ".*class=" Chr(34) "watch-button actWatched" Chr(34) ">"  
; re_needle3 - zzcb2.txt
; <a class="watch-button actWatched" href="https://openload.co/embed/9XmQnVOGbyc" target="_blank" rel="nofollow" data-linkid="24030437" data-episodeid="385567">
re_needle3 := ".*class=" Chr(34) "watch-button actWatched" Chr(34) ".*href=.(https://openload.*?)" Chr(34) ".*"  
; re_needle4 -  <h3>We’re Sorry!</h3>     
re_needle4 := "<h3>(We’re Sorry!)</h3>"

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

SetTitleMatchMode RegEx
win_title = Celebrity Big Brother Season \d+ Episode \d+ [s|S]\d+[e|E]\d+ Watch Online.*Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title%
WinWaitActive, %win_title%,,3
If ErrorLevel
    error_handler("Browser page is not active:`n`n" win_title, True, win_title)

ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image0%
If (ErrorLevel > 0)
    error_handler(image0 " (image0): " ErrorLevel, True, win_title)
Else
{
    MouseMove, x+x0, y+y0
    Click
    Sleep 2000
}

SendInput ^l
Sleep 100
SendInput ^c
ClipWait,,2
Sleep 1000
watchepisodeseries_url := Clipboard

re_needle = http://www.watchepisodeseries.com/celebrity-big-brother-season-(\d+)-episode-(\d+)-[s|S]\d+[e|E]\d+_\d+ 
season_num := RegExReplace(watchepisodeseries_url, re_needle, "$1")
next_episode_num := RegExReplace(watchepisodeseries_url, re_needle, "$2")
next_episode_title := "Celebrity Big Brother Season " season_num " Episode " next_episode_num + 1
new_season_title := "Celebrity Big Brother Season " season_num + 1 " Episode 1"


; Create IE instance
wb := ComObjCreate("InternetExplorer.Application")
wb.Navigate(watchepisodeseries_url)
While wb.Busy or wb.ReadyState != 4
    Sleep, 10
wb.Visible := True

inner_text := ""
while True
{
    Try
        inner_text := trim(wb.document.getElementsByTagName("a")[A_Index].innerText)
    Catch   
        Break
    if instr(inner_text, "Celebrity Big Brother")
        OutputDebug, % "inner_text: " inner_text " - " A_Index
    if (inner_text = new_season_title)
    {
        OutputDebug, % "NEW SEASON FOUND: " new_season_title
        Goto EXITNOW
    }
    save_a_index := A_Index  
}


links_list := []
links_list := get_links_list(wb)
OutputDebug, % "maxindex: " links_list.maxindex()
if (links_list.maxindex() == "")
    Goto EXITNOW

openload_link := "dummy"
While openload_link
{
    OutputDebug, % "--------------------------------------------------------------------------"
    OutputDebug, % Format("link_list #{:02}) {}", A_Index, links_list[A_Index])
    openload_link := ""
    html_source := ""
    wb.Navigate(links_list[A_Index])
    While wb.Busy or wb.ReadyState != 4
        Sleep, 10
    html_source := wb.document.documentElement.outerHTML
    openload_link := get_link(html_source, re_needle2)
    If openload_link
        OutputDebug, % "re_needle2 found: " openload_link
    Else
    {
        result := get_link(html_source, re_needle4)
        If result
        {
            OutputDebug, % "re_needle4: " result
            Break   ; video not found go to next link in links_list
        }
        Else
            OutputDebug, % "re_needle4 NOT found - should continue to try re_needle3"
    }
    ; 
    openload_link := get_link(html_source, re_needle3)
    If openload_link
        OutputDebug, % "re_needle3 found: " openload_link " should continue to try re_needle5"
    Else
    {
        result := get_link(html_source, re_needle4)
        If result
        {
            OutputDebug, % "re_needle4: " result
            Break   ; video not found go to next link in links_list
        }
        Else
        {
            OutputDebug, % "re_needle4 NOT found - check html_source clipboard - should continue to next link in links_list"
            Clipboard := html_source
            ClipWait,,2
        }
    }
    
    if openload_link
    {
        re_needle5 = .*(<a id="btnDl" href="#" class="main-button">Download|<a class="main-button" id="btnDl" href="#">Download).*
        html_source := ""
        wb.Navigate(openload_link)
        While wb.Busy or wb.ReadyState != 4
            Sleep, 10
        html_source := wb.document.documentElement.outerHTML 
        openload_link := get_link(html_source, re_needle5)
        If not openload_link
        {
            OutputDebug, % "re_needle5 download NOT found, restart loop with next links_list entry." 
            openload_link := "dummy"    ; restart loop with next links_list entry
        }
        Else
        {
            OutputDebug, % "re_needle5 DOWNLOAD found: " openload_link
            openload_link := ""
            ;
            inner_text := ""
            while (inner_text <> "Download")
            {
                inner_text := wb.document.getElementsByTagName("a")[A_Index].innerText
                save_a_index := A_Index  
            }
            wb.document.getElementsByTagName("a")[save_a_Index].Click()
            ;
            Sleep 6000
            inner_text := ""
            while (InStr(inner_text,"free download") = 0)
            {
                inner_text := trim(wb.document.getElementsByTagName("a")[A_Index].innerText)
                ; OutputDebug, % inner_text
                save_a_index := A_Index  
            }
            OutputDebug, % "Clicking Free Download button first time: " inner_text " save_a_index: " save_a_Index
            wb.document.getElementsByTagName("a")[save_a_Index].Click()
            ;
            Sleep 2000
            ; inner_text := ""
            ; while (InStr(inner_text,"Click to start Download") = 0)
            ; {
                ; inner_text := trim(wb.document.getElementsByTagName("span")[A_Index].innerText)
                ; OutputDebug, % "inner_text: " inner_text " A_Index: " A_Index
                ; save_a_index := A_Index  
            ; }
            ; ; wb.document.getElementsByTagName("span")[save_a_Index].Click()
            wb.document.getElementsByTagName("a")[8].Click()
            Sleep 3000
            SendInput !s    ; save download popup window
            Break
        }
    }
}

EXITNOW:
OutputDebug, % "***** DONE *****"
wb.Quit
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
; WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
; WinRestore, ahk_class Notepad++ ahk_exe notepad++.exe
Return

get_link(p_html, p_needle)
{
    result := ""
    Loop, Parse, p_html, `n, `r 
    {
        result := RegExReplace(A_LoopField, p_needle, "$1", replace_count)
        If replace_count
            Break
    }
    Return (replace_count = 1 ? result : "")
}

get_links_list(p_wb)
{
    p_links_list := []
    html_source := p_wb.document.documentElement.outerHTML
    re_needle1 := ".*(http://www.watchepisodeseries.com/celebrity-big-brother-season.*)" Chr(34) ">openload.*</a>"
    Loop, Parse, html_source, `n, `r 
    {
        openload_link := RegExReplace(A_LoopField, re_needle1,"$1",replace_count)
        If replace_count
            p_links_list.Push(openload_link)
    }
    If (p_links_list.MaxIndex() > 0)
        OutputDebug, % "re_needle1 found, starting to check openload links...."
    else
        OutputDebug, % "re_needle1: NO LINKS FOUND, aborting................"
    Return p_links_list
}

error_handler(p_msg, p_exit_app, p_win_title)
{
    if p_exit_app
    {
        MsgBox, 16,, % p_msg
        ExitApp
    }
    msg := p_msg "`n`nClick Link Manually then click ok to this message"
    MsgBox, 48,, % msg
    WinActivate, %p_win_title%
    WinWaitActive, %p_win_title%,,2
    If (ErrorLevel = 1) ; Timeout
        error_handler("Browser page is not active:`n`n" p_win_title, True, "")
    Return
}

RAlt:: Run, %A_ScriptFullPath%
^+x::ExitApp

; re_needle = http://www.watchepisodeseries.com/celebrity-big-brother-season-(\d+)-episode-(\d+)-[s|S]\d+[e|E]\d+_\d+ 
; season_num := RegExReplace(watchepisodeseries_url, re_needle, "$1")
; next_episode_num := RegExReplace(watchepisodeseries_url, re_needle, "$2")
; next_episode_title := "Celebrity Big Brother Season " season_num " Episode " next_episode_num + 1
; new_season_title := "Celebrity Big Brother Season " season_num + 1 " Episode 1"
; inner_text := ""
; while (inner_text <> next_episode_title)
; {
    ; ; Try inner_text := trim(wb.document.getElementsByTagName("a")[A_Index].innerText)
    ; inner_text := trim(wb.document.getElementsByTagName("a")[A_Index].innerText)
    ; OutputDebug, % "inner_text: " inner_text
    ; if (inner_text = new_season_title)
    ; {
        ; OutputDebug, % "NEW SEASON FOUND: " new_season_title
        ; ExitApp
    ; }
    ; save_a_index := A_Index  
; }
; wb.document.getElementsByTagName("a")[save_a_Index].Click()
