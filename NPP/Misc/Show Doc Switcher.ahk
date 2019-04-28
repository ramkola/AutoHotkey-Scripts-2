#SingleInstance Force
#NoEnv
; #NoTrayIcon
doc_switcher_wintitle = Doc Switcher ahk_class #32770 ahk_exe notepad++.exe
; Button9 = Show/Hide Doc Switcher in Settings/Preferences/General tab.
RunWait, MyScripts\NPP\Misc\Toggle Preferences Setting.ahk On Button9 False False
Sleep 10
If WinExist("Doc Switcher")
{
    WinActivate, Doc Switcher
    WinWaitActive, Doc Switcher,,1
    ControlFocus, SysListView321, A
}
;
WinWaitNotActive, Doc Switcher
RunWait, MyScripts\NPP\Misc\Toggle Preferences Setting.ahk Off Button9 False False
ExitApp

#If WinActive(doc_switcher_wintitle)
~Escape::
~LButton::
~Enter::
    If (A_ThisHotkey = "~LButton")
    {
        double_click := (A_TimeSincePriorHotkey < 500) and (A_TimeSincePriorHotkey <> -1)
        If Not double_click
            Return
    }
    WinClose, %doc_switcher_wintitle%
    Return