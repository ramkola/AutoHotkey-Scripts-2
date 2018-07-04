; still needs work on undocked window

control_classnn := "TDebugBreakpointsForm11"
CoordMode, Mouse, Window

; check if breakpoints panel has been repositioned already
ControlGetPos, x_2 , y_2, width_2, height_2, TDebugContextForm1, ahk_class Notepad++
ControlGetPos, x, y, width, height, %control_classnn%, ahk_class Notepad++
if (x = x_2) and (y  > (y_2 + height_2))
    return

; reposition breakpoints panel
if WinExist("ahk_class TJvDockTabHostForm ahk_exe notepad++.exe")
{
    ; breakpoints panel is undocked
    WinActivate, ahk_class TJvDockTabHostForm ahk_exe notepad++.exe
    click
    WinGetPos, x, y, w, h, ahk_class TJvDockTabHostForm ahk_exe notepad++.exe
    x += 150
    y += 2
}
else
{
    ; assumed to be docked 
    ControlFocus, %control_classnn%, ahk_class Notepad++ 
    ControlGetPos, x, y, width, height, %control_classnn%, ahk_class Notepad++
    x += 5
    y -= 2
}
MouseMove, x, y
Click, x, y, Left, Down  ; click and drag the panel 
Click, x, (y + 5), 0     ; undocks the panel from the frame (if docked)

; new position is stacked under the watches/global/local context panel
ControlGetPos, x, y, width, height, TJvDockVSNETPanel1, ahk_class Notepad++
; need to placed where it will snap in correctly
x += 100
y := height
MouseMove, x, y
Click            ; completes the move and snaps the panel into place.


ExitApp

