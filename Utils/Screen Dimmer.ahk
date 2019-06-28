#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
g_TRAY_MENU_ON_LEFTCLICK := True 
Menu, Tray, Icon, ..\Resources\32x32\Brightness.png
Menu, Tray, Add
Menu, Tray, Add
Menu, Tray, Add, % "Brighter", BRIGHTER
Menu, Tray, Add, % "Darker", DARKER
Menu, Tray, Add, % "Show Level", SHOW_LEVEL
Menu, Tray, Add, % "List Hotkeys", LIST_MYHOTKEYS

intensity_pct := Round(A_Args[1], -1)       ; force any argument to be rounded to the nearest 10
If (intensity_pct < 1) or (intensity_pct > 100)
    intensity := 130
Else
    intensity := intensity_pct / 100 * max_darkness

; On screen display (OSD) of dimmer level percent
osd_transcolor = Black
Gui, OSD:Default
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow 
Gui, Color, %osd_transcolor%
Gui, Font, s24
Gui, Add, Text, x0 y0 vdimmer_pct Center cLime, `r`n  `%100    (255)  `r`n
GuiControlGet, dp_, Pos, dimmer_pct
gui_x := A_ScreenWidth/2 - dp_w/2
Gui, Show, x%gui_x% y%dp_y% w%dp_w% h%dp_h% NoActivate, OSD
Gui, Show, x%gui_x% y10 w%dp_w% h%dp_h% NoActivate, OSD

; Screen dimmer window
max_darkness := 255         ; a number between 0-255. The closer to 255 the darker it gets. 
increment := 10
Gui 1:Default
Gui, Color, Black
Gui, +LastFound  -Caption +ToolWindow 
Gui, +E0x20    ; E0x20 - Click through GUI always on top.
WinSet, Transparent, %Intensity%
Gui, Show, NA x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%, Screen Dimmer
GoSub, #Up

SetTimer, STAY_TOP_MOST, 100
Return

#Up::   ; decrease brightness    
#Down:: ; increase brightness  
    ; ttip("`r`nA_ThisHotkey: " A_ThisHotkey " `r`n ",1500)
    ; If menu_up or menu_down
    ; {
        ; If menu_up
            ; intensity += increment
        ; Else
            ; intensity -= increment
    ; }
    ; Else 
    ; {
        If (A_ThisHotkey = "#Down") or menu_down
            intensity -= increment
        Else If (A_ThisHotkey = "#Up") or menu_up
            intensity += increment
    ; }
    intensity := (intensity > max_darkness) ? max_darkness : intensity
    intensity := (intensity < 0) ? 0 : intensity        
    WinSet, Transparent, %intensity%, Screen Dimmer 

    dimmer_level_pct := Round((intensity / max_darkness) * 100, -1)
    Gui, OSD:Default
    WinSet, TransColor, 99999, OSD      ; Turn off transcolor to show background for dimmer_pct
    GuiControl,, dimmer_pct, `r`n  `%%dimmer_level_pct%   (%intensity%)  `r`n
    Sleep 200
    GuiControl,, dimmer_pct
    WinSet, TransColor, %osd_transcolor%, OSD   ; turn on transcolor to make OSD disappear and clickthru
Return

STAY_TOP_MOST:
    WinSet, AlwaysOnTop,, Screen Dimmer
    WinSet, AlwaysOnTop,, OSD
    WinSet, Top,, Screen Dimmer
    WinSet, Top,, OSD
    Return
    
;-------------
; Menu Labels
;-------------
BRIGHTER:
    menu_up := True
    Gosub #Up
    menu_up := False
    Return

DARKER:
    menu_down := True
    Gosub #Up
    menu_down := False
    Return
    
SHOW_LEVEL:
    MsgBox, 64, Dimmer Level, % "%" dimmer_level_pct, 3
    Return

LIST_MYHOTKEYS:
    list_hotkeys()
    Return
