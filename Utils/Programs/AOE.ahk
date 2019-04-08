#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include %A_ScriptDir%\AOE Lib.ahk
#Include %A_ScriptDir%\AOE List Hotkeys.ahk
#Include %A_ScriptDir%\AOE Waypoints.ahk
; #Include %A_ScriptDir%\AOE Explore Map.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
Menu, Tray, Icon, C:\Program Files (x86)\Microsoft Games\Age of Empires II\Age2_x1\age2_x1.exe

; set pango %100 for imagesearch
Run, "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\pangolin.ahk" 1 
Sleep 1000
OnExit("exit_app")
aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
difficulty := "Easiest"		; game difficulty level: Easiest/Standard/Moderate/Hard/Hardest
record_game:= False
game_not_running := WinExist(aoe_wintitle) ? False : True
If game_not_running
{
    Run, "C:\Users\Mark\AppData\Roaming\ClassicShell\Pinned\Games\Age of Empires II.lnk" 
    Sleep 6000
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
        start_game(difficulty, record_game)
    }
}
Else
    OutputDebug, % "ErrorLevel: " ErrorLevel 

; AOE List Hotkeys.ahk code
edit_width := "w" A_ScreenWidth - 60
Gui, +AlwaysOnTop -SysMenu +Owner
Gui, Color,, 0xffffe0
Gui, Font, cBlue Q5 s12, Consolas
Gui, Add, Edit,  -Wrap -TabStop r40 %edit_width% vhotkeylist
Gui, +Owner -Sysmenu
Gui, Show, x10 y10 NA, List Hotkeys
list_hotkeys_aoe()
WinGet, hwnd_list_hotkeys, ID, List Hotkeys
show_hotkeys := True

SetTimer, NO_GAME_EXIT, 5000
Return

;=========================================================================
NO_GAME_EXIT:
    If !WinExist(aoe_wintitle)
        exit_app()
    Return
;=========================================================================

#If WinActive(aoe_wintitle)

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
    
^+z::  ; Scout waypoints (select unit, position mouse, press hotkey)
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
    start_game(difficulty)
    Return

^!+s::  ; standard start of game commands
    SendInput `,^9]         ; select scout and assign it group #9, no attack stance
    SendInput h             ; select town center 
    Click, Left, 64, 902    ; start loom
    SendInput .             ; select first idle villager
    Sleep 500
    mouse_pos := focus_mouse_on_selected_object("None",,,"Villager")
    MouseMove, mouse_pos[1], mouse_pos[2]
    Click, Left, 2          ; try to select all visible idle villagers
    Return

NumpadMult:: ; Undo all builds for selected building (select building, press hotkey)
    Loop 20
        Click, Left, 481, 910
    Return

!Numpad9::  ; Build as many as possible units of icon#1 of selected building (select building, press hotkey)
!Numpad1::  ; Build 20 units of icon#1 of selected building (select building, press hotkey)
!Numpad2::  ; Build 20 units of icon#2 of selected building (select building, press hotkey)
!Numpad3::  ; Build 20 units of icon#3 of selected building (select building, press hotkey)
!Numpad4::  ; Build 20 units of icon#4 of selected building (select building, press hotkey)
!Numpad5::  ; Build 20 units of icon#5 of selected building (select building, press hotkey)
Numpad1::   ; Build 5  units of icon#1 of selected building (select building, press hotkey)
Numpad2::   ; Build 5  units of icon#2 of selected building (select building, press hotkey)
Numpad3::   ; Build 5  units of icon#3 of selected building (select building, press hotkey)
Numpad4::   ; Build 5  units of icon#4 of selected building (select building, press hotkey)
Numpad5::   ; Build 5  units of icon#5 of selected building (select building, press hotkey)
    focus_mouse_on_selected_object("Self")  ; Self = set gather point inside the building itself
    icon_xy := ["61,861","99,856","143,864","190,862","5,5","6,6","7,7","8,8","61,861"]
    number_of_units := (SubStr(A_ThisHotkey, 1, 1) = "!") ? 20 : 5
    icon_num := SubStr(A_ThisHotkey, StrLen(A_ThisHotkey)) 
    number_of_units := (A_ThisHotkey = "!Numpad9") ? 40 : number_of_units
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

focus_mouse_on_selected_object(p_set_gather_point := "None"
                               , p_same_gather_point_x := 0
                               , p_same_gather_point_y := 0
                               , p_object_type := "Building")
{
    xy_return := []
    ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 Pango 100 - Selected Object - Green Marker.png
    If ErrorLevel
    {
        SendInput {F3}      ; Pause game
        ttip("Green Marker Failed.`nCheck that Pango is at the correct setting.`nErrorLevel: " ErrorLevel)
        Return
    }
    Else
    {
        If (p_object_type = "Building")
            MouseMove, x+20, y+50   ; mouse should be over center of building
        Else If (p_object_type = "Villager")
            MouseMove, x+4, y+30  ; mouse should be over center of villager
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
    MouseGetPos, x,y
    MouseMove, x + p_x, y + p_y
    Sleep 100
    SendInput +{Click, Left}   
    Sleep %p_sleep_time%    
    build_num++
    Return
}

start_game(p_difficulty, p_game_type := "Random Map", p_record_game := False)
{
	game_type := get_game_type(p_game_type)
	difficulty := get_difficulty_level(p_difficulty)
    BlockInput, On
    SendInput, {Click, Left, 375,  96}      ; Single Player
	SendInput, {Click, Left, 610,  170}		; Standard Game
	Sleep 2000
    set_game_type(game_type)
	set_game_difficulty(difficulty)
	;
    If p_record_game
        SendInput, {Click, Left, 758, 442}
    Sleep 100
	Click, Left, 109, 565     ; Start Game
    Sleep 10000
    SendInput !o    ; display game objectives
    BlockInput, Off
}

exit_app()
{
    ; set pango %70 for cutting screen brightness
    Run, "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\pangolin.ahk" 7

    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
; for debugging AOE Waypoints.ahk only
    ; Sleep 1000
    ; SendInput !{Left}

    ExitApp
}

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

GuiEscape:
GuiClose:
    WinSet, Bottom,, List Hotkeys
    Return
;======================================================================
^+k::      ; Displays all the AOE.ahk hotkeys putting the game in pause while looking at the list
    show_hotkeys := !show_hotkeys
    If show_hotkeys
    {
        SendInput {F3}  ; Pause game
        WinSet, AlwaysOnTop, On, List Hotkeys
        WinSet, Top,, List Hotkeys
    }
    Else
        WinSet, Bottom,, List Hotkeys
    Return

WheelUp::   ; Scroll List Hotkeys window   
WheelDown:: ; Scroll List Hotkeys window
Up::        ; Scroll List Hotkeys window
Down::      ; Scroll List Hotkeys window
    ; Important not make List Hotkeys window active because it will take you out of the game
    ; so here I am navigating List Hotkeys while it is topmost (visible) but not active.
    MouseGetPos,,,hwnd_under_mouse
    is_visible := (hwnd_under_mouse = hwnd_list_hotkeys)
    If WinExist("List Hotkeys") and is_visible
    {
        If Instr(A_ThisHotkey, "Up")
            scroll_command := "Up"
        Else
            scroll_command := "Down"
        ;
        If A_ThisHotkey in WheelUp,WheelDown
            scroll_command .= " " 3
        Else If A_ThisHotkey in PgUp,PgDn
            scroll_command .= " " 10
        ControlSend, Edit1, {%scroll_command%},List Hotkeys 
    }
    Return 