/* 

Browser zoom level should %125

*/
#SingleInstance Force
OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
SetTitleMatchMode RegEx
win_title = ^Watch.*?- Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title%
WinWaitActive, %win_title%
WinMaximize
; SendInput {PgDn}
; Sleep 100

; ad2 - the ad that pops up at start or during playback when video is not fullscreen
find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
    , "*2 GoWatchSeries - small screen maximixed - zoom125 - ad2 - close button.png"
    , "ad #2", 0, 0, 100)

; ad3 - the ad that's at bottom of screen when video is not fullscreen)
; find_and_click_button(1200, 800, 1260, 870
    ; , "*100 *TransBlack GoWatchSeries - small screen maximized - zoom125 - ad3 - close button.png"
    ; , "ad #3", 0, 0, 100)
Click 1255, 865

; start button
; find_and_click_button(600, 200, A_ScreenWidth, A_ScreenHeight
    ; , "*2 GoWatchSeries - small screen maximized - zoom125 - start button.png"
    ; , "start", 18, 11, 3000)
find_and_click_button(400, 300, 800, 900
    , "*30 GoWatchSeries - small screen maximized - zoom125 - start button.png"
    , "start", 15, 0, 3000)

; WinRestore
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

ExitApp


find_and_click_button(p_x, p_y, p_w, p_h, p_image, p_button_name, p_x_offset, p_y_offset, p_sleep)
{
    x := 0
    y := 0
    save_coords := x "," y
    ErrorLevel := 0
    countx := 0
    While (ErrorLevel = 0) and countx < 5
    {
        countx++
        ImageSearch, x, y, %p_x%, %p_y%, %p_w%, %p_h%, %p_image% 
        If (ErrorLevel = 0)
        {
            save_coords := x "," y
            OutputDebug, % p_button_name ": " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel
            MouseMove, x+%p_x_offset%, y+%p_y_offset%
            Click
            Sleep %p_sleep%
        }
    }
    OutputDebug, % p_button_name ": " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel
    Return
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