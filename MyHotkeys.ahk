; ---------------------------------------------------------------------------------------------
; Braces are used to be able to fold (!0) the document the way I want  
; ---------------------------------------------------------------------------------------------
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
#MenuMaskKey vk07   ; suppress unwanted win key default activation.

SendMode Input
SetTitleMatchMode %STM_CONTAINS% 
SetWorkingDir %AHK_MY_ROOT_DIR%
Menu, Tray, Icon, resources\32x32\Old Key.png, 1

Run, MyScripts\MyHotStrings.ahk
; Run, plugins\Hotkey Help (by Fanatic Guru).ahk      ; Hotkey Help - Run anytime MyHotkeys.ahk is started #F1 to active it.
; Run, plugins\Convert Numpad to Mouse.ahk
 
;************************************************************************
;
; The following hotkeys are globally available in any window 
; 
;************************************************************************
#IfWinActive

; these are here for documentation only they don't do anything. they "reserve" usage for windows
; ~#a::Return                   ; Window's view notifications history 
; ~#d::Return                   ; Window's show desktop toggle (minimize/restore all windows)
; ~#e::Return                   ; Window's File Explorer
; ~#i::Return                   ; Window's Settings
; ~#l::Return                   ; Window's Lock Screen
; ~Alt & Tab::Return            ; Window's switch application 
; ~Alt & Shift & Tab::Return    ; Window's switch application 
; ~Control & Tab::Return        ; Windows virtual desktop selector
; ~Control & LWin & Left::      ; Windows move to virtual desktop window on the left
; ~Control & LWin & Right::     ; Windows move to virtual desktop window on the right


#g::    ; Start's DbgView as administrator and avoids UAC prompt 
{
        ; - if MyHotkey was already started as admin
        ; (Needed to disable Window's Game Bar in Settings to use #g.)
    WinGet, i_hwnd, ID, A
    active_win := "ahk_id " . i_hwnd
    win_title := "ahk_class dbgviewClass ahk_exe Dbgview.exe"
    If !WinExist(win_title)
        Run, "C:\Program Files (x86)\SysInternals\Dbgview.exe"
    Else
    {
        WinActivate, %win_title%
        OutputDebug, DBGVIEWCLEAR
    }
    WinWaitActive, %win_title%,,1
    If WinActive(win_title)
        WinMenuSelectItem, A,,Computer, Connect Local
    WinActivate, %active_win%
    Return
}
    
#0::    ; activate screensaver
{
    Sleep 2000  ; time needed to stop touching keyboard or mouse
    Run, C:\Users\Mark\Documents\Launch\Utils\scrnsave.scr.lnk
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

LWin & WheelUp::    ; Scroll to Window's virtual desktop to the right
{
    SendInput {Control Down}{LWin Down}{Right}{Control Up}{LWin Up}
    Return
}

LWin & WheelDown::     ; Scroll to Window's virtual desktop to the left
{  
    SendInput {Control Down}{LWin Down}{Left}{Control Up}{LWin Up}
    Return
}

~MButton::SendInput ^c
     
~#+s::      ; Captures selected portion of screen and opens it up in IrfanView
{
    ; Wait_For_Escape("Select capture with mouse then`n")
    input, ov,,{Control}
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

#^c::   ; Disabled window's change color theme (??)
    Return

#!::   ; Start xplorer2 lite
{
    ; Run, C:\Program Files (x86)\zabkat\xplorer2_lite\xplorer2_lite.exe /M
    ; Return
}
    
#^w::    ; Runs WinDowse  
{
    Run, C:\Program Files (x86)\Greatis\WinDowse\WinDowse.exe
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
    GoSub ^!+f  ; Changes font within MS Spy++
    Return
}

#w::    ; Runs AutoHotkey's Window Spy 
{
    ws_wintitle := "Window Spy ahk_class AutoHotkeyGUI ahk_exe AutoHotkey.exe"
    Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
    Sleep 100
    SetTitleMatchMode 3
    ControlFocus, Button1, %ws_wintitle%
    Control, Check,,Button1, %ws_wintitle%   ; Follow Mouse
    ControlFocus, Button2, %ws_wintitle%
    Control, Check,,Button2, %ws_wintitle%   ; Slow TitleMatchMode  
    Return
}

#n::    ; Runs Window's Notepad 
{
    Run, Notepad.exe
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
    if ErrorLevel
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
    Run, C:\Program Files\Everything\Everything.exe
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
    
#F1::    ; Opens AutoHotkey Help file searching index for currently selected word available to any program as opposed to F1 below  
{
    Run, MyScripts\Utils\AHK Context Help File.ahk
    Return
}

#+F1::  ; Hotkey Help - #F1 to active it.
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

    output_debug("")    ; starts dbgview if not already started
    Sleep 10
    OutputDebug, DBGVIEWCLEAR
    OutputDebug, -------------------
    OutputDebug, % "title: " i_title
    OutputDebug, % "class: " i_class
    OutputDebug, % "proc : " i_procname
    OutputDebug, % "hwnd : " i_hwnd 
    outputdebug, % "focus: " got_focus
    OutputDebug, -------------------
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
; Make these hotkeys available ONLY when dealing with PythonScript
; 
;************************************************************************
; #If

;************************************************************************
;
; Make these hotkeys available ONLY within ConsoleWindowClass type windows
; (ie cmd.exe or vlc --intf rc powershell (doesn't need this for scrolling)
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

^f::    ; fullscreen
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput f
    Return
}

^s::    ; stop
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput s
    Return
}


^!a::   ; Sets VLC defalt audio device to speakers
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    ; WinMenuSelectItem, VLC media player ahk_class Qt5QWindowIcon,, Audio, Audio Device, Speakers (Realtek High Definition Audio) 
    SendInput {Alt Down}ad
    Sleep 1000
    SendInput {Up}{Alt Up}{Enter}
    Return
}
    
^!y::   ; Saves VLC unwatched.xspf playlist
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput ^y
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched.xspf!s{Left}
    Return
}

^!+y::   ; Saves VLC unwatched backup.xspf playlist
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput ^y
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched backup.xspf!s{Left}
    Return
}

^!o::   ; Opens VLC unwatched.xspf playlist
{
    WinActivate, VLC media player ahk_class Qt5QWindowIcon
    SendInput ^o
    Sleep 500
    SendInput C:\Users\Mark\Google Drive\Unwatched.xspf
    Return
}

^+o::   ; Show containing folder...
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
        SendEvent Consolas{tab 2}16{shift down}{tab 2}{shift up}{Enter}
    Return
}
    
^!+x::  ; Clear messages screen
{
    WinMenuSelectItem,A,,Messages,Clear Log
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

^!+F5::   ; Debug current script being edited with DBGp debugger
{
    Run, MyScripts\NPP\Misc\Debug Current Script.ahk
    Return
}

F3::    ; Accelerator Key for TextFX menu
{
    ; WinMenuSelectItem, A,, TextFX, TextFX Characters
    WinMenuSelectItem, A,,Edit,Indent
    Return
}

F6::    ; Show Python Script Console
{
    WinMenuSelectItem, A,, Plugins, Python Script, Show Console
    Return
}

^!F7::   ; Creates Shortcut Mapper List from scratch (ie the most updated status of shortcuts) and proceeds to Finder program
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
    return
}

^+f::   ; Same as ^f but executes "Find All in Document" on selected text 
{
    Run, MyScripts\NPP\Misc\Find All In Current Document.ahk "DoIt"
    return
}
   
;************************************************************************
;
; Make these hotkeys available to Notepad++ or SciTE4AutoHotKey
;
; Note: these probably work in most text controls, editors with standard keyboard shortcuts
; 
;************************************************************************
#If WinActive("ahk_class Notepad++") or WinActive("ahk_class SciTEWindow") or WinActive("ahk_class Notepad")

^q::    ; Turns auto-completion off
{
    Run,  MyScripts\NPP\Misc\Toggle Preferences Setting.ahk "Toggle" "Button141" "Autocomplete"
    Return
}

^!q::    ; Turns Doc Switcher off
{
    Run,  MyScripts\NPP\Misc\Toggle Preferences Setting.ahk "Toggle" "Button9" "Doc Switcher"
    Return
}

!+c::    ; Show Constants.ahk and utils.ahk in Notepad
{
    fname := A_WorkingDir . "\lib\constants.ahk"
    Run, Notepad.exe %fname%
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
    sleep 200
    Clipboard := saved_clipboard
    Return
}

!+p::   ; Print("*** time ***" ) debugging statement on a new line.
{
    SendInput {End}{Enter}Print(`"*** `" . get_time() . ":" . A_MSec . `" ***`"){Home}
    Return
}

^!p::   ; Copies the current word and pastes it to Print() statement on a new line.
{
    the_word := select_and_copy_word()
    SendInput {End}{Enter}Print({Control Down}v{Control Up}){Home}
    Return
}

^!+p::  ; Copies the current word and pastes it to Print("copyword: " . copyword) statement on a new line.
{
    the_word := select_and_copy_word()
    SendInput {End}{Enter}Print(
    SendInput % SEND_WORD_NAME_VALUE
    SendInput ){Home}
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
    send_cmd := "% " . chr(34) . the_word . ": |"  . chr(34) . A_Space . the_word . A_Space . chr(34) . "|" . chr(34)
    SendInput {End}{Enter}OutputDebug, %send_cmd%{Home}   
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
    SendInput {Backspace}
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
    
F5::    ; Runs the current AHK Script being edited. It will save the filename before executing it.
{
    WinMenuSelectItem, A,,File,Save
    Sleep 10
    fname := get_current_npp_filename()
    Run, %A_AHKPath% "%fname%" 
    Return
}

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