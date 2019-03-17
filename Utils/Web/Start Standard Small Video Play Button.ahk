#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_SUSPEND_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetTitleMatchMode RegEx
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images
win_title = Porn in Fifteen Seconds - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
If WinExist(win_title)
{
    If Not WinActive
        WinActivate
}
Return

;=============================================================

#IF WinExist(win_title)

!Down::
!PgDn::
RButton::
~PgDn::
~Down::
~RAlt::
    IF (A_ThisHotkey = "!PgDn")
    {
        SendInput {PgDn}
        Return
    }
    IF (A_ThisHotkey = "!Down")
    {
        SendInput {Down}
        Return
    }
    KeyWait, PgDn
    KeyWait, Down
    KeyWait, LAlt
    KeyWait, RAlt
    BlockInput, On
    MouseMove 10,10  
RETRY:
    ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*80 Pango 80 - Video Start Button.png
    If (ErrorLevel = 0)
    {
        MouseMove, x+5, y+10
        Click
    }
    BlockInput, Off
    Return