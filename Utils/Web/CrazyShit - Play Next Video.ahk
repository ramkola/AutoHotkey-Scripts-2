/* 


*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\crazyshit.png
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
Menu, Tray, Add, Start CS, START_CS
SetTitleMatchMode RegEx
OutputDebug, DBGVIEWCLEAR
; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\CrazyShit

auto_play := True
click_fullscreen := True

crazyshit_wintitle = ^CrazyShit.com | .* - Crazy Shit! - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe 
WinActivate, %crazyshit_wintitle%
WinWaitActive, %crazyshit_wintitle% 
WinMaximize, %crazyshit_wintitle%
If click_fullscreen
{
    SendInput {Escape}
    Sleep 500
}
SendInput ^{Home}
Sleep 100
; -------------------------------------
; find and click: next button
; -------------------------------------
ImageSearch, x, y, A_ScreenWidth * 0.6, A_ScreenHeight * 0.1, A_ScreenWidth * 0.8, A_ScreenHeight * 0.5,*2 Zoom 100 Pango 80 - next button.png
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
Click 470, 470
/* ImageSearch, x, y, A_ScreenWidth * 0.4, A_ScreenHeight * 0.45, A_ScreenWidth * 0.45, A_ScreenHeight * 0.5,*2 Zoom 100 Pango 80 - start button.png
If (ErrorLevel = 0)
{
    MouseMove, x+8, y+11
    Click
    SendInput {Enter}
    OutputDebug, %  "Start Button: " x "," y " - countx: " countx " - ErrorLevel: " ErrorLevel
}
Else
    OutputDebug, % "Start button not found."
*/
;-------------------------------------
; find and click: fullscreen button
;-------------------------------------
If click_fullscreen
{
    MouseMove 10, 0                             ; move mouse around so that 
    MouseMove, A_ScreenWidth/2,A_ScreenHeight/2 ; fullscreen button appears
    Sleep 200
    ImageSearch, x, y, A_ScreenWidth * 0.5, A_ScreenHeight * 0.5, A_ScreenWidth * 0.8, A_ScreenHeight * 0.8,*50 *TransBlack Zoom 100 Pango 80 - fullscreen button.png
    If (ErrorLevel = 0)
    {
        MouseMove, x+5, y+7
        Click
        OutputDebug, %  "Fullscreen Button: " x "," y " - countx: " countx " - ErrorLevel: " ErrorLevel
    }
    Else
    {
        Click 820, 664
        OutputDebug, % "Fullscreen button not found."
    }
}

display_title()
If auto_play
{
    max_retries = 200
    ErrorLevel = 9999
    While ErrorLevel and countx < max_retries
    {
        ImageSearch, x, y, A_ScreenWidth * .7, A_ScreenHeight *.7, A_ScreenWidth, A_ScreenHeight ,*2 Zoom 100 Pango 80 - end of video screen.png
        Sleep 1000
        countx++
    }
    If (ErrorLevel = 0 ) and (countx < max_retries)
        Reload
    Else    
        OutputDebug, % "ErrorLevel: " ErrorLevel " - countx: " countx
}

Return

; =============================================================================

display_title()
{
    WinGetActiveTitle, active_title
    at := RegExReplace(active_title, "i)^CrazyShit.com \| (.*) - Crazy Shit! - Google Chrome$", "$1")
    ToolTip , %at%, 5, 5
    Sleep 5000
    ToolTip
    Return    
}

START_CS:
    Run, https://www.crazyshit.com/

#If WinActive(crazyshit_wintitle)
PgDn:: Reload
t:: display_title()
p:: Pause
m::     ; Toggle mute
    MouseMove 10, 0                             ; move mouse around so that 
    MouseMove, A_ScreenWidth/2,A_ScreenHeight/2 ; sound button appears
    Sleep 200
    Click 60, 1006
    Return
/*     
    ImageSearch, x, y, 0, A_ScreenHeight * 0.8, A_ScreenWidth * 0.4, A_ScreenHeight,*2 *TransBlack Zoom 100 Pango 80 - sound on button.png   
    If (ErrorLevel = 0)
        MouseMove, x, y
    Else
    {
        ImageSearch, x, y, 0, A_ScreenHeight * 0.8, A_ScreenWidth * 0.4, A_ScreenHeight,*2 *TransBlack Zoom 100 Pango 80 - sound off button.png   
        If (ErrorLevel = 0)
            MouseMove, x, y
    }
    If (ErrorLevel = 0)
        Click
    Else
        OutputDebug, % "Could not find any sound button. ErrorLevel: " ErrorLevel
    
    Return

*/
