/* 
Monitor resolution is 1280 x 1024
Browser zoom level should be %125 for imagesearch to work
*/
#SingleInstance Force
OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
SetTitleMatchMode RegEx
win_title = ^Watch.*?- Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title%
WinWaitActive, %win_title%

; check if video is in fullscreen or not
MouseGetPos,,,,control_classnn
If (A_Args[1] == "")
    full_screen := (control_classnn = "Intermediate D3D Window1") 
Else
    full_screen := A_Args[1]
OutputDebug, % "A_Args[1]: " A_Args[1] " - full_screen: " full_screen " - control_classnn: " control_classnn
;
; position browser to allow imagesearch to work more consistently 
WinMaximize
SendInput {Home}
Sleep 10
Click 550, 150      ; take focus off video player by clicking on blank space on 
SendInput {Down 6}  ; page so that down key will scroll instead of lowering volume.

; ad2 - the ad that pops up at start or during playback when video is not fullscreen
find_and_click_button(250, 350, 290, 700
    , "*75 GoWatchSeries - small screen maximixed - zoom125 - ad2 - close button.png"
    , "ad #2", 0, 0, 100, win_title)

; ad3 - the ad that's at bottom of screen when video is not fullscreen)
find_and_click_button(1200, 825, 1262, 880
    , "*100 *TransBlack GoWatchSeries - small screen maximized - zoom125 - ad3 - close button.png"
    , "ad #3", 0, 0, 100, win_title)

; start button
find_and_click_button(600, 500, 700, A_ScreenHeight
    , "*75 GoWatchSeries - small screen maximized - zoom125 - start button.png"
    , "start", 18, 11, 3000, win_title)

; find server menu location so that we know where video player is to set focus on player.
; server menu - top right corner of video screen when not in fullscreen mode.
xy_result := []
xy_result := find_and_click_button(1190, 420, A_ScreenWidth, 600
    , "*150 GoWatchSeries - small screen mazimized - zoom125 - menu button.png"
    , "menu ", 30, 20, 0, win_title, 1, False)
MouseMove, xy_result[1] - 100, xy_result[2]
OutputDebug, % "xy_result: " xy_result[1] - 100 "," xy_result[2]
Click   ; set focus on video player so that hotkeys and keyboard shortcuts work on it and not surrounding page.
Click   ; setting focus by clicking player stops playing video so click it again to play.

WinRestore
if full_screen
    SendInput f ;   play video in fullscreen

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
ExitApp


find_and_click_button(p_x, p_y, p_w, p_h, p_image
    , p_button_name, p_x_offset, p_y_offset, p_sleep
    , p_win_title, p_retry := 5, p_click := True)
{
    x := 0
    y := 0
    save_coords := x "," y
    ErrorLevel := 0
    countx := 0
    While (ErrorLevel = 0) and countx < p_retry
    {
        countx++
        ImageSearch, x, y, %p_x%, %p_y%, %p_w%, %p_h%, %p_image% 
        If (ErrorLevel = 0)
        {
            save_coords := x+p_x_offset "," y+p_y_offset
            MouseMove, x+p_x_offset, y+p_y_offset
            if p_click
                Click
            Sleep %p_sleep%
            OutputDebug, % p_button_name ": " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel " - click #" countx
            if Not WinActive(p_win_title)
            {
                OutputDebug, % "Aborting...Clicked on wrong button or link, wrong page is active."
                ExitApp
            }
        }
    }
    OutputDebug, % p_button_name ": " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel
    Return strsplit(save_coords, ",")
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