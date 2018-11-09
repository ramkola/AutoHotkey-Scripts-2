#SingleInstance Force
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
SetTitleMatchMode RegEx
win_title = ^Watch.*?- Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title%
WinWaitActive, %win_title%

WinGetPos, x, y, w, h, A
MouseMove x+A_ScreenWidth/2, y+A_ScreenHeight/2
; MouseMove x+100,y+100
;-------------------------------------
; find and click: close ad button
;-------------------------------------
countx = 0  
ErrorLevel = 0 
While (ErrorLevel = 0) and countx < 5
{
    ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight,*TransBlack GoWatchSeries - ad - close button.png
    If (ErrorLevel = 0)
    {
        save_coords := x "," y
        MouseMove, x+10, y+10
        Click
    }
    countx++
}
OutputDebug, % "ad closes: " save_coords " - countx: " countx
;-------------------------------------
; find and click: start button
;-------------------------------------
countx = 0
ErrorLevel = 0 
While (ErrorLevel = 0) and countx < 5
{
    ; ImageSearch, x, y, A_ScreenWidth * 0.3, A_ScreenHeight * 0.3, A_ScreenWidth * 0.6, A_ScreenHeight * 0.7, *100 GoWatchSeries - small screen - video - start button.png
    ImageSearch, x, y, 0, 30, A_ScreenWidth,A_ScreenHeight, *2 GoWatchSeries - small screen - video - start button.png
    If (ErrorLevel = 0)
    {
        save_coords := x "," y
        MouseMove, x+18, y+11
        Click
        Sleep 3000
    }
    countx++ 
}
OutputDebug, % "start pos: " save_coords " - countx: " countx
;-------------------------------------
; fullscreen button
;-------------------------------------
; Sleep 3000
; SendInput f

ExitApp


^+x::ExitApp
