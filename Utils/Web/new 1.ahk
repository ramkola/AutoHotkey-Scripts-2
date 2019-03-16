#SingleInstance Force
SetTitleMatchMode RegEx
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
gowatchseries_wintitle = ^Watch.*Season \d{1,2} Episode \d{1,3}.*Watchseries - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %gowatchseries_wintitle%
WinWaitActive, %gowatchseries_wintitle%,,2
; ImageSearch,x,y,400, 400, 600, 600,*2 GoWatchSeries - small screen maximized - zoom100 Pango 80 - ServerHD Start Button.png
MouseMove 0,0
ImageSearch,x,y,0,0,A_ScreenWidth,A_ScreenHeight,*2 GoWatchSeries - small screen maximized - zoom100 Pango 80 - ServerHD Start Button.png
OutputDebug, % "ErrorLevel: " ErrorLevel
If x
    MouseMove x+20, y+15
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
