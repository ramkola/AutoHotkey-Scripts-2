#SingleInstance Force
#Persistent
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
SetTitleMatchMode RegEx
; Watch Chicago Fire - Season 2 Episode 8 English subbed - Watchseries - Google Chrome
win_title = ^Watch.*? - Season \d+ Episode \d+ .* - Watchseries - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
win_title = ahk_exe i_view32.exe
WinActivate, %win_title%
WinWaitActive, %win_title%

; SetTimer, CLOSE_AD5, 30000
SetTimer, CLOSE_AD5, 3000

CLOSE_AD5:
    ; ad5 - the ad that pops up at start or during playback when video is not fullscreen
    ; find_and_click_button(150, 150, 250, 250
    find_and_click_button(0,0,1000,1000
        , "*20 GoWatchSeries - small screen restored - zoom125 - ad5 - close button.png"
        , "ad #5", 10, 10, 100, win_title)


WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
Return


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