/* 
    Chrome Window x: 793	y: 0	w: 494	h: 991
    Page zoom %110
    Pangolin Screen Brightness %60 %70 %80 or %100
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\trayicon.ahk
#Include lib\pango_level.ahk
SetTitleMatchMode RegEx
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
tetris_wintitle = ^Tetris Marathon.*Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
youtube_wintitle = ^.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
kodi_wintitle = Kodi ahk_class Kodi ahk_exe kodi.exe
If WinExist(youtube_wintitle)
    Run, %A_ScriptDir%\Youtube Keys.ahk
If WinExist(kodi_wintitle)
    Run, %A_ScriptDir%\Kodi Shortcuts.ahk

default_pango_level = 80
pango_level := pango_level(0)
If Not RegExMatch(pango_level,"(60|70|80|100)")
    If (pango_level(default_pango_level) <> default_pango_level)
       MsgBox, 48,, % "Couldn't Set Pango Level. Set it manually to either 60, 70, 80 or 100."
    Else
        pango_level := default_pango_level
       
OnExit("restore_cursors")
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\TetrisFriends.png
Menu, Tray, Add, Start Tetris, START_TETRIS
; g_TRAY_EXIT_ON_LEFTCLICK := True      ; see lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; see lib\utils.ahk
SetTimer, EXIT_APP, 5000

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

EXIT_APP:
    If WinExist(tetris_wintitle)
        Return
    Else
        ExitApp
    
; ==============================================================
1::      ; start game from game page scrolled left
2::      ; start game from game page scrolled right to correct location
!a::     ; start game from end of game page 
!Enter:: ; start game from end of game page 
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
    If (A_ThisHotkey = "!a") or (A_ThisHotkey = "!Enter")
    {
        SendInput {Enter}   ; play again button on results page
        WinWaitActive, %tetris_wintitle%,,3
        If ErrorLevel
            Goto ABORT_STARTGAME
    }
    
    SetWorkingDir, C:\Users\Mark\Desktop\Misc\resources\Images\TetrisMarathon\
    WinGetPos, x1, y1, w1, h1, A
    If (A_ThisHotkey != "2")
    {
        countx := 0
        ErrorLevel := 9999
        ; While Loop is waiting for the game to load for the "Hold" image to appear.
        While (ErrorLevel and countx < 20)  
        {
            countx++
            ; ImageSearch, x, y, 1000, 100, 1500, 450, *2 TetrisMarathon - Pango %pango_level% - Zoom 110 - Hold.png
            ImageSearch, x, y, x1, y1, x1+w1, y1+h1, *2 TetrisMarathon - Pango %pango_level% - Zoom 110 - Hold.png
            Sleep 500
        }                   
        If ErrorLevel
            Goto HANDLE_ERRORLEVEL
        Else
            SendEvent {Click, 880, 972, Down}{Click 983, 972, Up}  ; scroll game window
    }

    ; Click Start Button
    Sleep 1000
    ImageSearch, x, y, w1/2, h1/2, A_ScreenWidth, A_ScreenHeight, *2 TetrisMarathon - Pango %pango_level% - Zoom 110 - Start Button.png
HANDLE_ERRORLEVEL:    
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
            msg := msg "`r`n`r`n Pangolin Screen Brightness %60 - 80, 100"
            msg := msg "`r`n`r`n Chrome Zoom Level %110"
    }
    
ABORT_STARTGAME:
    BlockInput, MouseMoveOff
    BlockInput, Default
    BlockInput, Off
    restore_cursors()
    ; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    If (msg != "")
        MsgBox, 48,, %msg%
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
    Click, 1130, 735
    MouseMove 9999, 200
    Return   
}

F9::    ; end game by hard dropping remaining pieces
{
    Loop 75
        Send {Space Down}{Space Up}
    Return
}      

q::SendInput {Escape}

^+k:: list_hotkeys()

^+p::Pause
^+x::ExitApp
