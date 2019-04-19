#NoEnv
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#NoTrayIcon
SetTitleMatchMode 2

; Docked windows
Loop, 20
    click_close_button("Button" A_Index)

; If windows are undocked
Loop
{
    dialog_hwnd := WinExist("ahk_class #32770 ahk_exe notepad++.exe")
    If (dialog_hwnd == "0x0")
        Break

    If (dialog_hwnd = cant_close_h wnd)
    {
        dialog_classnn := get_classnn(WinExist("A"), dialog_hwnd)
        ControlGetText, dialog_text, %dialog_classnn%, A
        WinGetTitle, dialog_title, ahk_id %dialog_hwnd%
        WinGetClass, dialog_class, ahk_id %dialog_hwnd%
        OutputDebug, % "Can't Close: " dialog_text ", " dialog_title ", " dialog_class " - " A_ScriptName
        Break
    }

    WinClose, ahk_id %dialog_hwnd%
    Sleep 10
    If WinExist("ahk_id " dialog_hwnd)
        PostMessage, 0x112, 0xF060,,, ahk_id %dialog_hwnd%  ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
    Sleep 10    
    If WinExist("ahk_id " dialog_hwnd)
    {
        ; this one works more reliably than all the others on windows that don't want to close
        WinGetPos, x, y, w, h, ahk_id %dialog_hwnd%
        OutputDebug, % "x, y, w, h: " x ", " y ", " w ", " h
        MouseMove, x+w, y-3
        Click
    }
    Sleep 10
    If WinExist("ahk_id " dialog_hwnd)
        WinKill, ahk_id %dialog_hwnd%
    cant_close_hwnd := dialog_hwnd
}
ExitApp

click_close_button(p_control_classNN)
{    
    ; make sure clicking on a visible button 
    ControlGet, is_visible, Visible,, %p_control_classNN%, A
    If is_visible
    {    
        ControlGetPos,,, w, h, %p_control_classNN%, A
        x := w - 9
        y := h / 2
        ControlClick, %p_control_classNN%, A,,,, NA X%x% Y%y%  
    }
    Else
        OutputDebug, % "Skipping...." p_control_classNN
    Return
}

^+p::Pause
^+x::ExitApp
