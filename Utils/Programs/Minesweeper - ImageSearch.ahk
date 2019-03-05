/* 
    
   *** NOT RELIABLE ***

*/

#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
 g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\Minesweeper\1280x1024 Fullscreen Pango 100\
OutputDebug, DBGVIEWCLEAR
CoordMode, Mouse, Screen
minesweeper_wintitle = Minesweeper ahk_class Minesweeper ahk_exe Minesweeper.exe
If WinExist(minesweeper_wintitle)
WinActivate
last_line_found := 0
exit_now := False
While (ErrorLevel = 0) and (exit_now = False)
{
    ImageSearch, x, y, x1, y1, A_ScreenWidth, A_ScreenHeight,*100 *TransBlack Square2.png
    If (ErrorLevel = 0)
    {
        OutputDebug, % "x, y: " x ", " y
        MouseMove, x, y
        Sleep 300
        last_line_found := y
        x1 := x + 45
    }
    Else
    {
        x1 := 250
        y1 := last_line_found + 45
        If (y1 <> new_line_number)
        {
            OutputDebug, % "Search new line from starting coordinates: " x1 "," y1
            new_line_number := y1   ; if this number repeats itself then there are no more squares to search
            ErrorLevel := 0
        }
    }
}
If ErrorLevel
    OutputDebug, % "ErrorLevel: " ErrorLevel

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    
Return

^+x:: exit_now := True



/* 
Uncovered_square_bg = DCE6F1    ; greyish blue
Uncovered_square_1 = 4F60C5     ; navy blue
Uncovered_square_2 = 216705     ; dark green
Uncovered_square_3 = A60703     ; red
Uncovered_square_4 = 00057B     ; dark blue
Uncovered_square_5 = 7A0100     ; maroon
Uncovered_square_6 = 015E5E     ; turqoise 
*/


/*
    PixelSearch, x, y, x1, y1, x1, y1, Uncovered_square_bg, 50
    If (ErrorLevel = 0)
    {
        OutputDebug, % "found Uncovered_square_bg"
        Goto SEND_MBUTTON
    }
    PixelSearch, x, y, x1, y1, x1, y1, Uncovered_square_1, 5
    If (ErrorLevel = 0)
    {
        OutputDebug, % "found Uncovered_square_1"
        Goto SEND_MBUTTON
    }
    PixelSearch, x, y, x1, y1, x1, y1, Uncovered_square_2, 5
    If (ErrorLevel = 0)
    {
        OutputDebug, % "found Uncovered_square_2"
        Goto SEND_MBUTTON
    }
    PixelSearch, x, y, x1, y1, x1, y1, Uncovered_square_3, 5
    If (ErrorLevel = 0)
    {
        OutputDebug, % "found Uncovered_square_3"
        Goto SEND_MBUTTON
    }
    PixelSearch, x, y, x1, y1, x1, y1, Uncovered_square_4, 5
    If (ErrorLevel = 0)
    {
        OutputDebug, % "found Uncovered_square_4"
        Goto SEND_MBUTTON
    }
    PixelSearch, x, y, x1, y1, x1, y1, Uncovered_square_5, 5
    If (ErrorLevel = 0)
    {
        ; OutputDebug, % "found Uncovered_square_5"
        Goto SEND_MBUTTON
    }
    PixelSearch, x, y, x1, y1, x1, y1, Uncovered_square_6, 5
    If (ErrorLevel = 0)
    {
        OutputDebug, % "found Uncovered_square_6"
        Goto SEND_MBUTTON
    }
    PixelGetColor, color_code, x1, y1
    OutputDebug, % "color_code: " color_code " ErrorLevel: " ErrorLevel
    Continue
    
SEND_MBUTTON:        
*/
