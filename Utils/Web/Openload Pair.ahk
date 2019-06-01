ol_wintitle = Openload.co Pair - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe

If Not WinExist(ol_wintitle)
    Run, https://olpair.com

countx = 0
While Not WinActive(ol_wintitle) and countx < 1000
{
    WinActivate, %ol_wintitle%
    Sleep 1
    countx++
}
OutputDebug, % "countx: " countx
If Not WinActive(ol_wintitle)
{
    MsgBox, 48,, % "Could not navigate to Openload pairing", 10
    ExitApp
}
WinMaximize, %ol_wintitle%
WinGetPos, x, y, w, h, %ol_wintitle%
; captcha checkbox click
x := (w/2) - 130
y := h/2 + 35
Sleep 5000
Click %x%, %y%
; pair button click
Sleep 3000
Click 650, 920

ExitApp