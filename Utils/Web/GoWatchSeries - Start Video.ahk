/* 

Browser zoom level should %125

*/

#SingleInstance Force
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
SetTitleMatchMode RegEx
win_title = ^Watch.*?- Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title%
WinWaitActive, %win_title%
WinMaximize

;-------------------------------------
; find and click: close ad button #2 
; (the ad that pops up during playback when video is not fullscreen)
;-------------------------------------
x:=y:=countx:=ErrorLevel:=0
While (ErrorLevel = 0) and countx < 5
{
    ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight,*2 GoWatchSeries - small screen - ad2 - close button.png
    If (ErrorLevel = 0)
    {
        save_coords := x "," y
        MouseMove, x+10, y+10
        Click
        Sleep 100
    }
    countx++
}
OutputDebug, % "ad #2: " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel

;-------------------------------------
; find and click: close ad button #3 
; (the ad that's at bottom of screen when video is not fullscreen)
;-------------------------------------

Click 1258,861

x:=y:=countx:=ErrorLevel:=0
OutputDebug, % "ad #3: " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel
While (ErrorLevel = 0) and countx < 5
{
    ImageSearch, x, y, 900, 900, A_ScreenWidth,A_ScreenHeight,*100 GoWatchSeries - small screen - ad3 - close button.png
    If (ErrorLevel = 0)
    {
        save_coords := x "," y
        MouseMove, x, y
        Click
        Sleep 100
    }
    countx++
}
OutputDebug, % "ad #3: " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel

;-------------------------------------
; find and click: start button
;-------------------------------------
x:=y:=countx:=ErrorLevel:=0
While (ErrorLevel = 0) and countx < 5
{
    ImageSearch, x, y, 0, 200, A_ScreenWidth,A_ScreenHeight, *2 GoWatchSeries - small screen - video - start button.png
    If (ErrorLevel = 0)
    {
        save_coords := x "," y
        MouseMove, x+18, y+11
        ; Click
        ; Sleep 3000
    }
    countx++ 
}
OutputDebug, % "start btn: " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel


;-------------------------------------
; find and click: orange bottom banner
;-------------------------------------
x:=y:=countx:=ErrorLevel:=0
ImageSearch, x, y, 900, 900, A_ScreenWidth,A_ScreenHeight, *2 GoWatchSeries - small screen - orange bottom banner.png
If (ErrorLevel = 0)
{
    
    Click 1049, 50  ; turn on page eraser  - chrome extension
    Sleep 300
    Click 1049, 955 ; orange bottom banner
    ; Click 1049, 50  ; turn off page eraser - chrome extension
}

OutputDebug, % "banner - ErrorLevel: " ErrorLevel




; WinRestore
ExitApp