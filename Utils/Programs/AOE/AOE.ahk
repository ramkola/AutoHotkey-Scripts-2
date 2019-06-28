#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\pango_level.ahk
#Include %A_ScriptDir%\AOE Lib.ahk
#Include %A_ScriptDir%\AOE Waypoints.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
Menu, Tray, Icon, C:\Program Files (x86)\Microsoft Games\Age of Empires II\Age2_x1\age2_x1.exe

result = 0
While Not result
    result := pango_level(100)
If result = -999
    Return

Global Y_TOP_MAIN_MAP = 32      ; Top of main map (excludes menu bar)
Global Y_BOT_MAIN_MAP = 810     ; bottom of main map (excludes minimap and build command areas)
OnExit("exit_app")
list_hotkeys_wintitle = AOE.ahk - {Escape} to exit ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe
aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
difficulty := "Standard"		; game difficulty level: Easiest/Standard/Moderate/Hard/Hardest
; difficulty := "Moderate"		; game difficulty level: Easiest/Standard/Moderate/Hard/Hardest
record_game:= False
game_not_running := WinExist(aoe_wintitle) ? False : True
If game_not_running
{
    Run, "C:\Users\Mark\AppData\Roaming\ClassicShell\Pinned\Games\Age of Empires II.lnk"
    While Not WinExist(aoe_wintitle)
    {
        ToolTip, % "`r`n`r`n    Starting game....please wait    `r`n`r`n ", 200, 200
        Sleep 1000
    }
}

OutputDebug, DBGVIEWCLEAR

SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\AOE Images\Test

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; these timers will interupt game play when they go on
; SetTimer, CHECK_IDLE_VILLAGERS, 300000  ; 60,000 milliseconds = 1 minute
; SetTimer, CHECK_IDLE_VILLAGERS, Off
; timer_idle_state := False

WinActivate, %aoe_wintitle%  
WinWaitActive, %aoe_wintitle%,,5 
If (ErrorLevel = 0)
{
    If game_not_running
    {
        Sleep 2000
        start_game(difficulty,,record_game)
    }
}
Else
    OutputDebug, % "ErrorLevel: " ErrorLevel 

SetTimer, NO_GAME_EXIT_SCRIPT, 5000
Return

;=========================================================================
NO_GAME_EXIT_SCRIPT:
    If !WinExist(aoe_wintitle)
        exit_app()
    Return
;=========================================================================

#If WinActive(aoe_wintitle)

^+Home:: ; Scout map around current position (select unit - usually scout, press hotkey)
    perimeter_current_pos("Scout")
    Return

^+x::ExitApp

~LWin::Send {Blind}{vk07}       ; try and disable Win key

^!+PgDn::	; Destroys any of my units or buildings that is under the mouse
^+PgDn:: 	; Destroys any of my units or buildings that is under the mouse
	KeyWait Control
	KeyWait Shift
    destroy_toggle := True
    MouseGetPos x, y
    ToolTip,*** Destroy ON in 1 Second ***`nMake sure mouse is positioned over`na unit or building you want to delete, x+20, y+20
    Sleep 1000
    While destroy_toggle
    {
		mouse_hovering_flag := mouse_hovering(10, 0)	; avoids clicking while mouse is moving
		another_hotkey_firing := GetKeyState("Control") or GetKeyState("Alt") or GetKeyState("Shift")
		If another_hotkey_firing or (mouse_hovering_flag = False)
		{
			; let the other hotkey fire and skip destroying
			Sleep 500 
			Continue
		}
		If WinActive(aoe_wintitle)
		{
			Click
			Sleep 50
			SendInput, +{Del}
			MouseGetPos x, y
			ToolTip, Destroy is ON!!!, x+20, y+20
			Sleep 200	
		}
    }
    ToolTip
    Return

^!PgDn::	; Turns off detroy {^+PgDn} 
^PgDn::  	; Turns off detroy {^+PgDn} 
	KeyWait Control
	KeyWait Shift
    destroy_toggle := False  
    Return

^+c::   ; Create up to 5 villagers depending on food availability
	KeyWait Control
	KeyWait Shift
    SendInput h     ; select town center         
    Sleep 100
    SendInput C     ; Capital 'c' = queues up to 5 villagers 
    Return

^+d::   ; Create 1 cargo ship and up to 5 galleons
	KeyWait Control
	KeyWait Shift
    xy_result := []
    SendInput d ; select dock
    Sleep 100
    SendInput o ; create 1 transport gather point out of dock
    xy_result := focus_mouse_on_selected_object()
    Loop 5
    {
        ; focus_mouse_on_selected_object("Self")  ; Self = set gather point inside the building itself
        focus_mouse_on_selected_object("Same", xy_result[1], xy_result[2])
        SendInput du    ; create up to 5 galleons spread over all docks
        Sleep 100
    }
    Return

^+e::   ; Build 3 houses (select villager, position mouse, {#e})
    KeyWait Control
    KeyWait Shift
    sleep_time := 500
    BlockInput, On
    SendInput, me
    SendInput +{Click, Left}   ; House #1
    Sleep %sleep_time%
    build_at_mousepos_offset(100,  50, sleep_time, 2)  ; House #2
    build_at_mousepos_offset( 70, -50, sleep_time)     ; House #3
    build_at_mousepos_offset(0,0,0,0,True)             ; reset build_num
    SendInput, {Shift Up}{Escape}
    BlockInput, Off
    Return

^!+e::   ; Build 9 houses (select villager, position mouse, {#e})
    KeyWait Control
    KeyWait Shift
    KeyWait Alt
    sleep_time := 50
    BlockInput, On
    SendInput, me
    SendInput +{Click, Left}   ; House #1
    Sleep %sleep_time%
    build_at_mousepos_offset( 100,  50, sleep_time, 2)  ; House #2
    build_at_mousepos_offset( 100,  50, sleep_time)     ; House #3
    build_at_mousepos_offset( 100, -50, sleep_time)     ; House #4
    build_at_mousepos_offset(-100, -50, sleep_time)     ; House #5
    build_at_mousepos_offset(-100, -50, sleep_time)     ; House #6
    build_at_mousepos_offset( 100, -50, sleep_time)     ; House #7
    build_at_mousepos_offset( 100,  50, sleep_time)     ; House #8
    build_at_mousepos_offset( 100,  50, sleep_time)     ; House #9
	build_at_mousepos_offset(0,0,0,0,True)              ; reset build_num
    SendInput, {Shift Up}{Escape}
    BlockInput, Off
    Return

^+f::   ; queue max farms at mill
	KeyWait Control
	KeyWait Shift
    SendInput ^i    ; Select mill
    Sleep 100
    Loop 4
    {
        SendInput F ; Capital 'f' = queues up to 5 farms
        Sleep 10
    }
    Return

^!+f::  ; Build farms around town center (select village {mf} position mouse bottom left {!+f})
	KeyWait Control
	KeyWait Shift
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
    build_at_mousepos_offset(0,0,0,0,True)               ; reset build_num
    SendInput, {LControl Up}{Escape}
    Return

^+i::   ; Sets gather point on self (select building, make sure it is visible on screen, press hotkey)
	KeyWait Control
	KeyWait Shift
    focus_mouse_on_selected_object("Self")
    Return

^+g::  ; Scout land map in zigzag pattern (select unit - usually scout, press hotkey)
	KeyWait Control
	KeyWait Shift
    land_zigzag("Scout")
    Return

^!+g::  ; Patrol land map in zigzag pattern (select unit - usually scout, press hotkey)
	KeyWait Control
	KeyWait Shift
	KeyWait Alt
    land_zigzag("Patrol")
    Return

^+p::  ; Scout map perimeter (select unit - usually scout, press hotkey)
	KeyWait Control
	KeyWait Shift
    perimeter("Scout")
    Return

^!+p:: ; Patrol map perimeter (select unit - usually scout, press hotkey)
    perimeter("Patrol")
    Return

^+Up:: ; Scout map perimeter TOP half of screen (select unit - usually scout, press hotkey)
    perimeter_top("Scout")
    Return

^!+Up:: ; Patrol map perimeter TOP half of screen (select unit - usually scout, press hotkey)
    perimeter_top("Patrol")
    Return

^+Down:: ; Scout map perimeter BOTTOM half of screen (select unit - usually scout, press hotkey)
    perimeter_bottom("Scout")
    Return

^!+Down:: ; Patrol map perimeter BOTTOM half of screen (select unit - usually scout, press hotkey)
    perimeter_bottom("Patrol")
    Return

^+Left:: ; Scout map perimeter LEFT side of screen (select unit - usually scout, press hotkey)
    perimeter_left("Scout")
    Return

^!+Left:: ; Patrol map perimeter LEFT side of screen (select unit - usually scout, press hotkey)
    perimeter_left("Patrol")
    Return

^+Right:: ; Scout map perimeter RIGHT side of screen (select unit - usually scout, press hotkey)
    perimeter_right("Scout")
    Return

^!+Right:: ; Patrol map perimeter RIGHT side of screen (select unit - usually scout, press hotkey)
    perimeter_right("Patrol")
    Return

^+u::  ; Scout all unexplored squares on minimap and sets waypoints to it on game map (select unit - usually scout, press hotkey)
	KeyWait Control
	KeyWait Shift
    explore_unexplored_map("Scout")
    Return

^!+u:: ; Patrol all unexplored squares on minimap and sets waypoints to it on game map (select unit - usually scout, press hotkey)
	KeyWait Control
	KeyWait Shift
	KeyWait Alt
    explore_unexplored_map("Patrol")
    Return
    
^+z::  ; Scout visible screen area at mouse position (select unit, position mouse, press hotkey)
    visible_screen("Scout", False)
    Return

^!+z::   ; Patrols visible screen area at mouse position (select unit - usually scout - position mouse, press hotkey})
    visible_screen("Patrol", False)
    Return

^+r::   ; Return relic to monastery (select monk with relic, press hotkey)
    SendInput ^5    ; set monk with relic as group 5
    SendInput ^y    ; find the monastery and select it
    xy_return := focus_mouse_on_selected_object("None")
    If (xy_return[1] + xy_return[2] = 0)
        ttip("Could not focus on monastery")   
    SendInput ^y    ; select a monastery
    SendInput 5{Click, Right}    ; select & send monk with relic back to selected monastery
    Return

^!s::return     ; Avoid starting Search Everthing.exe by accident

^+s::   ; Starts game clicking the necessary buttons and puts the game in pause by displaying objectives
    start_game(difficulty,,record_game)
    Return

^!+s::  ; standard start of game commands
    SendInput `,^9]         ; select scout and assign it group #9, no attack stance
    SendInput h             ; select town center 
    Click, Left, 64, 902    ; start loom
    Gosub ^+Home            ; Start scouting around town center
    SendInput .             ; select first idle villager
    Sleep 500
    mouse_pos := focus_mouse_on_selected_object("None",,,"Villager")
    MouseMove, mouse_pos[1], mouse_pos[2]
    Click, Left, 2          ; try to select all visible idle villagers
    Sleep 10
    SendInput me            ; build houses
    Return

^+F10::  ; quit game - go back to main menu 
    SendInput {F10}     ; Options Menu
    Sleep 100
    SendInput {Enter}   ; Quit Game
    Sleep 100
    SendInput {Enter}   ; Confirm - Yes
    ; Sleep 5000
    ; SendInput {Enter}   ; Main Menu
    Return

^!+x::  ; AOE.ahk shutdown
    exit_app()
    Return

^+k::
    SendInput {F3}      ; pause game
    list_hotkeys(,,80)   
    While Not WinActive(aoe_wintitle)
    {
        WinActivate, %aoe_wintitle%
        WinWaitActive, %aoe_wintitle%,,1
    }
    Sleep 500
    SendInput {F3}      ; resume game
    Return

` & Escape:: ; Undo all units queued for creation for selected building (select building, press hotkey)
    Loop 20
        Click, Left, 481, 910
    Return

#9::        ; Build as many as possible units of icon#1 of selected building (select building, press hotkey)
#1::        ; Build 20 units of icon#1 of selected building (select building, press hotkey)
#2::        ; Build 20 units of icon#2 of selected building (select building, press hotkey)
#3::        ; Build 20 units of icon#3 of selected building (select building, press hotkey)
#4::        ; Build 20 units of icon#4 of selected building (select building, press hotkey)
#5::        ; Build 20 units of icon#5 of selected building (select building, press hotkey)
` & 1::     ; Build 5  units of icon#1 of selected building (select building, press hotkey)
` & 2::     ; Build 5  units of icon#2 of selected building (select building, press hotkey)
` & 3::     ; Build 5  units of icon#3 of selected building (select building, press hotkey)
` & 4::     ; Build 5  units of icon#4 of selected building (select building, press hotkey)
` & 5::     ; Build 5  units of icon#5 of selected building (select building, press hotkey)
    focus_mouse_on_selected_object("Self")  ; Self = set gather point inside the building itself
    ; 5,6,7,8 are dummy values there are no icons for those values
    icon_xy := ["61,861","99,856","143,864","190,862","5,5","6,6","7,7","8,8","61,861"] 
    number_of_units := (SubStr(A_ThisHotkey, 1, 1) = "#") ? 20 : 5
    icon_num := SubStr(A_ThisHotkey, StrLen(A_ThisHotkey)) 
    number_of_units := (A_ThisHotkey = "#9") ? 40 : number_of_units
    xy := icon_xy[icon_num]
    Loop %number_of_units%
        Click % icon_xy[icon_num]
  Return
  
#Numpad0:: Run, "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Macro Recorder.ahk"

;=========================================================================

; ***************************************************************************
; ***************************** UNDER CONSTRUCTION **************************
; ***************************************************************************
send_idle_villagers_to_build_wonder()
{
    ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 Pango 100 - Selected Object - Red Marker.png
    Return
}
; ***************************************************************************



