;---------------------------------------------------------------------------------------------
; Braces are used to be able to fold (!0) the document the way I want  
;---------------------------------------------------------------------------------------------
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk       
#Include lib\utils.ahk
#Include lib\npp.ahk
#NoEnv
#SingleInstance Force
#MenuMaskKey vk07   ; suppress unwanted win key default activation.
SendMode Input
SetTitleMatchMode %STM_CONTAINS% 
SetTitleMatchMode RegEx
SetWorkingDir %AHK_ROOT_DIR%
SetCapsLockState, AlWaysOff
SetNumLockState, AlWaysOn
Menu, Tray, Icon, ..\resources\32x32\Old Key.png, 1
g_TRAY_MENU_ON_LEFTCLICK := True    ; see lib\utils.ahk

SetTimer, PROCESSMONITOR, 1800000 ; check every 30 minutes 1 minute = 60,000 millisecs

Run, MyScripts\MyHotStrings.ahk
Run, MyScripts\Utils\Tab key For Open or Save Dialogs.ahk
Run, MyScripts\Utils\Web\Load Web Games Keyboard Shortcuts.ahk
; Run, plugins\Convert Numpad to Mouse.ahk
; Run, plugins\Hotkey Help (by Fanatic Guru).ahk      

PROCESSMONITOR:
{
    found := find_process("autohotkey", "monitor keyboard hotkeys")
    If Not found[1]
        Run, MyScripts\Utils\Monitor Keyboard Hotkeys.ahk
    Return
}

;************************************************************************
;
; The following hotkeys are globally available in any window 
; 
;************************************************************************
#IfWinActive
; these are here for documentation only they don't do anything. they "reserve" usage for windows
; #a::Return                   ; Window's view notifications history 
; #d::Return                   ; Window's show desktop toggle (minimize/restore all windows)
; #e::Return                   ; Window's File Explorer
; #h::Return                   ; Windows's Dictation
; #i::Return                   ; Window's Settings
; #l::Return                   ; Window's Lock Screen
; #m::Return                   ; Window's Minimize All Windows
; #w::Return                   ; Window's Ink Workspace  
; #=::Return                   ; Window's Magnifier
; Alt & Tab::Return            ; Window's switch application 
; Alt & Shift & Tab::Return    ; Window's switch application 
; Control & Tab::Return        ; Windows virtual desktop selector
; Control & LWin & Left::      ; Windows move to virtual desktop window on the left
; Control & LWin & Right::     ; Windows move to virtual desktop window on the right

^NumpadDot:: ; Runs MyHotkeys.ahk as administrator avoids User Access Control (UAC) prompt
^.::         ; Runs MyHotkeys.ahk as administrator avoids User Access Control (UAC) prompt
             ; for any program launched by MyHotkeys. Side effect is that all scripts launched will run as administrator.
{
    SendInput ^s    
    Run *RunAs "%A_AHKPath%" /restart "%AHK_ROOT_DIR%\MyScripts\MyHotkeys.ahk" 
    Return
}

^!+CapsLock::SetCapsLockState, On
^!+NumLock::SetNumLockState, Off
#RButton::SendInput {LWin Down}{Tab}    ; virtual desktops
                                ..            
#+=::   ; Activate / Run Notepad++
{
    If WinExist("ahk_class Notepad++ ahk_exe notepad++.exe")
        WinActivate
    Else
        Run, C:\Program Files (x86)\Notepad++\notepad++.exe
    Return
}

^PgDn::     ; Run Browser - Next Numbered Page.ahk
{
    Run, MyScripts\Utils\Web\Browser - Next Numbered Page.ahk
    Return
}

#o::    ; open openload pairing page in browser and clicks the buttons
{
    Run, MyScripts\Utils\Web\Openload Pair.ahk
    Return
}

#h::    ; Doubleclick on mouse hover in selected windows
{
    Run, MyScripts\Utils\Hover Doubleclick.ahk
    Return
}   

^+c::   ; run chrome in a new maximized window
{
    Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    WinWaitActive, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,2
    WinMaximize, ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    Return
}

#t::    ; Toggles any window's always on top 
{
    Run, MyScripts\Utils\Set Any Window Always On Top.ahk
    Return
}   

#g::    ; Start's DbgView as administrator and avoids UAC prompt 
{
        ; - if MyHotkey was already started as admin
        ; (Needed to disable Window's Game Bar in Settings to use #g.)
    WinGet, i_hwnd, ID, A
    active_win := "ahk_id " . i_hwnd
    dbgview_title := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
    If !WinExist(dbgview_title)
    {
        Run, "C:\Program Files (x86)\SysInternals\Dbgview.exe"
        Sleep 500
    }
    Else
    {
        WinActivate, %dbgview_title%
        Sleep 100
    }
    ; if accept filter window prompt
    If WinExist("DebugView Filter ahk_class #32770 ahk_exe Dbgview.exe")
        WinClose
    WinWaitActive, %dbgview_title%,,1
    If WinActive(dbgview_title)
    {
        WinMenuSelectItem, A,,Computer, Connect Local
        OutputDebug, DBGVIEWCLEAR
        Run, MyScripts\Utils\DbgView Popup Menu.ahk
    }
    WinActivate, %active_win%
    Return
}

#+0::    ; activate screensaver
{
    Sleep 2000  ; time needed to stop touching keyboard or mouse
    Run, C:\Users\Mark\Documents\Launch\Utils\Other\scrnsave.scr.lnk
    Return
}

~PrintScreen::  ; Captures entire screen and opens it up in IrfanView
{
    Run, C:\Program Files (x86)\IrfanView\i_view32.exe
    WinWait IrfanView
    If WinExist(IrfanView)
    {
        WinActivate
        SendInput !ep        ;edit paste 
    }   
    Return
}

~!PrintScreen::      ; Captures active window and opens it up in IrfanView
{
    Run, C:\Program Files (x86)\IrfanView\i_view32.exe
    WinWait IrfanView
    If WinExist(IrfanView)
    {
        WinActivate
        SendInput !ep        ;edit paste 
    }   
    Return
}

; LWin & WheelUp::    ; Scroll to Window's virtual desktop to the right
; {
    ; SendInput {Control Down}{LWin Down}{Right}{Control Up}{LWin Up}
    ; Return
; }

; LWin & WheelDown::     ; Scroll to Window's virtual desktop to the left
; {  
    ; SendInput {Control Down}{LWin Down}{Left}{Control Up}{LWin Up}
    ; Return
; }

     
~#+s::      ; Captures selected portion of screen and opens it up in IrfanView
{
    ; Wait_For_Escape("Select capture with mouse then`n")
    Input, ov,,{Control}
    MsgBox % ErrorLevel
    Run, C:\Program Files (x86)\IrfanView\i_view32.exe
    WinWait, IrfanView ahk_class IrfanView
    If WinExist(IrfanView)
    {
        WinActivate
        SendInput !ep        ;edit paste 
    }  
    Return
}

; Note: window's search hotkey is Win+s.
#!s::   ; Starts Seek script alternative to windows start search
{
    Run, plugins\seek.ahk
    Return
}

#1::   ; Start xplorer2 lite
{
    Run, C:\Program Files (x86)\zabkat\xplorer2_lite\xplorer2_lite.exe /M
    Return
}

#^k::    ; Run KeyHistory
{
    Run, MyScripts\Utils\KeyHistory.ahk
    Return
}    
        
#+w::   ; Runs Window Detective
{
    Run, C:\Program Files (x86)\Window Detective\Window Detective.exe
    Return
}

#!w::  ; Runs Visual Studio's Window Spy (changes default font)
{
       ; If MyHotkeys was started with Administrator privileges Spyxx will start without UAC prompt
    Run, C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\spyxx.exe
    While !WinActive("Microsoft Spy++")
    {
        WinActivate, Microsoft Spy++
        Sleep 500
    }
    WinMenuSelectItem, A,,Spy, Windows
    Sleep 500
    Gosub ^!+f  ; Changes font within MS Spy++
    Return
}

#^w::
#w::    ; Runs AutoHotkey's Window Spy 
{
    ; Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\WindowSpyToolTip.ahk
    save_coordmode := A_CoordModeMouse
    CoordMode, Mouse, Screen
    MouseGetPos, save_x, save_y
    SetTitleMatchMode 2
    ws_wintitle := "Window Spy ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe"
    Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
    Sleep 1000
    ControlFocus, Button1, %ws_wintitle%
    Control, Check,,Button1, %ws_wintitle%   ; Follow Mouse
    ControlFocus, Button2, %ws_wintitle%
    Control, Check,,Button2, %ws_wintitle%   ; Slow TitleMatchMode
    WinGetPos, x, y, w, h, %ws_wintitle%
    If (A_ThisHotkey = "#w")
        MouseClickDrag, Right, x+180, y+15, 170,10  ; move top left
    Else If (A_ThisHotkey =  "#^w")
        MouseClickDrag, Right, x+180, y+15, A_ScreenWidth + 180 - w,10  ; move top right
    CoordMode, Mouse, %save_coordmode%
    Return
}

+MButton::    ; Taskbar toolbar "Launch folder" replacement with popup menu for that directory
{                                                              
    Run, MyScripts\Utils\Create Menu From Directory - Launch Copy.ahk "C:\Users\Mark\Documents\Launch" %True% %False% %False% %True% 
    Return
}

#^d::    ; Create popup menu for any directory structure where cursor is pointing at in explorer 
         ; like programs or select a  directory path in a text file. Anything that will place
         ; a valid directory name in the clipboard if you would hit ^c on it.
{                                                                                           
    Run, MyScripts\Utils\Create Menu From Directory.ahk 
    Return
}

#!d::   ; Create popup menu for any directory showing file icons (See #^d for no icons version)
{                                                                                           
    Run, MyScripts\Utils\Create Menu From Directory.ahk "" "" "" "" %True%
    Return
}

#n::    ; Runs Window's Notepad 
{
    Run, Notepad.exe
    Return
}

#^+n::   ; Close all untitled Notepad windows
{
    win_title := "Untitled - Notepad ahk_class Notepad"
    While WinExist(win_title)
    {
        WinClose, %win_title%
        ; click don't save
        If WinExist("Notepad ahk_class #32770 ahk_exe Notepad.exe")
            ControlClick, Button2, A
    }
    Return
}

#c::    ; Runs Window's Calc
{
    Run, Calc.exe
    Return
}
    
#!c::   ; Sorts a list of selected items (ie: filenames in explorer)
{
    Clipboard =
    SendInput ^c
    ClipWait 2
    If ErrorLevel
        Return
    Sort Clipboard
    MsgBox Ready to be pasted:`n%Clipboard%
    Return
}
    
#f::    ; Remapped to do nothing. Default is for it to run some program that gets an error all the time.
{
    Return
}
    
^!t::    ; Inserts a date and time in this kind of format: Jun-08-18 18:02
{
    SendInput % timestamp(2,2)
    Return
}

^!s::   ; Starts Search Everything 
{
    ; If MyHotkeys was started with Administrator privileges Search Everything will start without UAC prompt
    RunWait, C:\Program Files\Everything\Everything.exe  -matchpath -sort "path" -sort-ascending 
    Return
}

^!+s::   ; Starts Search Everything for AutoHotkey type files
{
    ; If MyHotkeys was started with Administrator privileges Search Everything will start without UAC prompt
    RunWait, C:\Program Files\Everything\Everything.exe  -search "file:*.ahk|*.txt <Autohotkey Scripts> <!plugins> <!tetris>" -matchpath -sort "date modified" -sort-descending 
    SendInput {Home}{Right 5}
    Return
}

^!+x::  ; Clears Dbgview window without having to go there
{
    dbgview_win := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
    If WinExist(dbgview_win)
        WinMenuSelectItem, %dbgview_win%,,Edit,Clear Display
    Return 
}

^!+t::  ; Toggle Dbgview window's AlwaysOnTop option without having to go there
{
    dbgview_win := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
    If WinExist(dbgview_win)
        WinMenuSelectItem, %dbgview_win%,,Options,Always On Top
    Return 
}
    
CapsLock & F1::    ; Opens AutoHotkey Help file searching index for currently selected word available to any program as opposed to F1 below  
{
    Run, MyScripts\Utils\AHK Context Help File.ahk
    Return
}

#F1::  ; Hotkey Help - #F1 to active it.
{
    Run, plugins\Hotkey Help (by Fanatic Guru).ahk     
    Return
}
    
#F3::   ; Start TextCrawler
{
    Run, "C:\Program Files (x86)\TextCrawler Free\TextCrawler.exe"
    Return
}
    
RAlt & '::      ; Display basic active window info  
{
    WinGetTitle, i_title, A
    WinGetClass, i_class, A
    WinGet, i_procname, ProcessName, A
    WinGet, i_hwnd, ID, A
    i_class := "ahk_class " . i_class
    i_procname := "ahk_exe " . i_procname
    i_hwnd := "ahk_id " . i_hwnd
    active_win := i_title A_Space i_class A_Space i_procname
    WinActivate, %active_win%
    ControlGetFocus, got_focus, A
    WinGet, control_list, ControlList, A
    Sort control_list

    output_debug("")    ; starts dbgview if not already started
    Sleep 10
    OutputDebug, -------------------
    OutputDebug, % "title: " i_title
    OutputDebug, % "class: " i_class
    OutputDebug, % "proc : " i_procname
    OutputDebug, % "hwnd : " i_hwnd 
    OutputDebug, % "focus: " got_focus
    OutputDebug, -------------------
    Loop, Parse, control_list, "`r`n"
    {
        ControlGet, is_visible, Visible,, %A_LoopField%, A
        If is_visible
            OutputDebug % A_LoopField
    }
    Return
}

CapsLock & F9::   ; Adds selected words to lib\AHK_word_list.ahk
{
    Run, MyScripts\Utils\Add Selection To AHK Word List.ahk
    Return
}   

;************************************************************************
;
; Hotkeys available for MPV (NHLGames.exe default media player)
; 
;************************************************************************
#If WinActive("ahk_class mpv ahk_exe mpv.exe")
LButton:: Click, Left
Rbutton:: Click, Right
WheelUp:: SendInput {Right 3}           ; seek forward  15 seconds
WheelDown:: SendInput {Left 3}          ; seek backward 15 seconds
LButton & WheelUp:: SendInput {Right}   ; seek forward  5 seconds
LButton & WheelDown:: SendInput {Left}  ; seek backward 5 seconds
RButton & WheelUp:: SendInput 0         ; volume up
RButton & WheelDown:: SendInput 9       ; volume down
MButton:: SendInput O                   ; toggle show progress 
;************************************************************************
;
; Make these hotkeys available ONLY when dealing with Youtube
; type video players  in Chrome
; 
;************************************************************************
#IfWinActive

^!+RButton::
^!+y::
{
    win_title1 = ".*YouTube - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    win_title2 = ".*Watchseries - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
    win_title3 = ".*dailymotion - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe"
 
    Run, "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Web\Youtube - hotkeys.ahk" %win_title1% %win_title2% %win_title3%
    Return
}
;************************************************************************
;
; Make these hotkeys available ONLY when dealing with Windows 10 Settings Pages
; 
;************************************************************************
#If WinActive("Settings ahk_class ApplicationFrameWindow ahk_exe ApplicationFrameHost.exe")
WheelUp::SendInput {PgUp}
WheelDown::SendInput {PgDn}
;************************************************************************
;
; Make these hotkeys available ONLY when dealing with Kodi
; 
; See C:\Users\Mark\AppData\Roaming\Kodi\userdata\keymaps\MyKeymap.xml
; for more shortcuts set internally in kodi.
;************************************************************************
#If WinActive("ahk_class Kodi ahk_exe kodi.exe")
RAlt::  ; Chappa'ai context player menu
{
    SendInput {AppsKey}{Up 2}{Enter}
    Sleep 100
    SendInput {Enter}
    Return
}

+RAlt::  ; Select Death Streams Autoplay from Chappa'ai context player menu
{
    SendInput {AppsKey}{Up 2}{Enter}
    Sleep 100
    SendInput {Enter}
    Sleep 3000
    SendInput {Down}{Enter}
    Return
}

LButton:: SendInput {Click,Left}
LButton & WheelUp::   SendInput f     ; fast forward
LButton & WheelDown:: SendInput r     ; fast reverse
LButton & MButton::   SendInput p     ; play normal speed 

;************************************************************************
;
; Make these hotkeys available ONLY when dealing with Windows Magnifier (#=)
; 
;************************************************************************
#If WinExist("ahk_exe Magnify.exe")
#+=::Send #{Escape}   ; exit magnifier

;************************************************************************
;
; Make these hotkeys available ONLY when dealing with PythonScript
; 
;************************************************************************
#If WinExist("Python ahk_class #32770 ahk_exe notepad++.exe")


;************************************************************************
;
; Make these hotkeys available Globally except in Chrome browser
; 
;************************************************************************
#If Not WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")
^h::    ; Searches MyHotkeys.ahk for desired hotkey
{
    output_debug("")
    Run, MyScripts\Utils\Find Hotkey.ahk
    Return
}
;************************************************************************
;
; Make these hotkeys available ONLY when dealing with WinMerge
; 
;************************************************************************
#If WinActive("ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe")
Shift & Tab::   ; WinMerge Change Pane
Tab::           ; WinMerge Change Pane
{
    SendInput {F6}
    Return
}

^Delete::   ; WinMerge Delete Line
{
    SendInput {Home}+{Down}{Delete}
    Return
}
;************************************************************************
;
; Make these hotkeys available ONLY when dealing with AutoHotkey Window Spy
; 
;************************************************************************
#If WinExist("Window Spy ahk_exe AutoHotkey.exe")
^!c::   ; Copies WinTitle info from AutoHotkey Window Spy to the clipboard
{
    ControlGetText, the_text,Edit1, Window Spy ahk_exe AutoHotkey.exe   
    Clipboard := StrReplace(the_text, "`r`n", " ")
    MsgBox, 64,,Window Spy info saved on clipboard.`n`n%clipboard%, 5
    Return
}

^+c::   ; Copies classNN info from AutoHotkey Window Spy to the clipboard
{
    ControlGetText, the_text, Edit3, Window Spy    
    Clipboard := the_text
    MsgBox, 64,,Window Spy info saved on clipboard.`n`n%clipboard%, 5
    Return
}
;************************************************************************
;
; Make these hotkeys available ONLY within ConsoleWindowClass type windows
; ie cmd.exe. (powershell doesn't need this for scrolling)
; 
;************************************************************************
#If WinActive("ahk_class ConsoleWindowClass")   ; ahk_exe cmd.exe")
WheelUp::
PgUp::SendInput {Control Down}{Up 10}{Control Up}
WheelDown::
PgDn::SendInput {Control Down}{Down 10}{Control Up}
;************************************************************************
;
; Make these hotkeys available ONLY if WinDowse is running
;
;************************************************************************
#If WinExist("WinDowse ahk_class TfrmWinDowse ahk_exe WinDowse.exe")
!z::    ; Toggles WinDowse "Dowse/Stop" button from any application that has focus 
{
    windowse_win_title := "WinDowse ahk_class TfrmWinDowse ahk_exe WinDowse.exe"
    ControlFocus, TButton6, %windowse_win_title%
    ControlClick, TButton6, %windowse_win_title%
    Return
}

!r::    ; Click WinDowse Refresh button info from any application that has focus 
{
    windowse_win_title := "WinDowse ahk_class TfrmWinDowse ahk_exe WinDowse.exe"
    ControlFocus, TButton2, %windowse_win_title%
    ControlClick, TButton2, %windowse_win_title%
    Return
}
;************************************************************************
;
; Make these hotkeys available ONLY within Expresso
; 
;************************************************************************
#If WinActive("ahk_class WindowsForms10.Window.8.app.0.141b42a_r6_ad1 ahk_exe Expresso.exe")
^!x::    ; Exports current RegEx results to the desktop
{
    ; WinMenuSelectItem, A,,Tools,Export Results,Matched Text Only ...
    SendInput {LAlt Down}txm{LAlt Up}
    Sleep 1000
    SendInput C:\Users\Mark\Desktop\Expresso Results.txt
    Return
}
;************************************************************************
;
; Make these hotkeys available ONLY within Window Detective
; 
;************************************************************************
#If WinActive("Window Detective ahk_class Qt5QWindowIcon")
~f::    ; flash selected window
{
    SendInput {AppsKey}f{Enter}
    Return
}

~p::    ; show properties for selected window
{
    SendInput {AppsKey}p{Enter}
    Return
}
;************************************************************************
;
; Make these hotkeys available ONLY within VLC (video/playlist)
; 
;************************************************************************
#If WinActive("VLC media player ahk_class Qt5QWindowIcon") or WinActive("Playlist ahk_class Qt5QWindowIcon")
f::
^f::    ; VLC fullscreen
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput f
    WinActivate, ahk_class Qt5QWindowIcon ahk_exe vlc.exe
    Return
}

^s::    ; VLC stop 
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput s
    Return
}

; l::     ; Toggle playist & overwrites loop video
^+a::    ; Toggle playist
{
    If WinExist("Playlist ahk_class Qt5QWindowIcon")
    {
        WinActivate, Playlist ahk_class Qt5QWindowIcon
        If WinActive("Playlist ahk_class Qt5QWindowIcon")
            SendInput !{F4}

    }
    If Not WinExist("Playlist ahk_class Qt5QWindowIcon")
    {
        WinActivate, VLC media player ahk_class Qt5QWindowIcon
        SendInput {Alt Down}il{Enter}
        Return
    }
    Return
}

^!a::   ; Sets VLC default audio device to speakers
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    ; WinMenuSelectItem, VLC media player ahk_class Qt5QWindowIcon,, Audio, Audio Device, Speakers (Realtek High Definition Audio) 
    SendInput {Alt Down}ad
    Sleep 1000
    SendInput {Up}{Alt Up}{Enter}
    Return
}

~Delete::    ; no return statement so it executes the save (^!y) routine as well.
^!y::   ; Saves VLC unwatched.xspf playlist
{
    Sleep 200   ; allows delete to occur
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput ^y
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched.xspf!s{Left}{Enter}
    Sleep 500
    WinActivate, Playlist ahk_class Qt5QWindowIcon
    Return
}

^!+y::   ; Saves VLC unwatched backup.xspf playlist
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput ^y
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched backup.xspf!s{Left}{Enter}
    Sleep 1500
    WinMinimize, VLC media player ahk_class Qt5QWindowIcon
    If WinExist("Playlist ahk_class Qt5QWindowIcon")
    {
        WinActivate, Playlist ahk_class Qt5QWindowIcon
        WinWaitActive
        If WinActive("Playlist ahk_class Qt5QWindowIcon")
            SendInput !{F4}
    }
    Return
}

^!o::   ; Opens VLC unwatched.xspf playlist
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput ^o
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched.xspf
    WinActivate, Playlist ahk_class Qt5QWindowIcon
    If WinActive("Playlist ahk_class Qt5QWindowIcon")
        SendInput !{F4}
    Return
}

^+o::   ; Show VLC containing folder...
{
    If !WinExist("Playlist ahk_class Qt5QWindowIcon")
    {    
        SendInput ^l    ; open playlist
        Sleep 10
    }
    WinActivate, Playlist ahk_class Qt5QWindowIcon
    SendInput {AppsKey}{Down 5}
    Sleep 10
    SendInput {Enter}
    Return
}

#If WinActive("Playlist ahk_class Qt5QWindowIcon")
~Enter::   ; Show VLC containing folder...
{
    WinActivate, Playlist ahk_class Qt5QWindowIcon
    If WinActive("Playlist ahk_class Qt5QWindowIcon")
        SendInput !{F4}
    Return
}

;************************************************************************
;
; Make these hotkeys available ONLY within Microsoft Spy++
; 
;************************************************************************
#If WinActive("Microsoft Spy++")
~f::    ; Flashes selected window or control (highlight)
{
    SendInput {AppsKey}h
    Return
}
    
^f::    ; Opens "find window" within list of windows in Spy++ (instead of find window locate a window dialog) 
{
    SendInput {LControl}{Home}    
    SendInput !{F3}
    Sleep 200
    SendInput {Delete}{Tab}{Delete}{Tab}{Delete}{LAlt Down}w{LAlt Up}{Shift Down}{Tab 2}{Shift Up}
    Return
}

^g::    ; Find Next
{
    SendInput {F3}
    Return
}

^!+f::  ; Change font
{
    WinMenuSelectItem,A,,View,Font
    WinWaitActive,Font ahk_class #32770, 
    If ErrorLevel = 0 
        SendEvent Consolas{Tab 2}16{Shift Down}{Tab 2}{Shift Up}{Enter}
    Return
}
    
^!+x::  ; Clear messages screen
{
    WinMenuSelectItem,A,,Messages,Clear Log
    Return
}
  
^m::
{
    WinMenuSelectItem, A,, &Messages, Logging &Options
    SendInput +{Tab}{Right}!c{Tab}w{down 19}    ; scroll down to wm_command
    Return
}  
#If WinActive("Find Window ahk_class #32770")
^+f::    ; This will synchronize when "Find Window" (Alt-f3) with the Spy++ listing
{
    SendInput {Enter}
    SendInput {Shift Down}{Tab 3}{Shift Up}{Enter}{Shift Down}{Tab 2}{Shift Up} 
    Return
}

;************************************************************************
;
; Make these hotkeys available ONLY within TextCrawler 3
; 
;************************************************************************
#If WinActive("TextCrawler 3 ahk_class WindowsForms10.Window.8.app.0.378734a")
^f::    ; Set focus on the "find" textbox
{
    ControlClick, Edit4, ahk_class WindowsForms10.Window.8.app.0.378734a
    Return
}

;************************************************************************
;
; Make these hotkeys available to Notepad++ only
; 
;************************************************************************
#If WinActive("ahk_class Notepad++") or WinActive("Find ahk_class #32770")
Alt & WheelUp::         ; chooses the next opened file in tab bar to the right
{
    WinMenuSelectItem,A,, View, Tab, Next Tab
    Return
}

Alt & WheelDown::       ; chooses the next opened file in tab bar the left
{
    WinMenuSelectItem,A,, View, Tab, Previous Tab
    Return
}

Control & WheelUp::     ; Move file tab forward in tab bar
{
    WinMenuSelectItem,A,, View, Tab, Move Tab Forward
    Return
}

Control & WheelDown::   ; Move file tab backward in tab bar
{
    WinMenuSelectItem,A,, View, Tab, Move Tab Backward 
    Return
}

F3::    ; Accelerator Key for TextFX menu
{
    ; WinMenuSelectItem, A,, TextFX, TextFX Characters
    WinMenuSelectItem, A,,Edit,Indent
    Return
}

F7::    ; Toggle Search Results Window
{
    Run, MyScripts\NPP\Misc\Toggle Search Results Window.ahk
    Return
}

^!F7::  ; Creates Shortcut Mapper List from scratch (ie the most updated status of shortcuts) and proceeds to Finder program
{
    Run, MyScripts\NPP\Shortcut Mapper\Get List.ahk
    Return
}

^F7::   ; Opens the last Shortcut Mapper List created and proceeds to Find routine. This is faster than creating from scratch but list is outdated.
{
    Run, MyScripts\NPP\Shortcut Mapper\Finder.ahk
    Return
}

^w::    ; Close window. Overrides extend selection right in NPP.
{
    SendInput ^{F4}
    Return
}

^f::   ; Creates an Access Key in the Edit dialog to "Find All In Current Document"
{
    Run, MyScripts\NPP\Misc\Find All In Current Document.ahk
    Return
}

^+f::   ; Same as ^f but executes "Find All in Document" on selected text 
{
    Run, MyScripts\NPP\Misc\Find All In Current Document.ahk "DoIt"
    Return
}
   
;************************************************************************
;
; Make these hotkeys available to Notepad++ or SciTE4AutoHotKey
;
; Note: these probably work in most text controls, editors with standard keyboard shortcuts
; 
;************************************************************************
#If WinActive("ahk_class Notepad++") or WinActive("ahk_class SciTEWindow") or WinActive("ahk_class Notepad")

^+a::   ; Selects word under cursor (like mouse doubleclick on word)
{
    WinMenuSelectItem, A,,Plugins,Python Script,Scripts,select_word_under_cursor
    Return   
}

^q::    ; Toggles auto-completion
{
    Run,  MyScripts\NPP\Misc\Toggle Preferences Setting.ahk "Toggle" "Button141" "Autocomplete"
    Return
}

^!q::    ; Toggles Doc Switcher
{
    Run,  MyScripts\NPP\Misc\Toggle Preferences Setting.ahk "Toggle" "Button9" "Doc Switcher"
    Return
}

^m::    ; Copies the current word and pastes it to MsgBox % statement on a new line.
{
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendMode Input
    SendInput % SEND_COPYWORD
    ClipWait, 5
    SendInput {End}{Enter}MsgBox{Space}`%{Space}
    SendInput % SEND_WORD_NAME_VALUE
    SendInput {Home}
    Sleep 200
    Clipboard := saved_clipboard
    Return
}

!+o::   ; output_debug("*** time ***" ) debugging statement on a new line.
{
    SendInput {End}{Enter}output_debug(`"*** `" . get_time() . ":" . A_MSec . `" ***`"){Home}
    Return
}

^!o::   ; Copies the current word and pastes it to OutputDebug statement on a new line.
{
    the_word := select_and_copy_word()
    SendInput {End}{Enter}OutputDebug, `% %the_word%{Home}
    Return
}
    
^!+o::  ; Copies the current word and pastes it to OutputDebug, % "copyword: " . copyword statement on a new line.
{
    the_word := select_and_copy_word()
    ; send_cmd := "% " . Chr(34) . the_word . ": |"  . Chr(34) . A_Space . the_word . A_Space . Chr(34) . "|" . Chr(34)
    send_cmd := "% " . Chr(34) . the_word . ": "  . Chr(34) . A_Space . the_word
    SendInput {End}{Enter}OutputDebug, %send_cmd%{Home}   
    Return
}

^!+p::   ; Copies the current word and pastes it to console.write() statement on a new line (Python Script).
{
    the_word := select_and_copy_word()
    send_cmd := "console.write('" the_word ": ' + str(" the_word ") + '\n')"
    Clipboard := send_cmd
    ClipWait,1
    SendInput {End}{Enter}^v{Home}
    Return
}

^!+n::  ; Save Session using current script as the session name.
{
    WinGetTitle, current_script, A
    SplitPath, current_script, of, od, oe, session_name, od
    WinMenuSelectItem, A,, File, Save Session
    Sleep 1000
    SendInput %session_name%{Tab}
    SendInput C:\Users\Mark\Google Drive\Misc Backups\Notepad
    ; for some reason SendInput translates ++ to a pipe | symbol.
    SendRaw   ++
    SendInput \backup\%session_name%.npp_savedsession
    Return
}
    
+BackSpace::    ; Remaps to do a regular backspace instead of inserting an ascii code BS.
{
    SendInput {BackSpace}
    Return
}

F1::    ; Opens AutoHotkey Help file searching index for currently selected word   
{
    Run, MyScripts\Utils\AHK Context Help File.ahk
    Return
}

F2::    ; Remaps keyboard so that typing in SEND commands is easier
{
    Run, MyScripts\Utils\Remap Keyboard for SEND.ahk
    Return
}

!F2::   ; Creates a file with only alt+0 folded lines for the current file
{
    Run, MyScripts\NPP\Misc\Copy Folded Visible Lines Only.ahk
    Return
}
    
; F5::
; {
    ; WinMenuSelectItem, A,, Plugins, DBGp, Stop
    ; WinMenuSelectItem, A,,File,Save
    ; Sleep 10
    ; fname := get_current_npp_filename_ahk_version()
    ; OutputDebug, %A_AhkPath% "%fname%"
    ; Run, %A_AhkPath% "%fname%"
    ; Return
    ; ; outputdebug "here"
    ; ; Run, MyScripts\Utils\F5 - Run Current AHK Script(does not work from myhotkeys anymore).ahk
    ; ; Return
; }

F12::   ; Toggle edit/find all in documents results window
{
    Run, MyScripts\NPP\Misc\Close All Windows.ahk
    Return
}
 
^!+i::  ; Debugging tool useful for blocking keyboard input and stopping console from closing
{
    SendInput {End}{Enter}Wait_For_Escape() `; debugging tool - defined in utils.ahk
    Return
}

^!+5::  ; Wrap percent signs %% around current word
{
    SendInput ^{Left}`%^!+{Right}`%
    Return
}

^[::    ; Wrap Braces {} around current line
{
    SendInput {Home}+{Tab}
    SendRaw {
    SendInput {Enter}{Tab}{End}{Enter}+{Tab}
    SendRaw }
    SendInput {Up}^{Right}
    Return
}    

^!+[::  ; Wrap braces {} around current word
{
    SendInput ^{Left}
    SendRaw {
    SendInput ^!+{Right}
    SendRaw }
    Return
}

^!+'::  ; Wrap double quotes "" around current word
{
    SendInput ^{Left}`"^!+{Right}`"
    Return
}
    
Control & Insert::    ; Select entire line including any leading whitespace  
{
    SendInput {LAlt Down}{Home}{Shift Down}{End}{LAlt Up}{Shift Up}
    Return
}

^!d::   ; Add Watch to DBGp watches.
{
    Run, MyScripts\NPP\Misc\DBGp Add Watch.ahk
    Return
}
    
^+r::   ; Recent files menu
{
    SendInput !fr{Down 3}
    Return
}

CapsLock & a::    ; Replaces the the selected character with corresponding chr(<x>) phrase. 
                  ; ie: select a semicolon and hit Ctrl+` and it will be replaced with chr(59)
{
    char := check_selection_copy(1,0,0)
    If (char == "")
    {
        MsgBox, 48,, % "Selection didn't meet parameter requirements.", 10
        Return
    }
    OutputDebug, % "char: |" char "|"
    If char
    {
        saved_clipboard := ClipboardAll
        Clipboard := char
        ClipWait, 1
        SendInput % "chr(" Asc(char) ")"
        SendInput {Tab} 
        SendInput % Chr(59)
        SendInput {Space} is ASCII: ^v
        Sleep 500
        Clipboard := saved_clipboard
    }
    Return
}

^Numpad9::    ; Runs active script as administrator
{ 
    SendInput ^s  
    script_fullpath := npp_get_current_filename()
    Run *RunAs "%A_AHKPath%" /restart "%script_fullpath%"
    Return
}

;--------------------------------------------------------------
; DBGp hotkeys.
; allows these keys to work when focus is not on DBGp panel
;---------------------------------------------------------------
F10::   ; DBGp plugin Step Into
{
    WinMenuSelectItem, A,, Plugins, DBGp, Step Into
    Return
}

F11::   ; DBGp plugin Step Over
{
    WinMenuSelectItem, A,, Plugins, DBGp, Step Over
    Return
}

+F10::   ; DBGp plugin Step Out
{
    WinMenuSelectItem, A,, Plugins, DBGp, Step Out
    Return
}

+F11::   ; DBGp plugin Run to
{
    WinMenuSelectItem, A,, Plugins, DBGp, Run to
    Return
}


^F10::   ; DBGp plugin Run
{
    WinMenuSelectItem, A,, Plugins, DBGp, Run
    Return
}


^!+d::   ; DBGp plugin Stop
{
    start_dbgp()
    WinMenuSelectItem, A,, Plugins, DBGp, Stop
    Return
}


^F9::   ; DBGp plugin Toggle Breakpoint
{
    start_dbgp()
    WinMenuSelectItem, A,, Plugins, DBGp, Toggle Breakpoint
    Return
}

^!+F5::   ; Debug current script being edited with DBGp debugger
{
    Run, MyScripts\NPP\Misc\Debug Current Script.ahk
    Return
}

^F5::   ; DBGp Clear All Watches
{
    Run, MyScripts\NPP\Misc\DBGp Clear All Watches.ahk
    Return
}

^+F5::   ; DBGp Clear All Breakpoints
{
    Run, MyScripts\NPP\Misc\DBGp Clear All Breakpoints.ahk
    Return
}
; End of DBGp hotkeys.
;---------------------------------------------------------------
^l::    ; Documents all procedure calls in lib directory
{
    RunWait, MyScripts\Utils\Lib Procedures Documenter.ahk
    Sleep 500
    Run, MyScripts\NPP\Misc\Find All In Current Document.ahk    
    Return
}

CapsLock & F2::     ; Beautify current AHK Script
{
    WinMenuSelectItem, A,,File,Save
    Run, MyScripts\Utils\Beautify AHK.ahk
    Return
}

^!+F1::     ; AutoHotkey RegEx Quick Reference
{
    Run, https://www.autohotkey.com/docs/misc/RegEx-QuickRef.htm
    Return
}

^F6::   ; PythonScript - Toggle Console
{
    WinMenuSelectItem,A,,Plugins,Python Script,Show Console
    Return
}
!F6::   ; PythonScript - Create New Script
{
    WinMenuSelectItem,A,,Plugins,Python Script,New Script
    Return
}

F6::    ; Execute current PythonScript in console
{
    file_full_path := npp_get_current_filename()
    python_ext := (SubStr(file_full_path, -2) = ".py")
    If Not FileExist(file_full_path)  
    {
        MsgBox, 48,, % file_full_path "`n`nDoes not exist"
        Return
    }
    If Not python_ext
    {
        MsgBox, 48,, % file_full_path "`n`nNot a python file (.py)"
        Return
    }
    WinMenuSelectItem, A,, File, Save
    ControlGetFocus, save_focus, A
    npp_pythonscript_console_show()
    ; SetTitleMatchMode 2
    ControlFocus, Edit1, A
    ControlGetFocus, got_focus, A
    if not instr(got_focus, "Edit")
    {
        MsgBox, 48,, % "Can not find python console.`n`nControl with focus: " got_focus
        Return
    }
    SplitPath, file_full_path, fname, fdir 
    SendInput ^a{Delete}
    Send {Text}import os; os.chdir('%fdir%')
    Sleep 10
    SendInput {Enter}
    Send {Text}execfile('%fname%')
    Sleep 10
    SendInput {Enter}
    Sleep 1000  ; needs to let fname finish before it change focus
    ControlFocus, %save_focus%, A
    Click
    Return
}

^!F6::    ; PythonScript - Run Previous Script
{
    WinMenuSelectItem,A,,File,Save
    WinMenuSelectItem,A,,Plugins,Python Script,Run Previous Script
    Return
}

^!+F6::     ; PythonScript - Execute commands in console or launch Scintilla web help 
{
    Run, MyScripts\Utils\PythonScript Commands from Scintilla Methods.ahk
    Return
}