; this is to see if archers formation switching helps in fighting against mangonels
; using AOE scenario editor Mangonel vs 5 Crossbowmen.scx for testing.
#SingleInstance Force
#Include lib\strings.ahk
#Include lib\utils.ahk
#Include lib\pango_level.ahk
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Programs\AOE Lib.ahk
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\AOE Images\Test

result = 0
While Not result
    result := pango_level(100)
    
aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
WinActivate, %aoe_wintitle%
#If WinActive(aoe_wintitle)
archers_formation := False
Return

x::     ; start archers_formation
    sleep_interval = 700
    archers_formation := True
    While archers_formation and WinActive(aoe_wintitle)
    {
        SendInput i
        Sleep sleep_interval
        SendInput o
        Sleep sleep_interval
    }
    Return

!x:: archers_formation := False

!s::    ; scenario builder menu - save scenario
    archers_formation := False
    Click, Left  , 1238,   25
    Click, Left  ,  692,  407
    Return

!t::    ; scenario builder menu - run test
    archers_formation := False
    Click, Left  , 1238,   25
    Click, Left  ,  671,  597
    Sleep 2000
    ; crossbowman upgrade
    SendInput a
    Click, Left, 56, 908   
    ; create 20 crossbowmen at each of the 3 remaining archery ranges
    Loop 60
    {
        SendInput ap
        Sleep 10
    }
    SendInput a     ; select all archery ranges
    xy_result := focus_mouse_on_selected_object()
    Click, 2        
    SendInput i     ; set gather point     
    Return

!F10::  ; Exit test
    SendInput !{F10}
    SendInput {Enter}
    Sleep 100
    SendInput {Enter}
    result = 0
    While Not result
        result := pango_level(70)

^+k::   ; list_hotkeys
    list_hotkeys()
    WinActivate, %aoe_wintitle%
    Return

^+x:: ExitApp
