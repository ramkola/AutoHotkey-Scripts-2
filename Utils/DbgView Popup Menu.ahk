#SingleInstance Force
#NoTrayIcon
dbgview_win := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
#IF WinActive(dbgview_win)

Menu, dbgview, Add, Auto Scroll, MENUHANDLER
Menu, dbgview, Add, Always On Top, MENUHANDLER
Menu, dbgview, Add, Clear Display, MENUHANDLER
Menu, dbgview, Add, Copy, MENUHANDLER

RButton::
AppsKey:: Menu, dbgview, Show

MENUHANDLER:
    if (A_ThisMenuItem = "Auto Scroll")
    {
        WinMenuSelectItem, %dbgview_win%,,Options,Auto Scroll
        Menu, dbgview, ToggleCheck, Auto Scroll
    }
    Else if (A_ThisMenuItem = "Always On Top")
    {
        WinMenuSelectItem, %dbgview_win%,,Options,Always On Top
        Menu, dbgview, ToggleCheck, Always On Top
    }
    Else if (A_ThisMenuItem = "Clear Display")
        WinMenuSelectItem, %dbgview_win%,,Edit,Clear Display
    Else if (A_ThisMenuItem = "Copy")
        WinMenuSelectItem, %dbgview_win%,,Edit,Copy
    Return
