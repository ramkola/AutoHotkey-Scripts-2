; #SingleInstance Force
; #NoTrayIcon
; OutputDebug, DBGVIEWCLEAR
; SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\AOE Images\Test
; aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
; #If WinActive(aoe_wintitle)



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

explore_map(p_wintitle)
{
    If Not WinActive(p_wintitle)
        Return

    SendInput 9     ; select scout
    ErrorLevel := 0
    While (ErrorLevel = 0)
    {
        ImageSearch, x, y, 863, 827, A_ScreenWidth, A_ScreenHeight,*2 Pango 100 - Mini Map Unexplored Square.png
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
    }
    SendInput {BackSpace}   ; go back to previous view before this function was called
    Return
}
