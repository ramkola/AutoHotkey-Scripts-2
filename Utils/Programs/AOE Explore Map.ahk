#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
Menu, Tray, Icon, C:\Program Files (x86)\Microsoft Games\Age of Empires II\Age2_x1\age2_x1.exe
OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\AOE Images\Test
aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
#If WinActive(aoe_wintitle)

Gui, Add, Text,,Dummy window so that AOE.ahk can close this process easily and gracefully.
Gui, +Owner -Sysmenu
Gui, Show, NA, %A_ScriptName%
WinMinimize, %A_ScriptName%    ; doesn't require DetectHiddenWindows On to find this window.
WinActivate, %aoe_wintitle%        

; these timers will interupt game play when they go on
SetTimer, CHECK_IDLE_VILLAGERS, 300000  ; 60,000 milliseconds = 1 minute
SetTimer, CHECK_IDLE_VILLAGERS, Off
timer_idle_state := False

Return

;===========================================================
GuiClose:
    ExitApp
;===========================================================

^+.::   ; Turn <<< ON >>> timer to check for idle villager (will interrupt game play)
    timer_idle_state := !timer_idle_state
    tis_text := timer_idle_state ? "On" : "Off"
    SetTimer, CHECK_IDLE_VILLAGERS, %tis_text%    
    ttip("CHECK_IDLE_VILLAGERS = " tis_text, 1000)
    Return

^+MButton:: ; Toggle timer to explore unexplored regions on map (will interrupt game play)
    timer_explore_state := !timer_explore_state
    tes_text := timer_explore_state ? "On" : "Off"
    SetTimer, EXPLORE_UNEXPLORED_REGIONS, %tes_text%
    ttip("EXPLORE_UNEXPLORED_REGIONS = " tes_text, 1000)
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

; EXPLORE_UNEXPLORED_REGIONS:
    ; explore_map(aoe_wintitle)
    ; Return

;============================================================

focus_mouse_on_selected_object(p_set_gather_point := "None"
                               , p_same_gather_point_x := 0
                               , p_same_gather_point_y := 0)
{
    xy_return := []
    ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 Pango 100 - Selected Building Marker.png
    If ErrorLevel
    {
        ttip("Check that Pango is at the correct setting.`nErrorLevel: " ErrorLevel)
        Return
    }
    Else
    {
        MouseMove, x+20, y+50   ; mouse should be over center of building
        MouseGetPos, x, y
        xy_return[1] := x
        xy_return[2] := y
        If (p_set_gather_point <> "None")
        {
        ; ttip(p_set_gather_point)  ; debugging
            If (p_set_gather_point == "Same")
            {
                MouseMove, p_same_gather_point_x, p_same_gather_point_y + 20
            }
            SendInput i{Click, Right}   ; if mouse wasn't moved above then gather point is "Self"
        }
    }
    Return xy_return
}

explore_map(p_wintitle)
{
    If Not WinActive(p_wintitle)
        Return

    SendInput 9     ; select scout
    ErrorLevel := 0
    While (ErrorLevel = 0)
{
    ImageSearch, x, y, 863, 827, A_ScreenWidth, A_ScreenHeight,*2 Pango 100 - Mini Map Unexplored Square.png
    
}
    If ErrorLevel
    {   
        BlockInput, On
        MouseMove, x, y
        Click           ; focus visible screen to unexplored area from minimap
        MouseMove, A_ScreenWidth/2, A_ScreenHeight/2
        Click, Right    ; send scout to middle of unexplored are on game map
        BlockInput, Off
        ttip("Exploring x,y: " x ", " y, 1000)
    }
    SendInput {BackSpace}   ; go back to previous view before this function was called
    Return
}
