/* 
    Monitor resolution is 1280 x 1024
    Browser zoom level should be %100 Pango %80 for imagesearch to work
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
SetTitleMatchMode RegEx

; OutputDebug, DBGVIEWCLEAR

; wintitle examples:
;    Watch Chicago Fire - Season 2 Episode 8 English subbed - Watchseries - Google Chrome
;    Watch The Voice UK - Season 8 Episode 3- Blind Auditions 3 English subbed - Watchseries - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
win_title = ^Watch.*Season \d{1,2} Episode \d{1,3}.*Watchseries - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title%
WinWaitActive, %win_title%,,2

; check if video is in fullscreen or not
MouseGetPos,,,,control_classnn
If (A_Args[1] == "")
    full_screen := (control_classnn = "Intermediate D3D Window1") 
Else
    full_screen := A_Args[1]
OutputDebug, % "A_Args[1]: " A_Args[1] " - full_screen: " full_screen " - control_classnn: " control_classnn
;
; position browser to allow imagesearch to work more consistently 
WinMaximize, %win_title%
SendInput {Home}
Sleep 10
; Click 550, 150      ; take focus off video player by clicking on blank space on 
; SendInput {Down 6}  ; page so that down key will scroll instead of lowering volume.
; Sleep 100

; ; ad2 - the ad that pops up at start or during playback when video is not fullscreen
; find_and_click_button(250, 350, 290, 700
    ; , "*75 GoWatchSeries - small screen maximixed - zoom125 - ad2 - close button.png"
    ; , "ad #2", 0, 0, 100, win_title)

; ; ad3 - the ad that's at bottom of screen when video is not fullscreen)
; find_and_click_button(1200, 825, 1262, 880
    ; , "*100 *TransBlack GoWatchSeries - small screen maximized - zoom125 - ad3 - close button.png"
    ; , "ad #3", 0, 0, 100, win_title)

; ; start button
; find_and_click_button(400, 400, 600, 600
    ; , "*100 GoWatchSeries - small screen maximized - zoom125 - start button.png"
    ; , "start", 18, 11, 3000, win_title)

countx := 1 
retries := 5
streamango_failed := True
While streamango_failed And (countx <= retries)
{
    MouseMove, 0, 0
    ; find server menu and click it
    xy_result := find_and_click_button(A_ScreenWidth * .5 , 0, A_ScreenWidth, A_ScreenHeight *.5
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 80 - menu button.png"
        , "Server Menu", 10, 5, 10
        , win_title, 5, True, False)

    ; find Streamango server menu option and click it
    xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 80 - menu Streamango.png"
        , "Streamango", 10, 1, 10
        , win_title, 5, True, False)

    streamango_failed := xy_result[1] + xy_result[2] = 0 
    countx++
    Sleep 100
}
If streamango_failed and countx > retries
    OutputDebug, % "Couldn't click Streamango menu server button"

; find Streamango Start button and click it
xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
    , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 80 - Streamango Start Button.png"
    , "Streamango Start Button", 3, 3, 1500
    , win_title, 10, True, True)
OutputDebug, % "Streamango start button xy_result: " xy_result[1] "," xy_result[2]

If full_screen
{
    OutputDebug, % "FULLSCREEN WAS EXECUTED"
    SendInput f     ;   play video in fullscreen
}
; Else
; {
    ; ; ad4 - the ad that's at bottom of screen when video is not fullscreen)
    ; SendInput {Down 4}  ; scroll video player to top of page
    ; find_and_click_button(400, 400, 500, 800
        ; , "*100 GoWatchSeries - small screen maximized - zoom125 - ad4 - close button.png"
        ; , "ad #4", 3, 1, 100, win_title)
        ; ; click 535, 585      ; close ad
; }
OutputDebug, % "Done"
ErrorLevel := 9999
While ErrorLevel
{
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    WinWaitActive, ahk_class dbgviewClass ahk_exe Dbgview.exe,,1
    If ErrorLevel
        OutputDebug, % "Trouble Activating Dbgview..."
    Sleep 100
}
OutputDebug, % "EXITAPP"
ExitApp


find_and_click_button(p_x1, p_y1, p_x2, p_y2, p_image
    , p_button_name, p_x_offset, p_y_offset, p_sleep
    , p_win_title, p_retry := 5, p_click := True, p_image_exists_after_click_error := False)
{
    MouseMove, 0, 0
    x := 0
        y := 0
    save_coords := x "," y
    ErrorLevel := 9999
    countx := 0
    While (ErrorLevel And countx <= p_retry)
    {
        countx++
        ImageSearch, x, y, %p_x1%, %p_y1%, %p_x2%, %p_y2%, %p_image% 
        If (ErrorLevel = 0)
        {
            save_coords := x+p_x_offset "," y+p_y_offset
            MouseMove, x+p_x_offset, y+p_y_offset
            If p_click
                Click
            Sleep %p_sleep%
            If Not WinActive(p_win_title)
            {
                OutputDebug, % p_win_title " - Aborting...Clicked on wrong button or link, wrong page is active"
                ExitApp
            }
            If p_image_exists_after_click_error
            {
                MouseMove, 0, 0
                ImageSearch, x, y, %p_x1%, %p_y1%, %p_x2%, %p_y2%, %p_image% 
                If (ErrorLevel = 0)
                    ErrorLevel = 9999   ; force retry
            }
        }
    }
    Return StrSplit(save_coords, ",")
}
; ;-------------------------------------
; ; find and click: orange bottom banner
; ;-------------------------------------
; x:=y:=countx:=ErrorLevel:=0
; ImageSearch, x, y, 900, 900, A_ScreenWidth,A_ScreenHeight, *2 GoWatchSeries - small screen - orange bottom banner.png
; If (ErrorLevel = 0)
; {
    
    ; Click 1049, 50  ; turn on page eraser  - chrome extension
    ; Sleep 300
    ; Click 1049, 955 ; orange bottom banner
    ; ; Click 1049, 50  ; turn off page eraser - chrome extension
; }

; OutputDebug, % "banner - ErrorLevel: " ErrorLevel

^+x::ExitApp
