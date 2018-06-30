#NoTrayIcon
SetTitleMatchMode 1
; window is docked
ControlGet, is_visible, Visible,, %p_control_classNN%, A
if is_visible
    click_close_button("Button1")   ; Find Results

;window is undocked
undocked := WinExist("Find result ahk_class #32770 ahk_exe notepad++.exe")
if undocked
    WinClose

; 
if not is_visible and not undocked
    WinMenuSelectItem, ahk_class Notepad++,, Search, Search Results Window

ExitApp
 
click_close_button(p_control_classNN)
{    
    ControlGet, is_visible, Visible,, %p_control_classNN%, A
    if is_visible
    {    
        ControlGetPos, X, Y, Width, Height, %p_control_classNN%, A
        X := Width - 9
        Y := 5
        ControlClick, %p_control_classNN%, A,,,, NA x%X% y%Y%  
    }
    Return
}    