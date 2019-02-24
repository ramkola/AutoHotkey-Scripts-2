#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_ROOT_DIR%
StringCaseSense Off
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\youtube.png
Menu, Tray, Add
Menu, Tray, Add, Start GoWatchSeries, START_GOWATCHSERIES
Menu, Tray, Add, Start Youtube, START_YOUTUBE
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Monitor Sleep, MONITOR_SLEEP
g_TRAY_SUSPEND_ON_LEFTCLICK := True ; see lib\utils.ahk

SetTitleMatchMode RegEx
; see MyHotKeys.ahk youtube section for setting active windows.
If (A_Args[1] == "")
    A_Args[1] := ".*YouTube - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"

#If WinActive(A_Args[1]) or WinActive(A_Args[2]) or WinActive(A_Args[3])

youtube_wintitle = .*YouTube - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
watchseries_wintitle = i).*Watch\s?Series - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
; tetris_wintitle = .*Tetris.* - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
countx := 1
While (A_Args[countx] != "")
{
    win_title%countx% := RegExReplace(A_Args[countx], "(^.*?)\sahk_class.*", "$1")
    ; OutputDebug, % "win_title" countx ": "  win_title%countx%
    countx++
}

Return

;=======================================================
; closes unwanted redirect windows when links and buttons are clicked on GoWatchSeries.com
!LButton::
~LButton:: 
{ 
    If (A_ThisHotkey =  "!LButton")
    {
        Send {Click, Left}
        Return
    }
    SetCapsLockState, AlwaysOff
    Sleep 1   ; allow leftclick to activate other windows
    WinGetActiveTitle, aw
    OutputDebug, % "aw0: " aw
    If Not WinActive(watchseries_wintitle) 
        Return

    countx := 1
    While WinActive(watchseries_wintitle) and (countx < 100)
    {
        WinGetActiveTitle, aw
        OutputDebug, % "aw1: " aw
        Sleep 10
        countx++
    }
    OutputDebug, % "countx #1: " countx

    countx := 1
    While Not WinActive(watchseries_wintitle) and (countx < 10)
    {
        WinGetActiveTitle, aw
        OutputDebug, % "aw2: " aw
        SendInput ^w  
        Sleep 100
        countx++
    }   
    OutputDebug, % "A_ThisHotkey: " A_ThisHotkey " - countx: " countx
    Return
}

+RButton:: 
^!+y:: 
    ExitApp
    Return

CapsLock & Break::  ; Set focus on video
    If WinActive(youtube_wintitle)
    {
        SetCapsLockState, AlWaysOff
        Click, 400, 300
        Sleep 500
        Click, 400, 300
    }
    Return

RButton & WheelUp:: 
RButton & WheelDown::
RButton & MButton::
^WheelUp::
^WheelDown::
+WheelUp::
+WheelDown::
WheelUp::
WheelDown::
.::
,::
MButton::
RButton::
n::
{
    hovering := False
    countx := 1
    While (win_title%countx% != "")
    {
        If mouse_hovering(win_title%countx%)
        {
            hovering := True
            Break
        }
        Else
            countx++
    }
    ;
    If hovering
    {
        OutputDebug, % "A_ThisHotkey: " A_ThisHotkey

        If (A_ThisHotkey = "WheelUp")
            SendInput {Right}   ; seek video forward 5 secs
        Else If (A_ThisHotkey = "WheelDown")
            SendInput {Left}    ; seek video backward 5 secs
        Else If (A_ThisHotkey = "+WheelUp") Or (A_ThisHotkey = ".")
            SendInput l        ; seek video forward 10 secs
        Else If (A_ThisHotkey = "+WheelDown")  Or (A_ThisHotkey = ",")
            SendInput j        ; seek video backward 10 secs
        Else If (A_ThisHotkey = "^WheelUp")
            SendInput {PgUp}    ; scroll_page(x,y,x2,"{PgUp}")
        Else If (A_ThisHotkey = "^WheelDown")
            SendInput {PgDn}    ; scroll_page(x,y,x2,"{PgDn}")
        Else If (A_ThisHotkey = "MButton") Or (A_ThisHotkey = "n") 
        {
            WinGetActiveTitle, active_win
            ; skip to next video
            If WinActive(youtube_wintitle)
                SendInput +n    
            Else If WinActive(watchseries_wintitle)
                SendInput ^!+{PgDn}
            Else
                ListVars
        }
        Else If (A_ThisHotkey = "RButton & MButton")
            SendInput +p        ; skip to previous video
        Else If (A_ThisHotkey = "RButton")
            SendInput f         ; toggle fullscreen
        Else If (A_ThisHotkey = "RButton & WheelUp")
            SendInput {Up}      ; volume up
        Else If (A_ThisHotkey = "RButton & WheelDown")
            SendInput {Down}  ; volume down
        Else
            OutputDebug, % "Unexpected hotkey: " A_ThisHotkey
    }
    Else
    {
            OutputDebug % "Not hovering any pages."
    }
Return
}

;=======================================================
START_YOUTUBE:
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
    WinWaitActive, Google - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,5
    Run, https://www.youtube.com
    Return

START_GOWATCHSERIES:
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
    WinWaitActive, Google - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,5
    Run, https://ww5.gowatchseries.co
    Return

MONITOR_SLEEP:
    Run, "C:\Users\Mark\Desktop\Turn Off Monitor.ahk.lnk"
    Return
