#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetTitleMatchMode 2
Menu, Tray, Icon, C:\Program Files\Microsoft Games\Freecell\Freecell.exe
Menu, Tray, Add,
Menu, Tray, Add, Hover Interval..., MENU_HANDLER
Menu, Tray, Add, Slower, MENU_HANDLER
Menu, Tray, Add, Faster, MENU_HANDLER
Menu, Tray, Add,

; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
; OutputDebug, DBGVIEWCLEAR

; starts new game or activates current game 
Run, "C:\Program Files\Microsoft Games\Freecell\Freecell.exe"
WinWaitActive, FreeCell ahk_class FreeCell ahk_exe Freecell.exe

hover_interval := 150           ; milliseconds to signal a click is desired on current position
click_interval := 400           ; milliseconds before allowing another click to occur

START_LOOP:
Loop
{
    If Not WinExist("FreeCell ahk_class FreeCell ahk_exe Freecell.exe")
        ExitApp
    
    If WinActive("Empty Stack ahk_class #32770 ahk_exe Freecell.exe")
        ControlClick, Button1, A,, Left    ; Move All
    
    ; sometimes needs to be clicked more than once
    countx := 0
    While WinExist("No More Moves ahk_class #32770 ahk_exe Freecell.exe")  
    {
        WinActivate
        WinWaitActive,,,2
        ControlClick, Button2, A,, Left    ; Return and try again
        Sleep 1
        Loop 100
            SendInput ^z    ; undo all moves to the beginning of game
        countx++
        Sleep 10
        Continue
    }
        
    ; game won/lost window before starting new game
    If WinActive("ahk_class #32770 ahk_exe Freecell.exe")
    {
        Sleep 100
        Continue
    }

    If Not WinActive("FreeCell ahk_class FreeCell ahk_exe Freecell.exe")
    {
        Sleep 1000
        Continue
    }

    If Not mouse_hovering("FreeCell")
    {
        Sleep 1000
        Continue
    }
    ;===========================================
    WinGetPos, wx, wy, ww, wh, A 
    MouseGetpos, x1, y1
    hover_start := A_TickCount + hover_interval - 4
    Sleep hover_interval
    hover_end := A_TickCount
    MouseGetpos, x2, y2
    
    ; checks whether mouse is over the top left 4 card 
    top_left_deck := ((x1/ww >= .05) and (x1/ww <= .45)) and ((y1/wh >= .15) and (y1/wh <= .30))
    bottom_main_deck := !top_left_deck
    
    If (x1 <> x2) and (y1 <> y2)  ; mouse is not hovering 
        Continue

    ; OutputDebug, % "Diff: " hover_end - hover_start " - h_s: " hover_start " h_e: " hover_end
    If ((hover_end - hover_start) < 0)    ; hover interval too short
    {
        OutputDebug, % "Hover too short ... skipping click ...."
        Continue
    }
    ; mouse is hovering on a card that has been clicked already
    pad := 25   ; number of ± pixels from current mouse pos that is considered hovering in same spot
    If ((x1 >= clicked_x - pad ) and (x1 <= clicked_x + pad )) and ((y1 >= clicked_y - pad ) and (y1 <= clicked_y + pad ))
        Continue       
    Else        
    {
        If bottom_main_deck
        {
            ; select/deselect/move the card(s)
            Click, Left
            clicked_x := x1
            clicked_y := y1
            Sleep click_interval   ; avoid clicking twice on same card while mouse moves to a new card
        }
        Else If top_left_deck
            Click, Right
    }
    Sleep 10    ; avoid hogging cpu time
} 
ExitApp

;=====================================================================================

MENU_HANDLER:
    If (A_ThisMenuItemPos = 2)  ; Hover Interval Show
        1=1
    Else If (A_ThisMenuItemPos = 3) ; Slower
        hover_interval += 50
    Else If (A_ThisMenuItemPos = 4) ; Faster
        hover_interval -= 50
    Else
        OutputDebug, % "Unexpected Menu Item: " A_ThisMenuItem
    
    If InStr("234", A_ThisMenuItemPos)
    {
        If hover_interval < 100 
            hover_interval := 100
        MsgBox,,, % "Hover Inveral: " hover_interval, 1
    }
    Return  ; end of MENU_HANDLER
    
#If WinActive("FreeCell ahk_class FreeCell ahk_exe Freecell.exe")

p:: Pause

MButton::
c:: ; move all applicable cards to the appropriate top left slot holder
    WinGetPos, x, y, w, h, A
    MouseGetPos, save_x, save_y
    MouseMove w-50, h-50
    SendInput {Click, Right}
    MouseMove, save_x, save_y
    Return

v:: ; (doesn't work) move focus first of the  upper left 4 card slot holders 
    WinGetPos, x, y, w, h, A
    MouseGetPos, save_x, save_y
    MouseMove x+50, y+70
    SendInput {Click}
    Sleep 10
    ; SendInput {Right}
    Return
    
x:: ; move selected card to 1 of the free upper left 4 card slot holders 
    MouseGetPos, x, y
    ; SendInput {Click, Right}
    SendInput {RButton}
    MouseMove, x, y
    Return
    
RESET_GAME:
^+z:: ; reset to start of game (undo)
    Loop 100
        SendInput ^z
    Return

#Include %A_ScriptDir%\..\Web\Youtube Keys.ahk
