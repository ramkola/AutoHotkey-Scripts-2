pair_wintitle = Openload.co Pair - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
If Not WinExist(pair_wintitle)
    Run, https://olpair.com
countx = 0
While Not WinActive(pair_wintitle) and countx < 1000
{
    WinActivate, %pair_wintitle%
    Sleep 1
    countx++
}
If Not WinActive(pair_wintitle)
{
    MsgBox, 48,, % "Could not navigate to Openload pairing", 10
    ExitApp
}
WinMaximize, %pair_wintitle%
WinGetPos, x, y, w, h, %pair_wintitle%
; captcha checkbox click
x := (w/2) - 130
y := h/2 + 35
Sleep 5000
Click %x%, %y%
; pair button click
Sleep 3000
Click 650, 920
;-------------------------------------------------------------------------
pair_wintitle = VideoShare Pair - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
If Not WinExist(pair_wintitle)
    Run, https://vshare.eu/pair
countx = 0
While Not WinActive(pair_wintitle) and countx < 1000
{
    WinActivate, %pair_wintitle%
    Sleep 1
    countx++
}
If Not WinActive(pair_wintitle)
{
    MsgBox, 48,, % "Could not navigate to Vshare.eu pairing", 10
    ExitApp
}
WinMaximize, %pair_wintitle%
; captcha checkbox click
Sleep 2000
Click, Left  ,  516,  518
; pair button click
Sleep 1000
Click, Left  ,  650,  646
; ---------------------------------------------------------------------
pair_wintitle = Pair - Vevio - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
If Not WinExist(pair_wintitle)
    Run, https://vev.io/pair
countx = 0
While Not WinActive(pair_wintitle) and countx < 1000
{
    WinActivate, %pair_wintitle%
    Sleep 1
    countx++
}
If Not WinActive(pair_wintitle)
{
    MsgBox, 48,, % "Could not navigate to Vev.io pairing", 10
    ExitApp
}
WinMaximize, %pair_wintitle%
Sleep 10000
Click 250, 510
ExitApp