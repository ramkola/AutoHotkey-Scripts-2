#SingleInstance Force
SetTitleMatchMode 2
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\GamesLol.net.png
If WinExist("DebugView on \\HOME-DELL (local) ahk_class dbgviewClass ahk_exe Dbgview.exe")
    WinMinimize

monopoly_wintitle = Monopoly - Play Free Online Games - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
#If WinActive(monopoly_wintitle)
WinActivate, %monopoly_wintitle%
SetTimer, EXIT_NOW, 5000
Goto START_MONOPOLY
Return
; ================================================================================

/* 	
    Window size & pos: Maximized on small screen
    Monopoly zoom level: 170

    Client:	x: 0	y: 111	w: 1280	h: 881
*/
;----------------------------------------------
; Confirmations.........
Space::                        
v::
    Click 490, 530             ; Roll dice & end turn
    Click 420, 710             ; Ok
    Click 465, 618             ; Close
    Return
;-----------------------------------------------------------------------------------
t:: Click 890, 910             ; Trade
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

x::
    MouseClickDrag Left, 630, 345, 720, 345
    Return

START_MONOPOLY:
    If Not WinExist(monopoly_wintitle)
    {
        Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
        WinWaitActive, Google - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,5
        Run, http://en.gameslol.net/monopoly-1122.html
    }
    WinActivate, %monopoly_wintitle%
    WinMaximize
    Sleep 5000  ; wait for page to finish loading
    SetMouseDelay 100
    ; Adjust Zoom to 170
    SendInput {Click, Left, Down, 630, 345}
    Click, 720, 345
    ; Scroll Page Down
    SendInput {Click, Left, Down, 1280, 190}
    Click 1280, 245
    ; Initial Game Setup
    SetMouseDelay 100    
    Click, 657, 843     ; New Game button
    Sleep 100
    Click, 373, 680     ; Change my player icon to a car
    Click, 455, 460
    ; Add and configure additional players
    Click, 792, 845     ; Add player
    Sleep 1000
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
    Return

EXIT_NOW:
    If WinExist(monopoly_wintitle)
        Return
    Else
        ExitApp

^+x::ExitApp
