#SingleInstance Force
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\kaotic.png
SetTitleMatchMode RegEx

OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\Kaotic

click_fullscreen := True

; Robber becomes a victim in seconds - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
win_title = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe 
WinActivate, %win_title%
WinWaitActive, %win_title% 
If click_fullscreen
{
    SendInput {Escape}
    Sleep 500
}
SendInput ^{Home}
Sleep 500
; -------------------------------------
; find and click: next button
; -------------------------------------
ImageSearch, x, y, A_ScreenWidth * 0.5, A_ScreenHeight * 0.1, A_ScreenWidth * 0.8, A_ScreenHeight * 0.5,*50 Kaotic - video - next button.png
If (ErrorLevel = 0)
{
    MouseMove, x+10, y+10
    Click
    OutputDebug, %  "Next Button: " x "," y " - countx: " countx " - ErrorLevel: " ErrorLevel
    Sleep 2000
}
Else
    OutputDebug, % "Next button not found."
; -------------------------------------
; find and click: start button
; -------------------------------------
ImageSearch, x, y, A_ScreenWidth * 0.3, A_ScreenHeight * 0.4, A_ScreenWidth * 0.5, A_ScreenHeight * 0.6,*30 Kaotic - video - start button.png
If (ErrorLevel = 0)
{
    ; MouseMove, x+8, y+11
    MouseMove, x, y
    Click
    SendInput {Enter}
    OutputDebug, %  "Start Button: " x "," y " - countx: " countx " - ErrorLevel: " ErrorLevel
}
Else
    OutputDebug, % "Start button not found."

MouseMove 10,0
;-------------------------------------
; find and click: fullscreen button
;-------------------------------------
If click_fullscreen
{
    MouseMove, A_ScreenWidth/2,A_ScreenHeight/2
    Sleep 100
    ; ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*50 CrazyShit - video - fullscreen button.png
    ImageSearch, x, y, A_ScreenWidth * 0.5, A_ScreenHeight * 0.5, A_ScreenWidth * 0.8, A_ScreenHeight * 0.8,*60 Kaotic - video - fullscreen button.png
    If (ErrorLevel = 0)
    {
        MouseMove, x+7, y+6
        Click
        OutputDebug, %  "Fullscreen Button: " x "," y " - countx: " countx " - ErrorLevel: " ErrorLevel
    }
    Else
        OutputDebug, % "Fullscreen button not found."
}

; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
ExitApp

^+x::ExitApp
