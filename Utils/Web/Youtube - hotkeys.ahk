#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#Include lib\misc.ahk
#Include lib\strings.ahk
#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_ROOT_DIR%
StringCaseSense Off
SetTitleMatchMode RegEx
; g_TRAY_SUSPEND_ON_LEFTCLICK := True ; see lib\utils.ahk
; g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\youtube.png
Menu, Tray, Add
Menu, Tray, Add, Start GoWatchSeries, START_GOWATCHSERIES
Menu, Tray, Add, Start Youtube, START_YOUTUBE
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, Monitor Sleep, MONITOR_SLEEP

ttip(A_ScriptName " is running.", 1500)
lbutton_switch := rbutton_switch wheel_switch := True
; It's enough if mouse is hovering over an eligible window. That window does not have to
; be active to receive the hotkey. It will become active if necessary.
eligible_wintitle = i).*(YouTube|WatchSeries|DailyMotion).*Chrome

#If mouse_hovering_over_window(eligible_wintitle)

youtube_wintitle = .*YouTube - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
watchseries_wintitle = i).*Watch\s?Series - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
; tetris_wintitle = .*Tetris.* - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

Return

;=======================================================

^+k:: list_hotkeys()

RButton & Escape:: Suspend, Toggle

>+t::     ; display_active_wintitle
    display_active_wintitle()
    Return
    
RButton & v::   ; controls system sound as opposed to video sound
    Run, MyScripts\Utils\Control Speakers Volume.ahk
    Return
    
!LButton::  ; Toggles LButton functionality between regular Leftclicks and special Leftclicks
    lbutton_switch := !lbutton_switch
    switch_text := lbutton_switch ? "On" : "Off"
    Hotkey, LButton, %switch_text%
    If lbutton_switch
        ttip("`r`nBlocks redirected pages on WatchSeries `r`n ", 1500)
    Else
        ttip("`r`nNormal left click button `r`n ", 1500)
    Return

!RButton::  ; Toggles "default action of RButton" / "Hotkey defined actions for RButton"
            ; by turning all RButton hotkeys on or off.
    rbutton_switch := !rbutton_switch
    toggle_prefix_key_native_function("RButton", rbutton_switch)
    Return

NumpadAdd:: ; Toggle native function (scroll web page) and custom hotkey (seek)
    wheel_switch := !wheel_switch
    switch_text := wheel_switch ? "On" : "Off"
    Hotkey, WheelUp, %switch_text%
    Hotkey, WheelDown, %switch_text%
    If wheel_switch
        ttip("`r`nWheel seeks video forward and backward `r`n ", 1500)
    Else
        ttip("`r`nWheel scrolls web page up and down `r`n ", 1500)
    Return
    
~LButton:: ; closes unwanted redirect windows when links and buttons are clicked on GoWatchSeries.com
{ 
    SetCapsLockState, AlwaysOff
    Sleep 1   ; allow leftclick to activate other windows
    WinGetActiveTitle, aw
    ; OutputDebug, % "aw0: " aw
    If Not WinActive(watchseries_wintitle) 
        Return

    ; Leftclick may activate redirect pages. The loop is necessary to allow a variety 
    ; of "sleep" times to allow start load of redirected pages.
    countx := 1
    While WinActive(watchseries_wintitle) and (countx < 100)
    While WinActive(watchseries_wintitle) and (countx < 100)
    {
        WinGetActiveTitle, aw
        ; OutputDebug, % "aw1: " aw
        Sleep 10
        countx++
    }
    ; OutputDebug, % "countx #1: " countx

    ; Once a redirect is detected above immediately close the redirect page.
    ; The loop is needed in the case of multiple redirects launched at the same time.
    countx := 1
    While Not WinActive(watchseries_wintitle) and (countx < 10)
    {
        WinGetActiveTitle, aw
        ; OutputDebug, % "aw2: " aw   
        SendInput ^w    ; close window
        Sleep 100
        countx++
    }   
    ; OutputDebug, % "A_ThisHotkey: " A_ThisHotkey " - countx: " countx
    Return
}

+RButton::  ; ExitApp - mouse version
^!+y::      ; ExitApp - keyboard version
    ExitApp

CapsLock & Break::  ; Set focus on video
    If WinActive(youtube_wintitle)
    {
        SetCapsLockState, AlWaysOff
        Click, 400, 300
        Sleep 500
        Click, 400, 300
    }
    Return

RButton & WheelUp::     ; volume up
RButton & WheelDown::   ; volume down
RButton & MButton::     ; Skip to previous video (playlist or page depending on website)
^WheelUp::              ; scroll browser page up
^WheelDown::            ; scroll browser page down
+WheelUp::              ; seek video foreward 10 secs
+WheelDown::            ; seek video backward 10 secs
WheelUp::               ; seek video forward 5 secs
WheelDown::             ; seek video backward 5 secs
MButton::               ; Skip to next video (playlist or page depending on website)
RButton::               ; Toggle fullscreen
n::                     ; Skip to next video (keyboard version of MButton)
{
    If Not WinActive(eligible_wintitle) 
    {
        ; Because of #If mouse_hovering_over_window(eligible_wintitle) above
        ; we must be hovering over an eligible window that needs to be activated
        ; for the hotkey to work.
        MouseGetPos,,, hovering_hwnd
        WinGetTitle, wintitle_under_mouse, ahk_id %hovering_hwnd%
        WinActivate, ahk_id %hovering_hwnd%
        WinWaitActive, ahk_id %hovering_hwnd%,,1
    }
    If ErrorLevel
        MsgBox, 48, Unexpected Error, % A_ThisFunc " - " A_ScriptName "`r`n<msg>"

    If (A_ThisHotkey = "WheelUp")
        SendInput {Right}   ; seek video forward 5 secs
    Else If (A_ThisHotkey = "WheelDown")
        SendInput {Left}    ; seek video backward 5 secs
    Else If (A_ThisHotkey = "+WheelUp") Or (A_ThisHotkey = ".")
        SendInput l        ; seek video forward 10 secs
    Else If (A_ThisHotkey = "+WheelDown")  Or (A_ThisHotkey = ",")
        SendInput j        ; seek video backward 10 secs
    Else If (A_ThisHotkey = "^WheelUp")
        scroll_page("Up")            ; SendInput {PgUp}    
    Else If (A_ThisHotkey = "^WheelDown")
        scroll_page("Dn")            ; SendInput {PgDn}    
    Else If (A_ThisHotkey = "MButton") Or (A_ThisHotkey = "n") 
    {
        ; skip to next video
        If WinActive(youtube_wintitle)
            SendInput +n    
        Else If WinActive(watchseries_wintitle)
             Run, MyScripts\Utils\Web\Browser - Next Numbered Page.ahk "^!+PgDn" 
        Else
            1=1
    }
    Else If (A_ThisHotkey = "RButton & MButton") and  WinActive(youtube_wintitle)
        SendInput +p        ; skip to previous video
    Else If (A_ThisHotkey = "RButton")
        SendInput f         ; toggle fullscreen
    Else If (A_ThisHotkey = "RButton & WheelUp")
        SendInput {Up}      ; volume up
    Else If (A_ThisHotkey = "RButton & WheelDown")
        SendInput {Down}  ; volume down
    Else
        OutputDebug, % "Unexpected hotkey: " A_ThisHotkey
    Return
}

;=======================================================
scroll_page(p_direction)
{
    
    Static target_wintitle
    WinGetActiveTitle, current_wintitle
    If (target_wintitle == "")
            WinGetActiveTitle, target_wintitle
            
    If (A_TimeSincePriorHotkey > 3000)
        WinGetActiveTitle, target_wintitle
    ; only scroll if we're in the assumed "correct" wintitle
    If (target_wintitle = current_wintitle)
    {   
        direction = {Pg%p_direction%}
        SendInput %direction%
    }
; saved_coordmode := A_CoordModeToolTip
; CoordMode, ToolTip, Screen
; Tooltip, % "`r`n`r`n    " target_wintitle "    `r`n`r`n    " current_wintitle "`r`n`r`n .", 20, 0
; CoordMode, ToolTip, %saved_coordmode%
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
    Run, https://gowatchseries.co
    Return

MONITOR_SLEEP:
    Run, "C:\Users\Mark\Desktop\Turn Off Monitor.ahk.lnk"
    Return
