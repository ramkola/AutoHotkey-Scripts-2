#SingleInstance Force
SetTitleMatchMode 2
Menu, Tray, Icon, C:\Program Files (x86)\JHC Software Limited\Snooker147 & Poolster\Snooker147\Snooker147.exe
OutputDebug, DBGVIEWCLEAR
win_title = TSnooker 147 - Version 1.3 ahk_class OwlWindow ahk_exe Snooker147.exe
#If WinActive(win_title)

~RButton:
    OutputDebug, % "here"
    Sleep 1000
    SendInput ^z
