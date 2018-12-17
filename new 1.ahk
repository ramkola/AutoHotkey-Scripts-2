#^+n::   ; Close all untitled Notepad windows
{
    win_title := "Untitled - Notepad ahk_class Notepad ahk_exe Notepad.exe"
    While WinExist(win_title)
    {
        WinClose, %win_title%
        ; click don't save
        If WinExist("Notepad ahk_class #32770 ahk_exe Notepad.exe")
            ControlClick, Button2, A
    }
    Return
}