#SingleInstance Force
SetTitleMatchMode RegEx
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\WatchEpisodeSeries

win_title = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
win_title = Celebrity Big Brother Season \d+ Episode \d+ [s|S]\d+[e|E]\d+ Watch Online.*Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

x2=x3=x4=x5=0
y2=y3=y4=y5=0

single_mode := True
video_provider = 2
If (video_provider = 2)   ; openload.co or openload.io
{
    provider_name := "openload"
    download_page_wintitle = .*openload - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    image0 := "openload\episode list - next episode.png", x0:=30, y0:=10
    image1 := "*5 openload\episode list - found - yellow.png", x2:=30, y2:=0
    image2 := "*5 openload\episode list - found - orange.png", x2:=30, y2:=0
    image3 := "openload\episode page - watch.png", x3:=60, y3:=2
    image4 := "openload\video page - were sorry.png", x4:=0, y4:=0
    image5 := "openload\dowload page - download.png", x5:=40, y5:=5   
    image7 := "openload\dowload page - free download.png", x7:=30, y7:=10

    ; image6 := "openload\dowload page - download2.png", x6:=30, y6:=10
    ; image8 := "openload\next episode page - more links.png", x8:=30, y8:=10
}
; win_title := download_page_wintitle

WinActivate, %win_title%
WinWaitActive, %win_title%,,3
If ErrorLevel
    error_handler("Browser page is not active:`n`n" win_title, True, win_title)

STARTNEXT:
;----------
; Image 0
;----------
if not single_mode
{
    ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image0%
    If (ErrorLevel > 0)
        error_handler(image0 " (image0): " ErrorLevel, False, win_title)
    Else
    {
        MouseMove, x+x0, y+y0
        Click
        Sleep 2000
    }
}

;----------
; Image 1+2
;----------
SendInput ^{Home}
SendInput ^f
Sleep 200
SendInput %provider_name%{Enter}
Sleep 200
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image1%
If (ErrorLevel = 0)
    Goto CONTINUE_PROCESSING
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image2%
If (ErrorLevel > 0)
    error_handler(image2 " (image2): " ErrorLevel, False, win_title)

CONTINUE_PROCESSING:
MouseMove, x+x2, y+y2
Click
Sleep 2000

;----------
; Image 3
;----------
Sleep 200
MouseMove, 10,10
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image3%
If ErrorLevel
    error_handler(image3 " (image3): " ErrorLevel, False, win_title)
MouseMove, x+x3, y+y3
Click
Sleep 2000
SendInput !{Left}
Sleep 2000
MouseMove, x+x3, y+y3
Click
Sleep 3000

;----------
; Image 4
;----------
if image4
{
    ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image4%
    If (ErrorLevel = 0)
    {
        ; error_handler("Download not available:`n" image4 ": " ErrorLevel, False, win_title)
        SendInput ^w
        Sleep 200
        SendInput !{left}
        Sleep 2000
        Goto STARTNEXT
    }
}

;----------
; Image 5
;----------
Sleep 2000
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image5%
If ErrorLevel
    error_handler(image5 " (image5): " ErrorLevel, False, download_page_wintitle)
Else
{
    MouseMove, x+x5, y+y5
    Click
}

;----------
; Image 7
;----------
Sleep 8000
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image7%
If ErrorLevel
    error_handler(image7 " (image7): " ErrorLevel, False, win_title)
Else
{
    MouseMove, x+x7, y+y7
    Click
    Sleep 200
    Click
    Sleep 200
    Click
    Sleep 2000
    SendInput ^w
    Sleep 2000
    SendInput !{Left}
    if not single_mode
    {
        Sleep 3000
        Goto STARTNEXT
    }
}

ExitApp

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

^+x::ExitApp
