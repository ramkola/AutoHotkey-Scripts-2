#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
Menu, Tray, Icon, C:\Program Files (x86)\Microsoft Games\Age of Empires II\Age2_x1\age2_x1.exe
OutputDebug, DBGVIEWCLEAR

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

!+f::    ; Build farms around town center (select village {mf} position mouse bottom left {!+f})
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
    build_at_mousepos_offset(-112,  71, sleep_time)      ; Farm #8
    build_at_mousepos_offset(-208, -61, sleep_time)      ; Farm #9
    SendInput, {LControl Up}{Escape}
    Return

!e::    ; Build 3 houses (select villager {me} position mouse {!e}
    KeyWait, Alt
    sleep_time := 500
    SendInput, {LControl Down}
    Click   ; House #1
    Sleep %sleep_time%
    build_at_mousepos_offset(  94,  39, sleep_time, 2)   ; House #1
    build_at_mousepos_offset( -26, -84, sleep_time)      ; House #2
    SendInput, {LControl Up}{Escape}
    Return

!z::    ; Patrols visible screen area at mouse position (select unit - usually scout - position mouse {!z})
    SendInput, ]z    ; ]=No Attack Stance. z = patrol
    set_visible_screen_waypoints()
    Return

!+z::   ; Go to waypoints (select unit position mouse {!+z})
    SendInput, ]{Shift Down}               ; ]=No Attack Stance. 
    set_visible_screen_waypoints() 
    Return

!c::    ; Create upto 5 villagers depending on food availability
    SendInput h     ; select town center         
    Sleep 100
    SendInput C     ; Capital 'c' = queues upto 5 villagers 
    Return

!f::    ; queue max farms at mill
    SendInput ^i    ; Select mill
    Sleep 100
    Loop 4
    {
        SendInput F ; Capital 'f' = queues upto 5 farms
        Sleep 10
    }
    Return

; *** doesn't work yet ***
!+r::   ; Return relic to monastery (select monk with relic {!+r})
    SendInput ^y
    MouseMove A_CaretX, A_CaretY
    Return
    SendInput ^5^y5
    Sleep 500
    SendInput {Click, Right}
    Return

^!+p::  ; Scout map perimeter 
    Run, "C:\Users\Mark\Documents\AOE\Scout Map Perimeter.ahk"
    Return


!s::    start_game()
!k::    list_hotkeys()

;=========================================================================

build_at_mousepos_offset(p_x, p_y, p_sleep_time, p_build_num_init := 1)
{
    Static build_num 
    If (p_build_num_init > 1)
        build_num := p_build_num_init
    MouseGetPos, x, y
    ToolTip, Build #%build_num%, x+10, y+10
    Sleep 300
    ToolTip
    MouseGetPos, x, y
    MouseMove, x + p_x, y + p_y
    Click   
    Sleep %p_sleep_time%    
    build_num++
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
    write_string := "`t`t`tHit {Escape} to Exit`n`n"
    in_file := A_ScriptFullPath
    SplitPath, in_file, fname 
    FileRead, in_file_var, %in_file% 
    Loop, Parse, in_file_var, `n, `r 
    {
        If InStr(A_LoopField,chr(58)chr(58))    ; 2 colons 
        {
            countx++
            write_string .= A_LoopField "`r`n`r`n"
        }
    }
    write_string .= " `r`n"
    SendInput {F3}  ; Pause game
    MouseGetPos, x, y
    ToolTip, %write_string%, 100, 100
    Input, out_var,,{Esc}{Escape} 
    ToolTip
    SendInput {F3}  ; Resume game
    Return
}


