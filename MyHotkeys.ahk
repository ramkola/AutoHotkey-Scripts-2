;---------------------------------------------------------------------------------------------
; Braces are used to be able to fold (!0) the document the way I want in Notepad++ 
;---------------------------------------------------------------------------------------------
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk       
#Include lib\utils.ahk
#Include lib\scite.ahk
#NoEnv
#SingleInstance Force
; #MenuMaskKey vk07   ; suppress unwanted win key default activation.
SendMode Input
SetTitleMatchMode RegEx
SetWorkingDir %AHK_ROOT_DIR%
SetCapsLockState, AlwaysOff
SetNumLockState, AlwaysOn     
SetScrollLockState, AlwaysOff     
Menu, Tray, Icon, ..\resources\32x32\Old Key.png, 1
g_TRAY_MENU_ON_LEFTCLICK := True    ; see lib\utils.ahk

system_startup := (A_Args[1] = "system")		; configured in Window's Task Scheduler/Properties/Action parameter
SetTimer, PROCESSMONITOR, 1800000 ; check every 30 minutes 1 minute = 60,000 millisecs
SetTimer, TEXTNOW, 300000         ; check every 5 minutes if Textnow is running

Run, MyScripts\MyHotStrings.ahk
Run, MyScripts\Utils\Tab key For Open or Save Dialogs.ahk
Run, MyScripts\Utils\Web\Load Web Games Keyboard Shortcuts.ahk
Run, MyScripts\Utils\Create Menu From Directory - Launch Copy.ahk "C:\Users\Mark\Documents\Launch" %True% %False% %False% %True% %False%
Run, MyScripts\Utils\Pango Hotkeys.ahk
; Wait for MediaMonkey to fully load before continuing.
Run, MyScripts\Utils\Programs\MediaMonkey.ahk
While (h == "")
{
    ControlGetPos,,,, h, TMMPlayerSkinEngine1, ahk_class Shell_TrayWnd ahk_exe Explorer.EXE
    Sleep 100
}

If !system_startup
	Run, MyScripts\Utils\Web\TextNow.ahk "Minimize"
Else
{
	; run this on system startup not when invoked manually (^. hotkey)
	Run, MyScripts\Utils\Web\TextNow.ahk 
	WinWaitActive, TextNow.*Google Chrome,,5
    If (ErrorLevel = 0)
    {
        Sleep 10000 ; Need to allow TextNow pages to completely load for Move Active... to work consistently
        Run, MyScripts\Utils\Move Active Window To Other Virtual Desktop.ahk
    }
}
; Run, MyScripts\Utils\Keep KDrive Active.ahk
; Run, plugins\Convert Numpad to Mouse.ahk
; Run, plugins\Hotkey Help (by Fanatic Guru).ahk
Return

;===========================================================================================

PROCESSMONITOR:
{
    return_array := {}
    found := find_process(return_array, "autohotkey", "monitor keyboard hotkeys")
    If Not found
        Run, MyScripts\Utils\Monitor Keyboard Hotkeys.ahk
    Return
}

TEXTNOW:
{
    Run, MyScripts\Utils\Web\TextNow.ahk "Minimize"
    Return
}
;************************************************************************
;
; The following hotkeys are globally available in any window 
; 
;************************************************************************
#IfWinActive
#If
; these are here for documentation only they don't do anything. they "reserve" usage for windows
; #a::Return                   ; Window's view notifications history 
; #d::Return                   ; Window's show desktop toggle (minimize/restore all windows)
; #e::Return                   ; Window's File Explorer
; #h::Return                   ; Windows's Dictation
; #i::Return                   ; Window's Settings
; #l::Return                   ; Window's Lock Screen
; #m::Return                   ; Window's Minimize All Windows
; #v::Return                   ; Window's Clipboard with history
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
	If WinActive("ahk_class Notepad\+\+")
		SendInput ^s    ; save current file 
    Run *RunAs "%A_AHKPath%" /restart "%AHK_ROOT_DIR%\MyScripts\MyHotkeys.ahk" "not a system startup"
    Return
}

LWin & WheelDown::  ; Scroll to Window's virtual desktop to the left
LWin & WheelUp::    ; Scroll to Window's virtual desktop to the right
^!+ScrollLock::     ; Toggles ScrollLock AlwaysOff / On
^!+NumLock::        ; Toggles CapsLock AlwaysOn / Off   (sometimes need to be able to toggle NumLock ie: for Mouse Keys)
^!+CapsLock::       ; Toggles CapsLock AlwaysOff / On
#m::                ; Run MouseMove To Specified Pos.ahk
#c::                ; Runs Window's Calc
#n::                ; Runs Window's Notepad 
#^w::               ; Run WindowSpyToolTip.ahk
^!s::               ; Starts Search Everything
#!t::               ; Inserts a date and time in this kind of format: Jun-08-18 18:02
#!s::               ; Starts Seek script alternative to windows start search
#t::                ; Toggles any window's always on top 
^!t::               ; run textnow with google contacts in a new maximized window
#^2::               ; Move Active Window To Other Virtual Desktop
#o::                ; open openload pairing page in browser and clicks the buttons
#h::                ; Search Chrome History
^PgDn::             ; Run Browser - Next Numbered Page.ahk
#PgUp::             ; Toggle Maximize / Restore active window
#+PgUp::            ; Maximize all visible windows 
^+h::               ; Searches MyHotkeys.ahk for desired hotkey
#NumPad0::          ; Macro Recorder
F10::               ; Show KeyState for Special Keys
{
    If (A_ThisHotkey = "#Numpad0")
        Run, "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Macro Recorder.ahk"
    Else If (A_ThisHotkey = "^+h")
        Run, MyScripts\Utils\Find Hotkey.ahk
    Else If (A_ThisHotkey = "#+PgUp") or (A_ThisHotkey = "#PgUp")
       Run, MyScripts\Utils\Maximize All Windows.ahk %A_ThisHotkey%
    Else If (A_ThisHotkey = "^PgDn")
        Run, MyScripts\Utils\Web\Browser - Next Numbered Page.ahk
    Else If (A_ThisHotkey = "#^w")
        Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\WindowSpyToolTip.ahk
    Else If (A_ThisHotkey = "#n")
        Run, Notepad.exe
    Else If (A_ThisHotkey = "#m")
        Run, MyScripts\Utils\MouseMove To Specified Pos.ahk
    Else If (A_ThisHotkey = "#c")
        Run, Calc.exe
    Else If (A_ThisHotkey = "#^2")
        Run, MyScripts\Utils\Move Active Window To Other Virtual Desktop.ahk
    Else If (A_ThisHotkey = "#o")
        Run, MyScripts\Utils\Web\Openload Pair.ahk
    Else If (A_ThisHotkey = "#h")
        Run, MyScripts\Utils\Web\Search Chrome History.ahk
    Else If (A_ThisHotkey = "#!s")
        Run, plugins\seek.ahk
    Else If (A_ThisHotkey = "^!t")
        Run, MyScripts\Utils\Web\TextNow.ahk
    Else If (A_ThisHotkey = "#!t")
        SendInput % timestamp(2,2)
    Else If (A_ThisHotkey = "^!s")
        Run, C:\Program Files\Everything\Everything.exe -matchpath -sort "path" -sort-ascending 
    Else If (A_ThisHotkey = "#t")
        Run, MyScripts\Utils\Set Any Window Always On Top.ahk
    Else If (A_ThisHotkey = "LWin & WheelUp")
        SendInput {Control Down}{LWin Down}{Right}{Control Up}{LWin Up}
    Else If (A_ThisHotkey = "LWin & WheelDown")
        SendInput {Control Down}{LWin Down}{Left}{Control Up}{LWin Up}
    Else If (A_ThisHotkey = "^!+CapsLock")
        SetCapsLockState, % GetKeyState("CapsLock", "T") ? "AlwaysOff" : "On"
    Else If (A_ThisHotkey = "^!+NumLock")
        SetNumLockState, % GetKeyState("NumLock", "T") ? "Off" : "AlwaysOn"
    Else If (A_ThisHotkey = "^!+ScrollLock")
        SetScrollLockState, % GetKeyState("ScrollLock", "T") ? "AlwaysOff" : "On"
    Else If (A_ThisHotkey = "F10")
        Run, MyScripts\Utils\Show KeyState for Special Keys.ahk
    Return
}

#+=::   ; Activate / Run Notepad++
{
    If WinExist("ahk_class Notepad\+\+ ahk_exe notepad\+\+\.exe")
        WinActivate
    Else
        Run, C:\Program Files (x86)\Notepad++\notepad++.exe
    Return
}

#+-::   ; Activate / Run SciTE4AutoHotkey
{
    If WinExist(".*SciTE4AutoHotkey.* ahk_class SciTEWindow ahk_exe SciTE\.exe")
        WinActivate
    Else
        Run, C:\Program Files\AutoHotkey\SciTE\SciTE.exe
    Return
}

MButton & WheelDown::   ; Controls sndvol.exe with WheelUp/Down  
{
    KeyWait, LWin
    Run, MyScripts\Utils\Control Speakers Volume.ahk
    Return
}

^+Delete::
{
    KeyWait, Control
    KeyWait, Shift
    Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Kill Processes by Exe Name.ahk "AutoHotkey"
    Return
}

^!+c::  ; always starts a new browser window
^+c::   ; either activates an existing browser window (excluding TextNow) or runs a new browser window
{
    new_window := (A_ThisHotkey = "^!+c")
    Run, MyScripts\Utils\Web\activate Browser.ahk %new_window%
    Return
}

#!g::   ; Force Restart of DbgView 
#g::    ; Start's DbgView as administrator and avoids UAC prompt 
        ; If MyHotkey was already started as admin which it usually is.
{
    WinGet, active_hwnd, ID, A
    dbgview_wintitle := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
    If (A_ThisHotkey = "#!g")
        WinClose, %dbgview_wintitle%    ; graceful close so that options can be saved

    If WinExist(dbgview_wintitle)
    {
        show_dbgview := (show_dbgview == "") ? False : show_dbgview
        show_dbgview := !show_dbgview
        If show_dbgview
            WinRestore, %dbgview_wintitle%
        Else
            WinMinimize, %dbgview_wintitle%
    }
    Else
    {
        show_dbgview := True
        start_dbgview()
    }   
    Return
    ;================================================
    start_dbgview()
    {
        Run, "C:\Program Files (x86)\SysInternals\Dbgview.exe"
        WinWaitActive, %dbgview_wintitle%,,1
        ; accept filter window prompt
        If WinExist("DebugView Filter ahk_class #32770 ahk_exe Dbgview.exe")
            SendInput {Enter}  
        ; connect local - won't do anything if already connected local (option is greyed out)
        If WinActive(dbgview_wintitle)
        {
            WinMenuSelectItem, A,,Computer, Connect Local
            OutputDebug, DBGVIEWCLEAR
        }
        Run, MyScripts\Utils\DbgView Popup Menu.ahk     ; run this to reload new code if any
        Return
    }
}

^!+1::  ; Toggle Dbgview window's AlwaysOnTop option without having to go there
^!+2::  ; Toggle Dbgview window's Auto Scroll option without having to go there
^!+k::  ; Toggle Dbgview window's Check Options option without having to go there
^!+x::  ; Clears Dbgview window without having to go there
{
    If (A_ThisHotkey = "^!+1")
        Run, MyScripts\Utils\DbgView Popup Menu.ahk "Always On Top" 
    Else If (A_ThisHotkey = "^!+2")
        Run, MyScripts\Utils\DbgView Popup Menu.ahk "Auto Scroll"
    Else If (A_ThisHotkey = "^!+x")
        Run, MyScripts\Utils\DbgView Popup Menu.ahk "Clear Display"
    Else If (A_ThisHotkey = "^!+k")
    {
        WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
        Sleep 10
        Run, MyScripts\Utils\DbgView Popup Menu.ahk "Check Options"
    }
    Return 
}

#+0::    ; activate screensaver
{
    KeyWait LWin
    KeyWait Shift
    Sleep 2000  ; time needed to stop touching keyboard or mouse
    Run, C:\Users\Mark\Documents\Launch\Utils\Other\scrnsave.scr.lnk
    Return
}

~PrintScreen::  ; Captures entire screen and opens it up in IrfanView
{
    Run, C:\Program Files\IrfanView\i_view64.exe
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
    Run, C:\Program Files\IrfanView\i_view64.exe
    WinWait IrfanView
    If WinExist(IrfanView)
    {
        WinActivate
        SendInput !ep        ;edit paste 
    }   
    Return
}

~#+s::      ; Captures selected portion of screen and opens it up in IrfanView
{
    ; Wait_For_Escape("Select capture with mouse then`n")
    Input, ov,,{Control}
    MsgBox % ErrorLevel
    Run, C:\Program Files\IrfanView\i_view64.exe
    WinWait, IrfanView ahk_class IrfanView
    If WinExist(IrfanView)
    {
        WinActivate
        SendInput !ep        ;edit paste 
    }  
    Return
}

#+w::    ; Runs Visual Studio's Window Spy 64bit and changes default font
#!w::    ; Runs Visual Studio's Window Spy 32bit and changes default font
{
    ; If MyHotkeys was started with Administrator privileges Spyxx will start without UAC prompt
    If (A_ThisHotkey = "#+w")
    {
        Run, C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\spyxx_amd64.exe
        ttip("spyxx_amd64.exe")
    }
    Else If (A_ThisHotkey = "#!w")
    {
        Run, C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\spyxx.exe
        ttip("spyxx.exe")
    }
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

#w::    ; Runs AutoHotkey's Window Spy 
{
    KeyWait LWin
    KeyWait Shift
    BlockInput, On
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
    Else If (A_ThisHotkey =  "#+w")
        MouseClickDrag, Right, x+180, y+15, A_ScreenWidth + 180 - w,10  ; move top right
    Gosub ^!c    ; Copy active window wintitle info to clipboard
    CoordMode, Mouse, %save_coordmode%
    BlockInput, Off
    Return

}

!+MButton::	  ; Reload "Launch folder"
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

#!n::   ; Close all untitled Notepad windows
{
    win_title := "(Untitled|deleteme.junk) - Notepad ahk_class Notepad"
        countx = 0
    While WinExist(win_title)
    {
        WinClose, %win_title%
        ; click don't save
        If WinExist("Notepad ahk_class #32770")
        {
            WinActivate
            WinWaitActive
            ; ControlClick, Button2, A
            SendInput n
            Sleep 10
        }
    }
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
    

^!+s::   ; Starts Search Everything for AutoHotkey type files
{
    ; If MyHotkeys was started with Administrator privileges Search Everything will start without UAC prompt
    Run, C:\Program Files\Everything\Everything.exe  -search "file:*.ahk|*.txt <Autohotkey Scripts> <!plugins> <!tetris>" -matchpath -sort "date modified" -sort-descending 
	WinWaitActive, ahk_class EVERYTHING ahk_exe Everything.exe
    SendInput {Home}{Right 5}
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
    
RAlt & w::      ; Display basic active window info 
{
    OutputDebug, DBGVIEWCLEAR
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

   write_string := ""
   write_string .= "title: " i_title "`r`n"
   write_string .= "class: " i_class "`r`n"
   write_string .= "proc : " i_procname "`r`n"
   write_string .= "hwnd : " i_hwnd "`r`n"
   write_string .= "focus: " got_focus "`r`n"
   write_string .= "Control List:`r`n"
    Loop, Parse, control_list, "`r`n"
    {
        ControlGet, is_visible, Visible,, %A_LoopField%, A
        If is_visible
            write_string .= A_LoopField "`r`n"
    }
    OutputDebug, % write_string
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Return
}

CapsLock & F10::   ; Adds selected words to lib\AHK_word_list.ahk
{
    KeyWait CapsLock
    SetCapsLockState, AlwaysOff
    Run, MyScripts\Utils\Add Selection To AHK Word List.ahk
    Return
}   
;************************************************************************
#If WinActive("Age of Empires II Expansion ahk_class Age of Empires II Expansion")
LWin::Return	; disable winkey in AOE
;************************************************************************
;
; Hotkeys available for Google Chrome
; 
;************************************************************************
; #If WinActive("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")


;************************************************************************
;
; Hotkeys available for MPV (NHLGames.exe default media player)
; 
;************************************************************************
#If WinActive("ahk_class mpv ahk_exe mpv.exe")
{
    LButton:: Click, Left
    RButton:: Click, Right
    WheelUp:: SendInput {Right 3}           ; seek forward  15 seconds
    WheelDown:: SendInput {Left 3}          ; seek backward 15 seconds
    LButton & WheelUp:: SendInput {Right}   ; seek forward  5 seconds
    LButton & WheelDown:: SendInput {Left}  ; seek backward 5 seconds
    RButton & WheelUp:: SendInput 0         ; volume up'
    RButton & WheelDown:: SendInput 9       ; volume down
    MButton:: SendInput O                   ; toggle show progress 
}
Return
;************************************************************************
;
; Load hotkeys that are only available ONLY when dealing with Youtube
; type video players in Chrome
; 
;************************************************************************
#IfWinActive
#If

^!+RButton::
^!+y::   ; Runs mouse hotkeys for embedded videoplayers with similar keyboard controls (ie youtube)
{
    Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Web\Youtube - hotkeys.ahk
    Return
}

^!y::
{
    Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\Utils\Web\Youtube Keys.ahk
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
; Make these hotkeys available ONLY when dealing with Windows Magnifier (#=)
; 
;************************************************************************
#If WinExist("ahk_exe Magnify.exe")
#+=::Send #{Escape}   ; exit magnifier
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
    Clipboard := StrReplace(the_text, "`r`nahk_exe", " ahk_exe")
    MsgBox, 64,,Window Spy info saved On Clipboard.`n`n%Clipboard%, 1
    Return
}

^!+c::   ; Copies WinTitle and ClassNN info from AutoHotkey Window Spy to the clipboard
{
    ControlGetText, the_text1, Edit1, Window Spy ahk_exe AutoHotkey.exe   
    the_text1 := StrReplace(the_text1, "`r`nahk_exe", " ahk_exe")
    ControlGetText, the_text3, Edit3, Window Spy    
    Clipboard := "/*`r`n" the_text1 "`r`n" the_text3 "`r`n*/"
    MsgBox, 64,,Window Spy info saved On Clipboard.`n`n%Clipboard%, 1
    Return
}
;************************************************************************
;
; Make these hotkeys available ONLY within ConsoleWindowClass type windows
; ie cmd.exe. Exclude Powershell which scrolls properly without this.
; 
;************************************************************************
#If WinActive("ahk_class ConsoleWindowClass") And Not WinActive("ahk_class ConsoleWindowClass ahk_exe powershell.exe")

WheelUp::
PgUp::
{
    SendInput {Control Down}{Up 10}{Control Up}
    Return
}

WheelDown::
PgDn::
{
    SendInput {Control Down}{Down 10}{Control Up}
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
; Make these hotkeys available ONLY within Microsoft Spy++
; 
;************************************************************************
#If WinActive("Microsoft Spy\+\+")
~f::    ; Flashes selected window or control (highlight)
{
    SendInput {AppsKey}h
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
  
^m::    ; Go to Logging Options / wm_command
{
    WinMenuSelectItem, A,, &Messages, Logging &Options
    SendInput +{Tab}{Right}!c{Tab}w{Down 19}    ; scroll down to wm_command
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
	ControlGet, is_visible, Visible,, Edit4, A
	If is_visible
		ControlClick, Edit4, ahk_class WindowsForms10.Window.8.app.0.378734a	; standard find
	Else
		ControlClick, Edit7, ahk_class WindowsForms10.Window.8.app.0.378734a	; regex find
    Return
}

;************************************************************************
;
; Make these hotkeys available to ZeroBrane Studio (LUA IDE)
; Clicks assume window is maximized
; 
;************************************************************************
#If WinActive("ZeroBrane Studio.* ahk_class wxWindowNR ahk_exe zbstudio.exe")
!n::	; click next
{
	WinMaximize
	Sleep 100
	Click, Left, 520, 117
	Return
}

F8::	; Activate/Switch between main window and active 'output/local console/markers' window
{
	WinMaximize
	Sleep 100
	save_coordmode_mouse := A_CoordModeMouse
	CoordMode, Mouse, Screen
	If (A_CaretY <= 745)
		Click, Left, 410, 930
	Else If (A_CaretY > 745)
		Click, Left, 410, 440
	CoordMode, Mouse, %save_coordmode_mouse%
	Return
}
;************************************************************************
;
; Make these hotkeys available to Notepad++ only
; 
;************************************************************************
#If WinActive("ahk_class Notepad\+\+") or WinActive("ahk_class #32770 ahk_exe notepad\+\+\.exe")

!x:: Return     ; overrides Close current script (don't know where thats set ?!#$%)

^Numpad1::  ; Goto line from DbgView debug msg (can also be called from DbgView Popup Menu.ahk)
            ; (ie if dbgview selected line has "Line#<n>" will goto that line in Notepad++ current script)
{
    Run, MyScripts\NPP\Misc\Goto line from DbgView debug msg.ahk
    Return
}

^!+Space::  ; Show auto-completion keyboard shortcuts
{
    Run, MyScripts\NPP\Misc\Auto-Completion Keyboard Shortcuts.ahk
    Return
 }
 
^o::
 {
     Run,MyScripts\NPP\Misc\Open Selected Relative Path FleName.ahk
     Return
 }

!c::    ; Toggles Clipboard History panel
{
    ControlGet, is_visible, Visible,, Button9, A
    If WinExist("Clipboard History") 
        WinClose
    Else If is_visible
    {
        ControlGetPos,,, w, h, Button9, A
        x := w - 7
        y := Round(h/2)
        xy := "x" x " y" y
        ControlClick, Button9, A,, Left, 1, NA %xy%
    }
    Else
        WinMenuSelectItem, A,, Edit, Clipboard History
    Return
}

!i::    ; Opens include file if caret is on line with #Include statement
{
    Run, MyScripts\Utils\OpenInclude.ahk
    Return
}

^+d::	; debug current file in SciTE4AutoHotkey
{
	script_fullpath := get_filepath_from_wintitle()
	oscite := create_scite_comobj()
	If (oscite = False)
		Return
	;
	oscite.DebugFile(script_fullpath)
	Sleep 10
	move_variable_list()
	Return
}

^+r::   ; Recent files menu
{
    SendInput !fr{Down 3}
    Return
}

Control & WheelDown::   ; Move file tab backward in tab bar
Control & WheelUp::     ; Move file tab forward in tab bar
Alt & WheelDown::       ; chooses the next opened file in tab bar the left
Alt & WheelUp::         ; chooses the next opened file in tab bar to the right
{
    If (A_ThisHotkey = "Alt & WheelUp")
        WinMenuSelectItem,A,, View, Tab, Next Tab
    Else If (A_ThisHotkey = "Alt & WheelDown")
        WinMenuSelectItem,A,, View, Tab, Previous Tab
    Else If (A_ThisHotkey = "Control & WheelUp")
        WinMenuSelectItem,A,, View, Tab, Move Tab Forward
    Else If (A_ThisHotkey = "Control & WheelDown")
        WinMenuSelectItem,A,, View, Tab, Move Tab Backward 
    Return
}

^!F7::  ; Creates Shortcut Mapper List from scratch (ie the most updated status of shortcuts) and proceeds to Finder program
^F7::   ; Opens the last Shortcut Mapper List created and proceeds to Find routine. This is faster than creating from scratch but list may be outdated.
F7::    ; Toggle Search Results Window
{
    If (A_ThisHotkey = "F7")
        Run, MyScripts\NPP\Misc\Toggle Search Results Window.ahk
    Else If (A_ThisHotkey = "^F7")
        Run, MyScripts\NPP\Shortcut Mapper\Finder.ahk
    Else If (A_ThisHotkey = "^!F7")
        Run, MyScripts\NPP\Shortcut Mapper\Get List.ahk
    Return
}

^w::    ; Close current window/file/tab. Overrides extend selection right in NPP.
{
    SendInput ^{F4}
    Return
}

^+f::   ; Same as ^f but executes "Find All in Document" on selected text 
^f::    ; Creates an Access Key in the Edit dialog to "Find All In Current Document"
{
    If (A_ThisHotkey = "^f")
        Run, MyScripts\NPP\Misc\Find All In Current Document.ahk
    Else If (A_ThisHotkey = "^+f")
        Run, MyScripts\NPP\Misc\Find All In Current Document.ahk "DoIt"
    Return
}

^!+F8:: Run, "MyScripts\NPP\Misc\Rotate View.ahk"

^!n::    ; open new ahk file in root dir
{
    Run, "MyScripts\NPP\Misc\Create New AHK Scratch File.ahk"
    Return
}

^!q::    ; Toggles auto-completion
{
    RunWait, MyScripts\NPP\Misc\Toggle Preferences Setting.ahk Toggle "Enable auto-completion on each input" True False  ; "Button141" 
    RunWait, MyScripts\NPP\Misc\Toggle Preferences Setting.ahk On "Function and word completion" False False             ; "Button144" 
    RunWait, MyScripts\NPP\Misc\Toggle Preferences Setting.ahk On "Ignore numbers" False False                           ; "Button145"
    RunWait, MyScripts\NPP\Misc\Toggle Preferences Setting.ahk Off "Function parameters hint on input" False False       ; "Button146"    
    Return
}

^q::    ; Toggles Doc Switcher
{
    RunWait, MyScripts\NPP\Misc\Toggle Preferences Setting.ahk Toggle Button9 False True 
    If (clipboard = 1)
        ControlFocus, SysListView321, A
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

F12 & 0::   ; Creates a file with only alt+0 folded lines for the current file
{
    Run, MyScripts\NPP\Misc\Copy Folded Visible Lines Only.ahk
    Return
}
    
F5::	; Run, F5 - Save and Run Current Script.ahk
{
    WinMenuSelectItem, A,, File, Save
    fname := get_filepath_from_wintitle()
    If SubStr(fname, -3) = ".ahk"
        Run, %A_AhkPath% "%fname%"
    Else
        MsgBox, 48,, % "Not an AHK script:`r`n" fname, 3
    Return
}

F12::   ; Toggle edit/find all in documents results window
{
    Run, MyScripts\NPP\Misc\Close All Windows.ahk
    Return
}

CapsLock & a::  ; Replaces the the selected character with corresponding chr(<x>) phrase. 
                ; ie: select a semicolon hit the hotkey and it will be replaced with chr(59)
{
    OutputDebug, % "A_ThisHotkey: " A_ThisHotkey " - A_ScriptName: " A_ScriptName 
    SetCapsLockState, AlwaysOff
    char := check_selection_copy(1,0,0)
    If (char == "")
    {
        MsgBox, 48,, % "Selection didn't meet parameter requirements.", 10
        Return
    }
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

^l::    ; Documents all procedure calls in lib directory
{
    RunWait, MyScripts\Utils\Lib Procedures Documenter.ahk
    Return
}

F1::    ; Opens AutoHotkey Help file searching index for currently selected word   
{
    Run, MyScripts\Utils\AHK Context Help File.ahk
    Return
}

F12 & \::    ; Remaps keyboard so that typing in SEND commands is easier
{
    Run, MyScripts\Utils\Remap Keyboard For Send.ahk
    Return
}
   
;************************************************************************
;
; Hotkeys that are the same for Notepad++ and SciTE4AutoHotkey
;
;************************************************************************
#If WinActive("ahk_class SciTEWindow") or WinActive("ahk_class Notepad\+\+")

^!j::   ; Formats selected word into my output debug format (ie "MyVar: " MyVar"
^j::    ; Combines selected separate OutputDebug / MsgBox lines into 1 line
{
    If (A_ThisHotkey = "^j")
        Run, MyScripts\Utils\Combine Separate Debug Lines.ahk
    Else If (A_ThisHotkey = "^!j")
        Run, MyScripts\Utils\Make Debug Format Variable.ahk
    Return
}

^i::    ; Inserts code snippet (Code Snippets.txt) for word at caret position or selected text
^!i::   ; Select key word then select code lines to be inserted into Code Snippets.txt (opposite of ^i)  
^!+i::  ; Displays the current list of available code snippet and lists applicable hotkeys
{
    If (A_ThisHotkey = "^i")
        Run, MyScripts\Utils\Insert Snippet For Selected Word.ahk
    Else If (A_ThisHotkey = "^!i")
        Run, MyScripts\Utils\Insert Selected Text into Code Snippets.txt.ahk
    Else If (A_ThisHotkey = "^!+i")
        Run, MyScripts\Utils\Display Code Snippet Info.ahk
    Return
}

^Numpad9::    ; Runs active script as administrator
{ 
	SendInput ^s  
    script_fullpath := get_filepath_from_wintitle()	
    Run *RunAs "%A_AHKPath%" /restart "%script_fullpath%"
    Return
}

^+[::   ; Wrap Braces {} AFTER current line
^[::    ; Wrap Braces {} AROUND current line
{   
    Run, MyScripts\NPP\Misc\Braces Indented.ahk %A_ThisHotkey%
    Return
}    

Control & Insert::    ; Select entire line including any leading whitespace  
{
    SendInput {LAlt Down}{Home}{Shift Down}{End}{LAlt Up}{Shift Up}
    Return
}

^!+F1::     ; AutoHotkey RegEx Quick Reference
{
    Run, https://www.autohotkey.com/docs/misc/RegEx-QuickRef.htm
    Return
}

CapsLock & F2::     ; Beautify current AHK Script
{
    KeyWait CapsLock
    WinMenuSelectItem, A,,File,Save
    Run, MyScripts\Utils\Beautify AHK.ahk
    Return
}

RAlt & s::	; Open current script in SciTE4AutoHotkey or Notepad++
{
	script_fullpath := get_filepath_from_wintitle()
	If WinActive("ahk_class Notepad\+\+") 
		Run, "C:\Program Files\AutoHotkey\SciTE\SciTE.exe" "%script_fullpath%"
	Else If WinActive("ahk_class SciTEWindow")
		Run, "C:\Program Files (x86)\Notepad++\notepad++.exe" "%script_fullpath%"
	Return
}

^!+0::  ; Wrap Expressions In Parentheses
{
    Run, MyScripts\Utils\Wrap Expressions In Parentheses.ahk
    Return
}

^m::    ; Copies the current word and pastes it to MsgBox % statement on a new line.
{
    saved_clipboard := ClipboardAll
    Clipboard := ""
    SendMode Input
    SendInput % SEND_COPYWORD
    ClipWait, 5
    SendInput {End}{Enter}MsgBox,{Space}`%{Space}
    SendInput % SEND_WORD_NAME_VALUE_NO_DELIM
    SendInput {Home}
    Sleep 200
    Clipboard := saved_clipboard
    Return
}

!+o::   ; output_debug("*** time ***" ) debugging statement on a new line.
{
    SendInput {End}{Enter}OutputDebug, `% `"*** `" . get_time() . ":" . A_MSec . `" ***`"{Home}
    Return
}


^!o::   ; Copies the current word and pastes it to OutputDebug statement on a new line.
{
    the_word := RTrim(select_and_copy_word())
    SendInput {End}{Enter}OutputDebug, `%{Space} 
    SendRaw %the_word%
    SendInput {Home}
    Return
}
    
^!+o::  ; Copies the current word and inserts into: OutputDebug, % "theword: " theword - statement on a new line.
{
    the_word := RTrim(select_and_copy_word())
    send_cmd := " % " . Chr(34) . the_word . ": "  . Chr(34) . A_Space . the_word
    SendInput {End}{Enter}OutputDebug, 
    SendRaw %send_cmd%
    SendInput {Home}   
    Return
}

^!+t::  ; Copies the current word and inserts it into ttip("theword: " theword, 1500) on a new line.
{
    the_word := RTrim(select_and_copy_word())
    send_cmd = "``r``n%the_word%: " %the_word% " ``r``n ",,500,500) 
    SendInput {End}{Enter}ttip( 
    SendRaw %send_cmd%
    SendInput {Home}   
    Return
}

; Shifted
^!+8::	; wraps *** word ***
^!+-::	; wraps _word_
^!+,::	; wraps <word>
^!+[::	; wraps {word}
^!+'::	; wraps "word"
^!+5::	; wraps %word%
^!+9::	; wraps (word)
; Unshifted 
^!8::	; wraps *** word ***
^!-::	; wraps -word-
^!,::	; wraps <word>
^![::	; wraps [word]
^!'::	; wraps 'word'
^!5::	; wraps %word%
^!9::	; wraps (word)
{
	shift_key := (SubStr(A_ThisHotkey, 1, 3) = "^!+") ? True : False
	key_to_wrap := SubStr(A_ThisHotkey,0)
	If (key_to_wrap = "[") 
	{
		wrap_key1 := shift_key ? "{" : "["
		wrap_key2 := shift_key ? "}" : "]"
	}
	Else If (key_to_wrap = "-") 
		wrap_key1 := wrap_key2 := shift_key ? "_" : "-"
	Else If (key_to_wrap = ",") 
	{
		wrap_key1 := "<"
		wrap_key2 := ">"
	}
	Else If (key_to_wrap = "9") 
	{
		wrap_key1 := "("
		wrap_key2 := ")"
	}
	Else If (key_to_wrap = "8") 
	{
		wrap_key1 := "*** "
		wrap_key2 := " ***"
	}
	Else If (key_to_wrap = "'")
		wrap_key1 := wrap_key2 := shift_key ? Chr(34) : "'"  		; chr(34) is ASCII: "
	Else If (key_to_wrap = "5")
		wrap_key1 := wrap_key2 := "%"
	Else
		MsgBox, 48, Unexpected Error, % A_ThisFunc " - " A_ScriptName
	;
	saved_clipboard := ClipboardAll
	Clipboard := ""
	SendInput ^{Left}^+{Right}^x
	ClipWait, 2
	the_word := Clipboard
	; wrapped_string := RegExReplace(the_word, "(^#?\w+)(\s*)", wrap_key1 "$1" wrap_key2 "$2", replaced_count)
	wrapped_string := RegExReplace(the_word, "(^#?\b\w+\b)(.*)", wrap_key1 "$1" wrap_key2 "$2", replaced_count)
	If (replaced_count = 0)
		WinMenuSelectItem, A,, Edit, Undo
	Else
		SendRaw %wrapped_string%
	Clipboard := saved_clipboard
	Return
}
;************************************************************************
;
; Hotkeys that are for SciTE4AutoHotkey only 
;
;************************************************************************
#Include MyScripts\SciTE\lib\scite4ahk_hotkeys.ahk
