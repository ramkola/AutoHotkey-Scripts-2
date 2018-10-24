#SingleInstance Force
SetTitleMatchMode RegEx
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\WatchEpisodeSeries

win_title = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
win_title = Celebrity Big Brother Season \d+ Episode \d+ [s|S]\d+[e|E]\d+ Watch Online.*Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

x2=x3=x4=x5=0
y2=y3=y4=y5=0
video_provider = 1

If (video_provider = 1)   ; vshare.eu
{
    proceed_to_video_wintitle = Download celebrity big brother.*Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    image1 := "*5 *Trans0xFFFF00 vshare\episode list - found - yellow - vshare.eu.png", x2:=30, y2:=5
    image2 := "*5 vshare\episode list - found - orange - vshare.eu.png", x2:=30, y2:=5
    image3 := "*5 vshare\episode page - watch - vshare.eu.png", x3:=30, y3:=5
    image4 := "*5 vshare\video page - proceed to video.png", x4:=30, y4:=5
    image5 := "*TransBlack vshare\video page - play button.png", x5:=5, y5:=6
}

If (video_provider = 2)   ; openload.co
{
    image0 := "openload\episode list - next episode.png", x0:=30, y0:=10
    image1 := "*5 openload\episode list - found - yellow.png", x2:=30, y2:=0
    image2 := "*5 openload\episode list - found - orange.png", x2:=30, y2:=0
    image3 := "openload\episode page - watch.png", x3:=0, y3:=0
    image4 := "", x4:=0, y4:=0
    image5 := "*TransBlack openload\video page - play button.png", x5:=7, y5:=8

    imageA := "openload\next episode page - more links.png", xA:=30, yA:=10
}

WinActivate, %win_title%
WinWaitActive, %win_title%,,3
If ErrorLevel
    error_handler("Browser page is not active:`n`n" win_title, True, win_title)

;----------
; Image 1+2
;----------
SendInput ^{Home}
SendInput ^f
Sleep 200
SendInput vshare.eu{Enter}
Sleep 200
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image1%
If (ErrorLevel = 0)
    Goto CONTINUE_PROCESSING
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image2%
If (ErrorLevel > 0)
    error_handler(image2 ": " ErrorLevel, False, win_title)

CONTINUE_PROCESSING:
MouseMove, x+x2, y+y2
Click
Sleep 2000

;----------
; Image 3
;----------
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image3%
If ErrorLevel
    error_handler(image3 ": " ErrorLevel, False, win_title)
MouseMove, x+x3, y+y3
Click
Sleep 2000
SendInput !{Left}
Sleep 200
MouseMove, x+x3, y+y3
Click
Sleep 5000
;----------
; Image 4
;----------
if image4
{
    MouseMove, 100, 100
    ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image4%
    If ErrorLevel
        error_handler(image4 ": " ErrorLevel, False, proceed_to_video_wintitle)
    Else
    {
        MouseMove, x+x4, y+y4
        Click
    }
    Sleep 2000
}
;----------
; Image 5
;----------
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight, %image5%
If ErrorLevel
    error_handler(image5 ": " ErrorLevel, False, win_title)
Else
{
    MouseMove, x+x5, y+y5
    Click
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