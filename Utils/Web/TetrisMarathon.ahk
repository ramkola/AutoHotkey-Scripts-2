/* 
    Chrome Window x: 793	y: 0	w: 494	h: 991
    Page zoom %110
    Pangolin Screen Brightness %60 - %80
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk

OnExit("restore_cursors")
SetTitleMatchMode RegEx
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\TetrisFriends.png
Menu, Tray, Add, Start Tetris, START_TETRIS
g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
; g_TRAY_RELOAD_ON_LEFTCLICK := True      ; see lib\utils.ahk

; Tetris Marathon - Free online Tetris game at Tetris Friends - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
tetris_wintitle = ^Tetris Marathon.*Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
youtube_wintitle = ^.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
kodi_wintitle = Kodi ahk_class Kodi ahk_exe kodi.exe
#If WinActive(tetris_wintitle)

If WinExist(youtube_wintitle)
    WinActivate, %youtube_wintitle%
If WinExist(kodi_wintitle)
    WinActivate, %kodi_wintitle%
If WinExist(tetris_wintitle)
    WinActivate, %tetris_wintitle%
Else
    Goto START_TETRIS

Return

START_TETRIS:
    If WinExist(tetris_wintitle)
        WinActivate, %tetris_wintitle%
    Else
    {
        Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
        WinWaitActive, Google - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,5
        Run, "https://www.tetrisfriends.com/games/Marathon/game.php"
    }
    Return
; ==============================================================
1::
2::
^a::
!a::
!Enter::    ; start new game from end of game page
{  
    set_system_cursor("IDC_WAIT")
    KeyWait, Control, T1 
    KeyWait, Alt, T1
    KeyWait, Enter, T1
    KeyWait, a, T1
    BlockInput, MouseMove
    BlockInput, SendAndMouse
    BlockInput, On
    ;
    If (A_ThisHotkey != "1") and (A_ThisHotkey != "2")
    {
        SendInput {Enter}   ; play again button on results page
        WinWaitActive, %tetris_wintitle%,,3
        If ErrorLevel
            Goto ABORT_STARTGAME
        Sleep 3000          ; wait for game page to load.
    }

    If (A_ThisHotkey != "2")
        SendEvent {Click, 77, 972, Down}{Click 175, 972, Up}  ; scroll game window

    retry_imagesearch := True
RETRY_SEARCH:
    ; Click Start Button
    SetWorkingDir, C:\Users\Mark\Desktop\Misc\resources\Images\TetrisMarathon\
    msg:=x:=y:=x1:=y1:=w1:=h1:=ErrorLevel:=0
    WinGetPos, x1, y1, w1, h1, A

    ImageSearch, x, y, w1/2, h1/2, A_ScreenWidth, A_ScreenHeight, *2 TetrisMarathon - Pango 70 - Zoom 110 - Start Button.png
    If Not ErrorLevel
        Goto CLICK_START_BUTTON

    ImageSearch, x, y, w1/2, h1/2, A_ScreenWidth, A_ScreenHeight, *2 TetrisMarathon - Pango 80 - Zoom 110 - Start Button.png
    If Not ErrorLevel
        Goto CLICK_START_BUTTON

    ImageSearch, x, y, w1/2, h1/2, A_ScreenWidth, A_ScreenHeight, *2 TetrisMarathon - Pango 60 - Zoom 110 - Start Button.png
    If ErrorLevel and retry_imagesearch
    {
        retry_imagesearch := False
        Sleep 3000
        Goto RETRY_SEARCH
    }

CLICK_START_BUTTON:
    If Not ErrorLevel
    {
        x += 80
        y += 40
        Click %x%, %y%          ; start button
        Sleep 3500              ; wait for 1,2,3,Go Countdown to finish
        SendInput {Control}     ; pause game
        MouseMove 9999, 200     ; hide mouse
    }
    Else
    {
            msg :=  "x, y: " x ", " y " ErrorLevel: " ErrorLevel
            msg := msg "`r`n`r`nImageSearch requirements: "
            msg := msg "`r`n`r`n Pangolin Screen Brightness %60 - 80"
            msg := msg "`r`n`r`n Chrome Zoom Level %110"
    }
    
ABORT_STARTGAME:
    BlockInput, MouseMoveOff
    BlockInput, Default
    BlockInput, Off
    restore_cursors()
    If (msg != 0)
        MsgBox, 48,, %msg%
    ; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Return
}

s::     ; show stats of last game played from end of game page
{
    CoordMode, Mouse, Screen
    BlockInput, On
    SendInput {Left 4}
    Sleep 10
    Click, 910, 300     ; stats tab
    Sleep 1000
    SendInput {Right 4}
    MouseMove 9999, 200   ; move mouse off screen (hide)
    BlockInput, Off
    Return   
}

r::     ; resume play
{
    CoordMode, Mouse, Screen
    Click, 1140, 750
    MouseMove 9999, 200
    Return   
}

F9::    ; end game by hard dropping remaining pieces
{
    Loop 75
        Send {Space Down}{Space Up}
    Return
}      

^+x::ExitApp

#Include %A_ScriptDir%\Youtube Keys.ahk
#Include %A_ScriptDir%\Kodi Shortcuts.ahk
