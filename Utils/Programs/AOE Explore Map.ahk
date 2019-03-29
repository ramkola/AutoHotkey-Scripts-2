; #SingleInstance Force
; #NoTrayIcon
OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\AOE Images\Test
aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
#If WinActive(aoe_wintitle)

Gui, 2:Add, Text,,Dummy window so that AOE.ahk can close this process easily and gracefully.
Gui, 2:+Owner -Sysmenu
Gui, 2:Show, NA, AOE Explore Map.ahk
WinWait, AOE Explore Map.ahk



;===========================================================
2GuiClose:
    ExitApp
;===========================================================

^+.::   ; Toggle timer to check for idle villager (will interrupt game play)
    timer_idle_state := !timer_idle_state
    tis_text := timer_idle_state ? "On" : "Off"
    SetTimer, CHECK_IDLE_VILLAGERS, %tis_text%    
    ttip("CHECK_IDLE_VILLAGERS = " tis_text, 1000)
    Return

^+x::   ; explore map with selected unit - ie: scout (land) / cargo ship (water)
    MsgBox, 48,, % "explore_map under construction", 10
    Return
    explore_map_flag := !explore_map_flag
    explore_map(aoe_wintitle)
;============================================================

CHECK_IDLE_VILLAGERS:
    SendInput .
    result := focus_mouse_on_selected_object()
    If (result[1] + result[2] > 0)  ; idle villager found
        ttip("`n`nFound Idle Villagers", 1000)
    Return

;============================================================

