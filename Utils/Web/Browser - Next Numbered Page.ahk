#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#Include lib\strings.ahk
SetCapsLockState AlwaysOff
SetTitleMatchMode RegEx
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Signs\googledrivesync_1.ico
; g_TRAY_RELOAD_ON_LEFTCLICK := True      ; see lib\utils.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
WinGet, npp_hwnd, ID, A
npp_hwnd := "ahk_id " npp_hwnd
#If WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")
Return

;=====================================================================

^!+PgDn::   ; GoWatchSeries - get the next episode page and click start video 
    full_screen := ""
    Gosub ^PgDn
    Sleep 5000      ; wait for next page to load with ads (they take a long time to load)
    ; OutputDebug, % "A_ThisFunc: " A_ThisFunc " - A_ThisHotkey: " A_ThisHotkey " - A_ScriptName: " A_ScriptName
    Run, MyScripts\Utils\Web\GoWatchSeries - Start Video.ahk %full_screen%
    Return

^+PgDn::    ; GoWatchSeries - click start video on current page
    Run, "MyScripts\Utils\Web\GoWatchSeries - Start Video.ahk"
    Return

^PgDn::     ; Get the next page on a variety of web sites that have numbered URLs
    If (A_ThisHotkey = "^PgDn") 
        chrome_wintitle = ^(?!Watch|.*www\.youtube\.com).* - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    Else If (A_ThisHotkey = "^!+PgDn")
        chrome_wintitle = ^Watch.*?- Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    Else 
        error_handler("unexpected hotkey: " A_ThisHotkey)
    WinGet, chrome_hwnd, ID, %chrome_wintitle%
    chrome_hwnd := "ahk_id " chrome_hwnd

    Clipboard := ""
    WinActivate, %chrome_hwnd%
    WinWaitActive, %chrome_hwnd%,,2
    If ErrorLevel
    {
        error_handler("Timeout while activating Chrome: " chrome_hwnd)
        Goto RETURN_NOW
    }
    If (A_ThisHotkey = "^!+PgDn")
    {
        MouseGetPos,,,,control_classnn
        full_screen := (control_classnn = "Intermediate D3D Window1")
        If full_screen
        {
            SendInput {Escape}  ; take window out of fullscreen so that url can copied from address bar.
            Sleep 100
        }
    }
    ;
    SendInput ^l        ; move to browser address bar 
    Sleep 200
    SendInput ^a^c
    ClipWait,2
    url_page := Clipboard   
    If RegExMatch(url_page,"^.*?/\d+\.html$")       ; https://.../2.html
    {
        next_page_num := RegExReplace(url_page, "^.*?/(\d+)\.html", "$1") + 1   
        url_next_page := RegExReplace(url_page, "(^.*?/)\d+(.html)", "$1" next_page_num "$2")
    }
    Else If RegExMatch(url_page,"^.*?/page-\d+\.html$")       ; http://.../page-43.html
    {
        next_page_num := RegExReplace(url_page, "^.*?/page-(\d+)\.html", "$1") + 1   
        url_next_page := RegExReplace(url_page, "(^.*?/page-)\d+(.html)", "$1" next_page_num "$2")
    }
    Else If RegExMatch(url_page,"^.*?/\d+/.*$")       ; http://.../5/...
    {
        next_page_num := RegExReplace(url_page, "^.*?/(\d+)/.*$", "$1") + 1   
        url_next_page := RegExReplace(url_page, "(^.*?/)\d+(/.*$)", "$1" next_page_num "$2")
    }
    Else If RegExMatch(url_page,"^.*?/#?\d+$")       ; https://.../2    or https://.../#2
    {
        next_page_num := RegExReplace(url_page, "^.*/#?(\d+)$","$1") + 1
        url_next_page := RegExReplace(url_page, "(^.*?/#?)\d+$", "$1" next_page_num )   
    }   
    Else If RegExMatch(url_page,"^.*/\d+/$")       ; https://.../2/
    {
        next_page_num := RegExReplace(url_page, "^.*?/(\d+)/$", "$1") + 1   
        url_next_page := RegExReplace(url_page, "(^.*?/)\d+/$", "$1" next_page_num "/" )   
    }   
    Else If RegExMatch(url_page,"^.*?/\?p=\d+$")    ; https://.../?p=2
    {
        next_page_num := RegExReplace(url_page, "^.*?/\?p=(\d+)", "$1") + 1   
        url_next_page := RegExReplace(url_page, "(^.*?/\?p=)\d+$", "$1" next_page_num)   
    }
    Else If RegExMatch(url_page,"^.*?/\d+/.*utm_term=\d+$")     ; http://.../3/...&utm_term=67478194
    {
        next_page_num := RegExReplace(url_page, ".*/(\d+)/\?as=.\d+.*?utm_term=\d+","$1") + 1
        url_next_page := RegExReplace(url_page, "(^.*?/)\d+(/.*utm_term=\d+$)", "$1" next_page_num "$2")   
    }
    Else If RegExMatch(url_page,"^.*/(\d+)\?slides=\d+$")       ; https://.../4?slides=1
    {
        next_page_num := RegExReplace(url_page, "^.*/(\d+)\?slides=\d+$","$1") + 1
        url_next_page := RegExReplace(url_page, "(^.*/)\d+(\?slides=\d+$)","$1" next_page_num "$2")
    }
    Else If RegExMatch(url_page,"^.*season-\d+-episode-\d+$")     ; use ^!+PgDn to activate  -  https://...season-9-episode-11
    {
        next_page_num := RegExReplace(url_page, "^.*season-\d+-episode-(\d+)$","$1") + 1
        url_next_page := RegExReplace(url_page, "(^.*season-\d+-episode-)\d+$","$1" next_page_num)
    }   
    Else
    {
        error_handler("RegEx not found in clipboard: |" Clipboard "|")  
        Goto RETURN_NOW
    }
    
    Clipboard := url_next_page
    ClipWait, 1
    SendInput ^v{Enter}
    Sleep 1500
    If (A_ThisHotkey = "^PgDn")
        Return
                
RETURN_NOW:
    ; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    ; Sleep 10
    ; WinActivate, %npp_hwnd%
    ; OutputDebug, % "chrome_hwnd: " chrome_hwnd " - chrome_wintitle: " chrome_wintitle
    ; OutputDebug, % url_page
    ; OutputDebug, % url_next_page
    ; OutputDebug, % "Done"
Return

^+k:: list_hotkeys()

error_handler(p_msg := "")
{
    MsgBox, 48,, % p_msg
    Gosub RETURN_NOW
}
