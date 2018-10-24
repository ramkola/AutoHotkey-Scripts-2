#SingleInstance Force
SetTitleMatchMode RegEx
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

OutputDebug, DBGVIEWCLEAR
WinGet, npp_hwnd, ID, A
npp_hwnd := "ahk_id " npp_hwnd
chrome_wintitle = (?!^Celebrity).*Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

RAlt::
    WinGet, chrome_hwnd, ID, %chrome_wintitle%
    chrome_hwnd := "ahk_id " chrome_hwnd
    chrome_hwnd = ahk_id 0x1e07f8
    Clipboard := ""
    WinActivate, %chrome_hwnd%
    WinWaitActive, %chrome_hwnd%,,2
    If ErrorLevel
        error_handler("Timeout while activating Chrome: " chrome_hwnd)
    
    SendInput ^l
    Sleep 200
    SendInput ^a^c
    ClipWait,2
    url_page := Clipboard   
    If RegExMatch(url_page,"^.*?/\d+\.html$")       ; https://www.appurse.com/articles/when.../2.html
    {
        next_page_num:= RegExReplace(url_page, "^.*?/(\d+)\.html", "$1") + 1   
        url_next_page:= RegExReplace(url_page, "(^.*?/)\d+(.html)", "$1" next_page_num "$2")
    }
    Else If RegExMatch(url_page,"^.*?/\d+$")       ; https://www.appurse.com/articles/when.../2/
    {
OutputDebug, % "here"
        next_page_num:= RegExReplace(url_page, "^.*/(\d+)$","$1") + 1
        url_next_page:= RegExReplace(url_page, "(^.*?/)\d+", "$1" next_page_num )   
    }   
    Else If RegExMatch(url_page,"^.*?/\d+/$")       ; https://www.appurse.com/articles/when.../2/
    {
        next_page_num:= RegExReplace(url_page, "^.*?/(\d+)/", "$1") + 1   
        url_next_page:= RegExReplace(url_page, "(^.*?/)\d+/", "$1" next_page_num "/" )   
    }   
    Else If RegExMatch(url_page,"^.*?/\?p=\d+$") 
    {
        next_page_num:= RegExReplace(url_page, "^.*?/\?p=(\d+)", "$1") + 1   
        url_next_page:= RegExReplace(url_page, "(^.*?/\?p=)\d+$", "$1" next_page_num)   
    }
    Else If RegExMatch(url_page,"^.*?/\d+/.*utm_term=\d+$")     ; http://boredomtherapy.com/wd-40-hacks-hc-bt/3/...&utm_term=67478194
    {
        next_page_num:= RegExReplace(url_page, ".*/(\d+)/\?as=.\d+.*?utm_term=\d+","$1", replace_count) + 1
        url_next_page:= RegExReplace(url_page, "(^.*?/)\d+(/.*utm_term=\d+$)", "$1" next_page_num "$2")   
    }
    Else
        error_handler("RegEx not found in clipboard: |" Clipboard "|")
    
    Clipboard := url_next_page
    ClipWait, 1
    SendInput ^v{Enter}
    Sleep 1500
    SendInput {Down 7}
                
    ; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    ; Sleep 10
    ; WinActivate, %npp_hwnd%
    ; OutputDebug, % "npp_hwnd: " npp_hwnd " - chrome_hwnd: " chrome_hwnd
    ; OutputDebug, % url_page
    ; OutputDebug, % url_next_page
    ; OutputDebug, % "Done"

Return

error_handler(p_msg := "")
{
    MsgBox, 48,, % p_msg
    ExitApp
}

^+x::ExitApp
