/*
DBGp Add Watch

The word that the cursor is positioned on gets added to the DBGp Add Watch window.
It saves you from rightclicking watch panel, selecting add watch and typing in the word.

To run:
1) Assign this script a hotkey (ie - F9::Run, DBGp Add Watch.ahk)

2) Start DBGp Debugger. 

3) Select Watches Tab.

4) Two modes for word selection:

    a) Select entire expression you want added to watch with mouse 
       (this option is best if the word you want has lots non-alphanumeric characters that won't get selected with mode b)
                    OR
    b) Place cursor caret anywhere on the word in your code that you want added to watches.
    
    If nothing was selected when you do step 5 then mode b will be assumed. 
    
5) Hit the hotkey (ie - F9) to add the word to watches.

6) Repeat steps 4+5 for every word you want to add. 

Notes:
The DBGp window can be in 1 of 3 possible states:

    1) The entire DBGp window is undocked with all the panels still together
    2) The watches panel is undocked and separated from the local and global context tabs
    3) The window is docked and the Watches panel has been activated

Each of these 3 states requires it's own tweaks for the processing to work. Only 1
of the 3 states will be applicable at run time.

21-Jun-2018 - State 1 should work but hasn't been tested thoroughly because DBGp keeps  
              freezing in the undocked state for no apparent reason. Notepad++ has to killed 
              to regain access. Not worth tracking down because I never run debugger in that state.

*/
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
#SingleInstance Force
SetWorkingDir %AHK_ROOT_DIR%
SetTitleMatchMode 2
SetTitleMatchMode Slow
#NoTrayIcon

MouseGetPos, save_x, save_y
WinGetTitle, win_title, A
;------------------------------------------------------
; Check of DBGp is running and try to start it if it isn't.
;------------------------------------------------------
if not start_dbgp()
    error_handler("DBGp debugger is not running.")

;------------------------------------------------------------
; Debug is running, get the selected word chosen to be added to watches.    
;------------------------------------------------------------
the_word := select_and_copy_word()

;------------------------------------------------------------
; State 1: Check if entire DBGp window is undocked but watches tab is still together with  the local and global context tabs
;------------------------------------------------------------
undocked_DBGp_win_title := "DBGp ahk_class #32770 ahk_exe notepad++.exe"
if WinExist(undocked_DBGp_win_title)
{
    ; Entire DBGp window is undocked, get the classNN of watches panel
    WinGet, tvirtual_tree_classNN, ControlList, %undocked_DBGp_win_title%
    if tvirtual_tree_classNN
       add_watch(False, undocked_DBGp_win_title, tvirtual_tree_classNN, the_word)
}

;------------------------------------------------------------
; State 2: Check if Watches window is undocked and separated from the local and global context tabs which are still docked.
;------------------------------------------------------------
undocked_watches_title := "Watches ahk_class TDebugWatchFrom ahk_exe notepad++.exe"
if WinExist(undocked_watches_title)
{
    ; Only the Watches window is undocked, get the classNN of watches panel
    WinGet, tvirtual_tree_classNN, ControlList, %undocked_watches_title%
    if tvirtual_tree_classNN
       add_watch(False, undocked_watches_title, tvirtual_tree_classNN, the_word)
}

;------------------------------------------------------------
; State 3: Check if Watches window is docked
;------------------------------------------------------------
control_class := "TDebugWatchFrom1"     ; Watches
ControlGet, is_visible, Visible,,%control_class%, %win_title%
if is_visible
{
    ; Watches panel is docked and together with local and global context tabs.
    add_watch(True, win_title, control_class, the_word)
}
else if (tvirtual_tree_classNN == "")
    ; Both docked and undocked checks failed so exit program.
    error_handler("The Watches panel is not activated.")

SendInput {Escape}  ; in case an unwanted rightclick menu activated
MouseMove, save_x, save_y
ExitApp

error_handler(p_msg)
{
    MsgBox, 48,, %p_msg% `n`nMake sure DBGp is running and that the Watches tab is selected. 
    ExitApp
}

add_watch(p_docked,p_win_title, p_classNN, p_the_word)
{
    ; Get the coordinates of the correct control to rightclick on.
    ControlFocus, %p_classNN%, %p_win_title%, Watches
    ControlGetFocus, got_focus, A
    if (got_focus <> p_classNN)
        OutputDebug, "Error getting focus."

    if p_docked
        ControlGetPos, x, y, width, height, %p_classNN% , A, Watches
    else if !p_docked
        WinGetPos, x, y, width, height, %p_win_title% 
    else
        error_handler("Unexpected docked state: " p_docked "`nShould be either True or False.")
    
    ; activate the "Add watch" context menu item  
    MouseMove, x + 100, y + 100
    Click,,Right
    SendInput a
    Sleep 100

    ; Check that Add watch window is open
    add_watch_win := "Add watch ahk_class TDebugEditWatchForm ahk_exe notepad++.exe"
    WinActivate, add_watch_win
    if !WinActive(add_watch_win)
        error_handler("Couldn't activate window: " add_watch_win)
    Sleep 50
    
    ; Add Watch window is activated and ready to accept the variable chosen to be added
    ControlSetText, TEdit1, %p_the_word%, %add_watch_win%
    SendInput {Enter}
    Return 
}
