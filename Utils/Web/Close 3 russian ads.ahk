#SingleInstance Force
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\EuroSport
SetTitleMatchMode RegEx
OutputDebug, DBGVIEWCLEAR
win_title = IrfanView ahk_class IrfanView ahk_exe i_view32.exe
win_title = ^.*? - Aliez - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
win_title = LiveTV / WebPlayer - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %win_title% 
WinWaitActive, %win_title% 
;-------------------------------------
; find and click: close ad buttons
;-------------------------------------
countx := ErrorLevel := save_coords := 0 
ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight,*5 ads - close button1.png
save_coords := x "," y
MouseMove, x, y
Click
OutputDebug, % "ad1 closes: " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel

ImageSearch, x, y, 0, 0, A_ScreenWidth,A_ScreenHeight,*5 ads - close button2.png
save_coords := x "," y
MouseMove, x, y
Click
OutputDebug, % "ad2 closes: " save_coords " - countx: " countx " - ErrorLevel: " ErrorLevel

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
exitapp
While (ErrorLevel = 0) and countx < 5
{
    If (ErrorLevel = 0)
    {
        save_coords := x "," y
        MouseMove, x+10, y+10
        ; Click
    }
    countx++
}
OutputDebug, % "ad closes: " save_coords " - countx: " countx
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe