#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
OnExit("restore_cursors")
SetTitleMatchMode 2
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\GamesLol.net.png
Menu, Tray, Add, % "List Hotkeys", ^+k
If WinExist("DebugView on \\HOME-DELL (local) ahk_class dbgviewClass ahk_exe Dbgview.exe")
    WinMinimize

monopoly_wintitle = Monopoly - Play Free Online Games - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(monopoly_wintitle)
WinActivate, %monopoly_wintitle%
; SetTimer, EXIT_APP, 5000
; If Not WinExist(monopoly_wintitle)
    ; start_monopoly(monopoly_wintitle)
Return
; ================================================================================

/* 	
    Window size & pos: Maximized on small screen
    Monopoly zoom level: 170

    Client:	x: 0	y: 111	w: 1280	h: 881
*/
;----------------------------------------------
; Confirmations.........
Space::                        ; press button for Roll Dice/End Turn/Ok/Close                 
v::                            ; press button for Roll Dice/End Turn/Ok/Close
    Click 490, 530             ; Roll dice & end turn
    Click 420, 710             ; Ok
    Click 465, 618             ; Close
    Return
;-----------------------------------------------------------------------------------
t:: Click 890, 905             ; Trade
Up::Click 315, 700             ; Trade - left side cash transfer increase
Down:: Click 315, 722          ; Trade - left cash transfer decrease
+Up::Click 525, 700            ; Trade - right side cash transfer increase
+Down:: Click 525, 722         ; Trade - right cash transfer decrease
o:: Click 425, 663             ; Trade - offer
;-----------------------------------------------------------------------------------
b:: Click 302, 700             ; For Sale - Buy property
a:: Click 513, 700             ; For Sale - Auction property
.:: Click 423, 700             ; For Sale - Auction - Increase Bid  (>)
,:: Click 423, 722             ; For Sale - Auction - Decrease Bid  (<)
RAlt::  Click 560, 660         ; For Sale - Auction - Bid Button
+RAlt:: Click 560, 710         ; For Sale - Auction - Fold Button
;-----------------------------------------------------------------------------------

start_monopoly(monopoly_wintitle)
{
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
    WinWaitActive, Google - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,5
    Run, http://en.gameslol.net/monopoly-1122.html
    SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\Monopoly
    ;
    BlockInput, On
    set_system_cursor("IDC_WAIT")
    WinActivate, %monopoly_wintitle%
    WinMaximize
    ErrorLevel = 9999
    While ErrorLevel and countx < 20
    {
        ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*5 Zoom 100 Pango 70 - New Game Button.png
        If ErrorLevel
            Sleep 1000
        countx++
    }
    OutputDebug, % "x, y: " x ", " y " - ErrorLevel: " ErrorLevel " - countx: " countx
    Sleep 2000  ; wait for page to finish loading
    SetMouseDelay 100
    ; Adjust Zoom to 170
    SendInput {Click, Left, Down, 630, 345}
    Click, 720, 345
    ; Scroll Page Down
    SendInput {Click, Left, Down, 1280, 190}
    Click 1280, 245
    ; Initial Game Setup
    Click, 657, 843     ; New Game button
    Sleep 6000
    Click, 373, 680     ; Change my player icon to a car
    Click, 455, 460
    ; Add and configure additional players
    Click, 792, 845     ; Add player
    Sleep 3000
    Click, 792, 845     ; Add player
    Click, 435, 600     ; Set level to Tycoon
    Click, 720, 600     ; Set level to Tycoon
    Click, 1010, 600    ; Set level to Tycoon
    Click, 1080, 840    ; Play button
    Sleep 2000
    ; Turn Sound Off
    Click, 170, 895     ; Menu Open
    Sleep 300
    Click, 160, 580     ; Sound Off
    Click, 160, 780     ; Resume
    BlockInput, Off
    restore_cursors()
    SetMouseDelay, -1
    Return
}

EXIT_APP:
    If WinExist(monopoly_wintitle)
        Return
    Else
        ExitApp

^+k:: list_hotkeys(,,18)
