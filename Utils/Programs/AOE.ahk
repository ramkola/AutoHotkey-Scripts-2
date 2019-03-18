#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
Menu, Tray, Icon, C:\Program Files (x86)\Microsoft Games\Age of Empires II\Age2_x1\age2_x1.exe
OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\AOE Images\Test
aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
If Not WinExist(aoe_wintitle)
{
    Run, "C:\Users\Mark\AppData\Roaming\ClassicShell\Pinned\Games\Age of Empires II.lnk"   
    Sleep 10000
    start_game()
}
WinActivate, %aoe_wintitle%        
SetTimer, EXIT_APP, 5000
Return

;=========================================================================

EXIT_APP:
    If WinExist(aoe_wintitle)
        Return
    Else
        ExitApp 

;=========================================================================

#If WinActive(aoe_wintitle)

~LWin::Send {Blind}{vk07}

^+b::    ; Create 1 cargo ship and up to 5 galleons
    xy_result := []
    Loop 20
    {
        focus_mouse_on_selected_building("Self")  ; Self = set gather point inside the building itself
        ; focus_mouse_on_selected_building("Same", xy_result[1], xy_result[2])
        SendInput bp    ; create up to 20 champions spread over all barracks
        Sleep 100
    }
    Return


^+c::    ; Create up to 5 villagers depending on food availability
    SendInput h     ; select town center         
    Sleep 100
    SendInput C     ; Capital 'c' = queues up to 5 villagers 
    Return


^+d::    ; Create 1 cargo ship and up to 5 galleons
    xy_result := []
    SendInput d ; select dock
    Sleep 100
    SendInput o ; create 1 transport gather point out of dock
    xy_result := focus_mouse_on_selected_building()
    ttip(xy_result[1] ", " xy_result[2])
    Loop 5
    {
        ; focus_mouse_on_selected_building("Self")  ; Self = set gather point inside the building itself
        focus_mouse_on_selected_building("Same", xy_result[1], xy_result[2])
        SendInput du    ; create up to 5 galleons spread over all docks
        Sleep 100
    }
    Return

^+e::    ; Build 3 houses (select villager, position mouse, {#e})
    sleep_time := 1500
    SendInput, me{LControl Down}
    Click   ; House #1
    Sleep %sleep_time%
    build_at_mousepos_offset(  100,  62, sleep_time, 2)   ; House #2
    build_at_mousepos_offset(  100,  62, sleep_time)      ; House #3
    build_at_mousepos_offset(  100,  62, sleep_time)      ; House #3
    build_at_mousepos_offset(0,0,0,0,True)                ; reset build_num
    SendInput, {LControl Up}{Escape}
    Return

^+f::    ; queue max farms at mill
    SendInput ^i    ; Select mill
    Sleep 100
    Loop 4
    {
        SendInput F ; Capital 'f' = queues up to 5 farms
        Sleep 10
    }
    Return

^!+f::    ; Build farms around town center (select village {mf} position mouse bottom left {!+f})
    KeyWait, Alt
    sleep_time := 500
    SendInput, {LControl Down}
    Click   ; Farm #1
    Sleep %sleep_time%
    build_at_mousepos_offset( 143, -68, sleep_time, 2)   ; Farm #2
    build_at_mousepos_offset( 131, -71, sleep_time)      ; Farm #3
    build_at_mousepos_offset( 162, -77, sleep_time)      ; Farm #4
    build_at_mousepos_offset(  33, 126, sleep_time)      ; Farm #5
    build_at_mousepos_offset( 151,  81, sleep_time)      ; Farm #6
    build_at_mousepos_offset(-102,  99, sleep_time)      ; Farm #7
    build_at_mousepos_offset(-102,  73, sleep_time)      ; Farm #8
    build_at_mousepos_offset(-208, -61, sleep_time)      ; Farm #9
    build_at_mousepos_offset(-208, -61, sleep_time)      ; Farm #9
    build_at_mousepos_offset(0,0,0,0,True)               ; reset build_num
    SendInput, {LControl Up}{Escape}
    Return

^+i::    ; Sets gather point on self (select building, make sure it is visible on screen, press hotkey)
    focus_mouse_on_selected_building("Self")
    Return

^+k::    ; Displays all the AOE.ahk hotkeys putting the game in pause while looking at the list
    list_hotkeys()
    Return

^!+p::  ; Scout map perimeter (select unit - usually scout - {^!+p})
    Run, "C:\Users\Mark\Documents\AOE\Scout Map Perimeter.ahk"
    Return

^+s::    ; Starts game clicking the necessary buttons and puts the game in pause by displaying objectives
    start_game()
    Return

^+z::    ; Patrols visible screen area at mouse position (select unit - usually scout - position mouse, press hotkey})
    SendInput, ]z    ; ]=No Attack Stance. z = patrol
    set_visible_screen_waypoints()
    Return

#+z::   ; Go to waypoints (select unit, position mouse, press hotkey)
    SendInput, ]{Shift Down}               ; ]=No Attack Stance. 
    set_visible_screen_waypoints() 
    Return

;   *** doesn't account for Mousemove to scroll map - maybe use click on minimap solution
^+x::     ; Explore map circular around town then entire perimeter (selected unit - usually scout - press hotkey)
    SendInput {Shift Down}
    Click, Right,  326,  283
    Click, Right,  930,  222
    Click, Right, 1149,  401
    Click, Right, 1117,  532
    Click, Right,  620,  662
    Click, Right,  267,  757
    Click, Right,  255,  658
    Click, Right,  471,  249
    Click, Left,  1055,  841
    Click, Right,  977,  517
    Click, Left,  1212,  908
    Click, Right, 1159,  584
    Click, Left,  1045,  988
    Click, Right, 1036,  603
    Click, Right,  893,  918
    Click, Left,   900,  912
    Click, Right,  846,  697
    Click, Left,  1063,  920
    SendInput {Shift Up}
    Click, Right,  889,  600
    Return

^+r::   ; Return relic to monastery (select monk with relic, press hotkey)
    SendInput ^5    ; set monk with relic as group 5
    SendInput ^y    ; find the monastery and select it
    xy_return := focus_mouse_on_selected_building("None")
    If (xy_return[1] + xy_return[2] = 0)
        ttip("Could not focus on monastery")   
    SendInput ^y    ; select a monastery
    SendInput 5{Click, Right}    ; select & send monk with relic back to selected monastery
    Return

;=========================================================================

focus_mouse_on_selected_building(p_set_gather_point := "None"
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
            ttip(p_set_gather_point)
            If (p_set_gather_point == "Same")
            {
                MouseMove, p_same_gather_point_x, p_same_gather_point_y + 20
            }
            SendInput i{Click, Right}   ; if mouse wasn't moved above then gather point is "Self"
        }
    }
    Return xy_return
}

build_at_mousepos_offset(p_x, p_y, p_sleep_time, p_build_num_init := 1, p_reset_build_num := False)
{
    Static build_num 
    If p_reset_build_num
    {
        build_num := 1
        Return
    }
    If (build_num  < p_build_num_init)
        build_num := p_build_num_init
    ttip("Build #" build_num, 300)
    MouseGetPos, x,y
    MouseMove, x + p_x, y + p_y
    Sleep 300
    Click   
    Sleep %p_sleep_time%    
    build_num++
    Return
}

set_visible_screen_waypoints()
{
    SendInput, {Shift Down}
    SendInput, {Click, Right,   11,   47}
    SendInput, {Click, Right,    4,  782}
    SendInput, {Click, Right, 1256,  795}
    SendInput, {Click, Right, 1238,   40}
    SendInput, {Click, Right,  589,   47}
    SendInput, {Click, Right,  589,  785}
    SendInput, {Shift Up}{Click, Right}
    Return
}

start_game()
{
    BlockInput, On
    SendInput, {Click, Left,  375,   96}    ; Single Player
    SendInput, {Click, Left,  608,  168}    ; Standard Game
    Sleep 1000
    SendInput, {Click, Left, 109,  565}     ; Start Game
    Sleep 10000
    SendInput !o    ; display game objectives
    BlockInput, Off
}

list_hotkeys()
{
    countx = 0
    in_file := A_ScriptFullPath
    FileRead, in_file_var, %in_file% 
    Loop, Parse, in_file_var, `n, `r 
    {
        If InStr(A_LoopField,chr(58)chr(58))    ; 2 colons 
        {
            countx++
            hotkey_line := StrReplace(A_LoopField, "CapsLock &", "CL &")
            write_string .= hotkey_line "`n`n"
        }
    }
    write_string .= " `n"
    SendInput {F3}  ; Pause game
    ttip(write_string,, 100, 100)
    SendInput {F3}  ; Resume game
    Return
}
