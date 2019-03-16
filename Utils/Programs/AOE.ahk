#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
; #If WinActive(aoe_wintitle)
; WinActivate, %aoe_wintitle%
; OutputDebug, DBGVIEWCLEAR
Return

;=========================================================================

!e::    ; Build 3 houses side by side at mouse position (villager needs to be selected manually)
    MouseGetPos x, y
    SendInput me{LControl Down}
    Click
    Sleep 1
    MouseMove, x+200, y+10
    Click
    Sleep 1
    MouseMove, x+400, y+20
    Click
    Sleep 1
    SendInput {LControl Up}{Escape}
    Return

!z::    ; Selected unit patrols visible screen area at mouse position (scout needs to be selected manually)
    SendInput, ]z    ; ]=No Attack Stance. z = patrol
    set_visible_screen_waypoints()
    Return

!+z::   ; same as !z except no patrol (i.e. goes to the waypoints once, scout needs to be selected manually)
    SendInput, ]{Shift Down}               ; ]=No Attack Stance. 
    set_visible_screen_waypoints() 
    Return

!c::    ; Create upto 5 villagers depending on food availability
    SendInput, hC   ; Capital 'c' is shortcut for build upto 5 villagers
    Return

!k:: list_hotkeys()


;=========================================================================

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

list_hotkeys()
{
    countx = 0
    write_string := ""
    in_file := A_ScriptFullPath
    SplitPath, in_file, fname 
    FileRead, in_file_var, %in_file% 
    Loop, Parse, in_file_var, `n, `r 
    {
        If InStr(A_LoopField,chr(58)chr(58))    ; 2 colons '::'
        {
            countx++
            write_string .= A_LoopField "`r`n`r`n"
        }
    }
    display_text(write_string, "AOE Keyboard Shortcuts",,,A_ScreenWidth-300, 10)
    Return
}