#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetTitleMatchMode 2

Run, %A_ScriptDir%\..\Web\Youtube Keys.ahk

minesweeper_wintitle = Minesweeper ahk_class Minesweeper ahk_exe Minesweeper.exe
#If WinActive(minesweeper_wintitle)

Menu, Tray, Icon, C:\Program Files\Microsoft Games\Minesweeper\Minesweeper.exe
Menu, Tray, Add,
Menu, Tray, Add, Hover Interval..., MENU_HANDLER
Menu, Tray, Add, Slower, MENU_HANDLER
Menu, Tray, Add, Faster, MENU_HANDLER
Menu, Tray, Add,
Menu, Tray, Add, Click Interval..., MENU_HANDLER
Menu, Tray, Add, % "Slower" chr(32), MENU_HANDLER
Menu, Tray, Add, % "Faster" chr(32), MENU_HANDLER
Menu, Tray, Add,

; starts new game or activates current game 
Run, "C:\Program Files\Microsoft Games\Minesweeper\Minesweeper.exe"
WinWaitActive, %minesweeper_wintitle%,,2

hover_interval := 100           ; milliseconds to signal a click is desired on current position
click_interval := 300           ; milliseconds before allowing another click to occur
wait_for_first_click := True    ; prevents clicking before game has started. See LButton hotkey for setting false.

START_LOOP:
Loop
{
    If Not WinExist(minesweeper_wintitle)
        ExitApp

    ; game won/lost window before starting new game
    If WinActive("ahk_class #32770 ahk_exe Minesweeper.exe") Or wait_for_first_click
    {
        wait_for_first_click := True
        Sleep 100
        Continue
    }

    If Not WinActive(minesweeper_wintitle)
    {
        Sleep 1000
        Continue
    }

    If Not mouse_hovering("Minesweeper")
    {
        Sleep 1000
        Continue
    }
    ;===========================================
    MouseGetpos, x1, y1
    hover_start := A_TickCount + hover_interval
    Sleep hover_interval
    hover_end := A_TickCount
    MouseGetpos, x2, y2
    
    pad := 15   ; number of ± pixels from current mouse pos that is considered hovering in same spot
    If ((x1 >= clicked_x - pad ) and (x1 <= clicked_x + pad )) and ((y1 >= clicked_y - pad ) and (y1 <= clicked_y + pad ))
        Continue

    ; OutputDebug, % "Diff: " hover_end - hover_start " - h_s: " hover_start " h_e: " hover_end
    If ((hover_end - hover_start) < 0)    ; hover interval too short
    {
        OutputDebug, % "Hover too short ... skipping click ...."
        Continue
    }

    If (x1 = clicked_x) and (y1 = clicked_y)    ; mouse is hovering on a square that has been clicked already
        Continue
    Else        
    {
        ; on blue (unknown) square will cycle flag/blank (and question mark if enabled in options)
        Click, Right        
        clicked_x := x1
        clicked_y := y1
        Sleep click_interval   ; avoid clicking twice on same square while mouse moves to a new square

        ; only click middle button if the other mouse buttons aren't being pressed
        If (GetKeyState("RButton") = 0) and (GetKeyState("LButton") = 0)
            Send {MButton}  ;  on grey uncovered square (known) will expose surrounding unmined squares / flash blue squares that are adjacent and might be mined
    }
    Sleep 10    ; avoid hogging cpu time
} 

ExitApp

MENU_HANDLER:
    If (A_ThisMenuItemPos = 2)  ; Hover Interval Show
        1=1
    Else If (A_ThisMenuItemPos = 3) ; Slower
        hover_interval += 50
    Else If (A_ThisMenuItemPos = 4) ; Faster
        hover_interval -= 50
    Else If (A_ThisMenuItemPos = 6) ; Click Interval Show
        1=1
    Else If (A_ThisMenuItemPos = 7) ; Slower
        click_interval += 50
    Else If (A_ThisMenuItemPos = 8) ; Faster
        click_interval -= 50
    Else
        OutputDebug, % "Unexpected Menu Item: " A_ThisMenuItem
    
    
    If InStr("234", A_ThisMenuItemPos)
    {
        If hover_interval < 100 
            hover_interval := 100
        MsgBox,,, % "Hover Inveral: " hover_interval, 1
    }
    Else If InStr("678", A_ThisMenuItemPos)
    {
        If click_interval < 100 
            click_interval := 100
        MsgBox,,, % "Click Inveral: " click_interval, 1
    }
    Return  ; end of MENU_HANDLER

    

z::
WheelDown::
WheelUp:: Pause
~LButton:: wait_for_first_click := false   

Escape::
x:: 
    WinMinimize, A  ; stops timer 
    Goto START_LOOP ; avoids clicking on arbitrary window
    Return

