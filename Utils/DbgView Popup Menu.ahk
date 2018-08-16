#SingleInstance Force
#NoTrayIcon
SetTimer, EXITCHECK, 10000
dbgview_win := "ahk_class dbgviewClass ahk_exe Dbgview.exe"

Menu, dbgview, Add, Auto Scroll, MENUHANDLER
Menu, dbgview, Add, Always On Top, MENUHANDLER
Menu, dbgview, Add, Clear Display, MENUHANDLER
Menu, dbgview, Add, Copy, MENUHANDLER

#If WinActive(dbgview_win)
RButton::
AppsKey:: Menu, dbgview, Show

MENUHANDLER:
    If (A_ThisMenuItem = "Auto Scroll")
    {
        WinMenuSelectItem, %dbgview_win%,,Options,Auto Scroll
        Menu, dbgview, ToggleCheck, Auto Scroll
    }
    Else If (A_ThisMenuItem = "Always On Top")
    {
        WinMenuSelectItem, %dbgview_win%,,Options,Always On Top
        Menu, dbgview, ToggleCheck, Always On Top
    }
    Else If (A_ThisMenuItem = "Clear Display")
        WinMenuSelectItem, %dbgview_win%,,Edit,Clear Display
    Else If (A_ThisMenuItem = "Copy")
        WinMenuSelectItem, %dbgview_win%,,Edit,Copy
    Return

EXITCHECK:
    If Not WinExist(dbgview_win)
        ExitApp
