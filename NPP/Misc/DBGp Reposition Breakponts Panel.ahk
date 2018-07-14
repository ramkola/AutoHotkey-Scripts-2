countx := 0
keep_looping := True
While keep_looping and countx < 10  
{
    breakpoints_classnn := "TDebugBreakpointsForm11"
    context_panel_classnn := "TDebugContextForm1"
    CoordMode, Mouse, Window

    ; check if breakpoints panel has been repositioned already
    ControlGetPos, x_cp , y_cp, w_cp, h_cp, %context_panel_classnn%, ahk_class Notepad++
    ControlGetPos, x, y, width, height, %breakpoints_classnn%, ahk_class Notepad++
    If (x = x_cp) and (y  > (y_cp + h_cp))
    {
         ExitApp
    }
    
    ; reposition breakpoints panel
    If WinExist("ahk_class TJvDockTabHostForm ahk_exe notepad++.exe")
    {
        ; breakpoints panel is undocked - floating window
        CoordMode, Mouse, Screen
        WinActivate, ahk_class TJvDockTabHostForm ahk_exe notepad++.exe
        WinGetPos, x, y, w, h, ahk_class TJvDockTabHostForm ahk_exe notepad++.exe
        x += 150
        y += 15
        docked := False
    }
    Else
    {
        ; assumed to be docked - coordmode is window
        ControlFocus, %breakpoints_classnn%, ahk_class Notepad++ 
        ControlGetPos, x, y, width, height, %breakpoints_classnn%, ahk_class Notepad++
        x += 5
        y -= 2
        docked := True
        ControlGetFocus, got_focus, A
    }
    If Not docked and Not WinActive("ahk_class TJvDockTabHostForm ahk_exe notepad++.exe")    
        Goto LOOPCHECK    ; didn't work try again
    If docked and (got_focus <> breakpoints_classnn)
        Goto LOOPCHECK    ; didn't work try again

        ; grab breakpoints window / panel
        MouseMove, x, y
        Click, x, y, Left, Down  ; click and drag the panel 
        Click, x, (y + 5), 0     ; undocks the panel from the frame (if docked)
        
        ; new position is stacked under the watches/global/local context panel
        ControlGetPos, x, y, width, height, TJvDockVSNETPanel1, ahk_class Notepad++
        ; need to placed where it will snap in correctly
        x += 100
        y := height + 3 
        MouseMove, x, y
        Click            ; completes the move and snaps the panel into place.

LOOPCHECK:
        ControlGetPos, x_check, y_check, width, height, %breakpoints_classnn%, ahk_class Notepad++
        Sleep 100
        keep_looping := (x_check != x_cp) or Not (y_check > (y_cp + h_cp)) 
        countx++

        OutputDebug, % "-------------------------------------------"
        OutputDebug, % "x_check: " x_check "    x_cp: " x_cp
        OutputDebug, % "y_check: " y_check "    y_cp: " y_cp
        OutputDebug, % "countx: " countx "   keep_looping: " keep_looping
}

ExitApp

^p::Pause
^x::ExitApp

