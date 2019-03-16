#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
write_string := ""
aoe_flag := False
If aoe_flag
{
    aoe_wintitle = Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
    #If WinActive(aoe_wintitle)
    WinActivate, %aoe_wintitle%
}

#IfWinActive
Return

~*LButton::
    MouseGetPos x,y
    ; If aoe_flag
        ; write_string .= Format("SendInput, {Click, Right, {:4}, {:4}}`r`n", x, y)
    ; Else
        write_string .= Format("Click, Left, {:4}, {:4}`r`n",x, y)
    Return

Mbutton::
    ClipBoard := write_string
    ListVars  ; Use AutoHotkey's main window to display monospaced text.
    WinWaitActive ahk_class AutoHotkey
    ControlSetText Edit1, %write_string%
    WinWaitClose
    ExitApp

!f::    ; Build farms around town center
        ; (manually select villager and key mf to create
        ;  first farm in bottom left corner of town center
        ;  then key !f to build rest of farms)
    sleep_time := 500
    SendInput, {LControl Down}
    MouseGetPos, x, y
    Click   ; Farm #1
    Sleep %sleep_time%
    MouseMove, x+143, y-68
    Click   ; Farm #2
    Sleep %sleep_time%
    MouseGetPos, x, y
    MouseMove, x+131, y-71
    Click   ; Farm #3
    Sleep %sleep_time%
    MouseGetPos, x, y
    MouseMove, x+162, y-77
    Click   ; Farm #4
    MouseGetPos, x, y
    MouseMove, x+33, y+126
    Click   ; Farm #5
    Sleep %sleep_time%
    MouseGetPos, x, y
    MouseMove, x+151, y+81
    Click   ; Farm #6
    Sleep %sleep_time%
    MouseGetPos, x, y
    MouseMove, x-102, y+99
    Click   ; Farm #7
    Sleep %sleep_time%
    MouseGetPos, x, y
    MouseMove, x-112, y+71
    Click   ; Farm #8
    Sleep %sleep_time%
    MouseGetPos, x, y
    MouseMove, x-208, y-61
    Click   ; Farm #9
    Sleep %sleep_time%
    ; MouseGetPos, x, y
    ; MouseMove, x-346, y-630
    SendInput, {LControl Up}{Escape}
    Return




/* 

    Build Farm Around Town Center
    Relative from inital mousepos.
+143 	-68
+131 	-71
+162 	-77
+33	    +126
+151 	+81
-102	+99
-112	+71
-208	-61
-346	-630
*/

/* 
    If Not WinActive("ahk_class FullScreenClass ahk_exe i_view32.exe")
        SendInput {Enter}   ; Fullscreen


    If (A_ThisHotkey = "~RButton & Control")
        mouse_button := "Right"
    Else If (A_ThisHotkey = "~LButton")
        mouse_button := "Left"
*/