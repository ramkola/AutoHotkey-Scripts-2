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
play_serverhd := True
play_vidnode := False
play_xstreamcdn := False
play_streamango := False
OutputDebug, DBGVIEWCLEAR

; wintitle examples:
;    Watch Chicago Fire - Season 2 Episode 8 English subbed - Watchseries - Google Chrome
;    Watch The Voice UK - Season 8 Episode 3- Blind Auditions 3 English subbed - Watchseries - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
gowatchseries_wintitle = ^Watch.*Season \d{1,2} Episode \d{1,3}.*Watchseries - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %gowatchseries_wintitle%
WinWaitActive, %gowatchseries_wintitle%,,2

; check if video is in fullscreen or not
MouseGetPos,,,,control_classnn
If (A_Args[1] == "")
    full_screen := (control_classnn = "Intermediate D3D Window1") 
Else
    full_screen := A_Args[1]
OutputDebug, % "A_Args[1]: " A_Args[1] " - full_screen: " full_screen " - control_classnn: " control_classnn
;
; position browser to allow imagesearch to work more consistently 
WinMaximize, %gowatchseries_wintitle%
SendInput {Home}
Sleep 10
;---------------------
; start button
;---------------------
If play_serverhd or play_vidnode or play_xstreamcdn
    xy_result := find_and_click_button(400, 400, 600, 600
        , "*10 GoWatchSeries - small screen maximized - zoom100 Pango 80 - ServerHD Start Button.png"
        , "start", 20, 15, 3000, gowatchseries_wintitle, 20, True, True)
Else If play_streamango
    start_streamango(gowatchseries_wintitle)

; If full_screen
; {
    ; OutputDebug, % "FULLSCREEN WAS EXECUTED"
    ; SendInput f     ;   play video in fullscreen
; }
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, % "EXITAPP"
ExitApp

;=======================================================================

find_and_click_button(p_x1, p_y1, p_x2, p_y2, p_image
    , p_button_name, p_x_offset, p_y_offset, p_sleep
    , p_wintitle, p_retry := 5, p_click := True, p_image_exists_after_click_error := False)
{
    MouseMove, 0, 0
    x:=y:=countx:=0
    save_coords := x "," y
    ErrorLevel := 9999
    While (ErrorLevel And countx <= p_retry)
    {
        countx++
        ImageSearch, x, y, %p_x1%, %p_y1%, %p_x2%, %p_y2%, %p_image% 
        If (ErrorLevel = 0)
        {
            save_coords := x+p_x_offset "," y+p_y_offset
            MouseMove, x+p_x_offset, y+p_y_offset
            If p_click
            {
                SendInput {Click, Left}
                OutputDebug, % "Click: " countx
            }
            Sleep %p_sleep%
            If Not WinActive(p_wintitle)
            {
                OutputDebug, % p_wintitle " - Aborting...Clicked on wrong button or link, wrong page is active"
                ExitApp
            }
            ; if image not disappearing after clicking it 
            ; is considered an error then retry clicking it.
            If p_image_exists_after_click_error
            {
                MouseMove, 0, 0
                ImageSearch, x, y, %p_x1%, %p_y1%, %p_x2%, %p_y2%, %p_image% 
                If (ErrorLevel = 0)
                    ErrorLevel = 9999   ; force retry
            }
        }
    }
    OutputDebug, % save_coords " " countx
    Return StrSplit(save_coords, ",")
}

start_streamango(p_wintitle)
{
    countx := 1 
    retries := 5
    streamango_failed := True
    While streamango_failed And (countx <= retries)
    {
        xy_result := select_server("Streamango", p_wintitle)
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
        , p_wintitle, 10, True, True)
    OutputDebug, % "Streamango start button xy_result: " xy_result[1] "," xy_result[2]
}

select_server(p_server_name,p_wintitle)
{
    If (p_server_name == "") Or (p_wintitle == "")
    {
        OutputDebug, % "p_server_name: " p_server_name
        OutputDebug, % "p_wintitle: " p_wintitle
        Return
    }
        
    MouseMove, 0, 0
    ; find server menu and click it
    xy_result := find_and_click_button(A_ScreenWidth * .5 , 0, A_ScreenWidth, A_ScreenHeight *.5
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 80 - menu button.png"
        , "Server Menu", 10, 5, 10
        , p_wintitle, 5, True, False)

    ; find Streamango server menu option and click it
    xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 80 - menu Streamango.png"
        , "Streamango", 10, 1, 10
        , p_wintitle, 5, True, False)
    Return xy_result
}
^+x::ExitApp