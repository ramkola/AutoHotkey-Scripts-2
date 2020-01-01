/* 


*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\pango_level.ahk
#Include lib\trayicon.ahk
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\crazyshit.png
Menu, Tray, Add, Start CS, START_CS
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetTitleMatchMode RegEx
OutputDebug, DBGVIEWCLEAR
; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\CrazyShit

If Not pango_level(80) 
{
    MsgBox, 48,, % "Aborting....Could not set Pango to the required level (80)."
    Return
}

CS_START:
auto_play := True
autoplay_paused := False
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
; ImageSearch, x, y, A_ScreenWidth * 0.6, A_ScreenHeight * 0.1, A_ScreenWidth * 0.8, A_ScreenHeight * 0.5,*2 Zoom 100 Pango 80 - next button1.png
ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 Zoom 100 Pango 80 - next button2.png
If (ErrorLevel = 0)
{
    MouseMove, x+10, y+10
    Click
    OutputDebug, %  "Next Button: " x "," y " - countx: " countx " - ErrorLevel: " ErrorLevel 
    Sleep 2000
}
Else
{
    OutputDebug, % "Next button not found."
    MsgBox, 48,, % "Next button not found."
    Return
}
; -------------------------------------
; find and click: start button
; -------------------------------------
Sleep 1500
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
    Sleep 500
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
    eov_minutes := 5        ; max minutes to check for end of video (eov_)
    eov_check_interval := 1000
    ; 5 minutes = 300000 milliseconds ---> 5 * 60 * 1000 = 300000 
    max_retries := (eov_minutes * 60 * 1000) / eov_check_interval
    retry_count := 1
    If not autoplay_paused
        SetTimer, CHECK_FOR_END_VIDEO, %eov_check_interval%
    Else
        SetTimer, CHECK_FOR_END_VIDEO, Off
}

Return

; =============================================================================

CHECK_FOR_END_VIDEO:
    If !WinActive(crazyshit_wintitle)
        Return  ; wait for user to either activate the page or exit this program manually.
    ImageSearch, x, y, A_ScreenWidth * .7, A_ScreenHeight *.7, A_ScreenWidth, A_ScreenHeight ,*2 Zoom 100 Pango 80 - end of video screen.png
    If ErrorLevel
    {
        ; OutputDebug, % "Failed on search 1. Trying search 2", 1
        ImageSearch, x, y, A_ScreenWidth * .7, A_ScreenHeight *.7, A_ScreenWidth, A_ScreenHeight ,*2 Zoom 100 Pango 80 - end of video screen2.png
        If ErrorLevel
        {
            If (retry_count <= max_retries)
            {
                ; OutputDebug, % "Failed on search 2. Retry #" retry_count
                retry_count++
            }
            Else
            {   
                msg := A_ThisLabel " - " A_ScriptName "`r`n`r`n"
                    .  "ImageSearch didn't find end of video.`r`n"
                    .  "Either eov_minutes wasn't long enough for this video or`r`n"
                    .  "ImageSearch has stopped working."
                OutputDebug, % msg
                MsgBox, 48,, % msg
                SetTimer, CHECK_FOR_END_VIDEO, Off
                WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
            }
            Return
        }
    }
    ; end of video found 
    SetTimer, CHECK_FOR_END_VIDEO, Off
    SendInput {Escape}  ; get out of fullscreen video
    Goto CS_START     ;Reload

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

PgDn:: Goto CS_START    ;Reload

t:: display_title()

^!+p:: Pause   ; the script

p:: 
    autoplay_paused := !autoplay_paused
    msg := autoplay_paused ? "OFF" : "ON"
    MsgBox, 48,, % "Autoplay is " msg, 3
    SetTimer, CHECK_FOR_END_VIDEO, %msg%
    Return
    
m::     ; Toggle mute
    MouseMove 10, 0                             ; move mouse around so that 
    MouseMove, A_ScreenWidth/2,A_ScreenHeight/2 ; sound button appears
    Sleep 200
    Click 60, 1006
    Return

RAlt::  ; used for debugging
    
    ImageSearch, x, y, A_ScreenWidth * .7, A_ScreenHeight *.7, A_ScreenWidth, A_ScreenHeight ,*2 Zoom 100 Pango 80 - end of video screen1.png
    If ErrorLevel
    {
        MsgBox, 48,, % "Failed on search 1. Trying search 2", 1
        ImageSearch, x, y, A_ScreenWidth * .7, A_ScreenHeight *.7, A_ScreenWidth, A_ScreenHeight ,*2 Zoom 100 Pango 80 - end of video screen2.png
        If ErrorLevel
            MsgBox, 48,, % "Failed on search 2. Aborting."
        Else
            MsgBox % "Success on search 2."
    }
    Else
        MsgBox % "Success on search 1."

    Return

^+k:: list_hotkeys()    