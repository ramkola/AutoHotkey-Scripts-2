;---------------------------------------------------------------------------------------
;
; Creates an access key in the Search/Find dialog to "Find all in Current Document"
; Automates the search process especially when called with parameters.
;
;       Parameters: 
;           A_Args[1]: (search_text)
;               "DoIt" - finds all occurrences of selected text OR if nothing selected, the word where the caret is positioned
;                        this is the default behaviour of Search/Find (^f) with the added feature of 
;                        clicking the Find All In Current Document button automatically.
;                      
;               <text> - Any other text than DOIT will considered the text to be searched for.
;                        This can also be a regular expression.
;
;           A_Args[2]: (regex_flag) Set to True to search for <search_text> as regex.
;                       If this parameter is not set or is False then it will do the same
;                       search with the previous settings (ie: default behaviour of Search/Find (^f))
;
; Note: there is an access key "!d" that has either been added or somehow I never noticed
;       but this routine is still very useful and is called by several hotkeys and programs.
;       So be careful modifying it.
;
; Examples:
;   Run, Find All In Current Document.ahk                           ; Makes !a hotkey available as accelerator key for Find All In Current Document (similar to !d)
;   Run, Find All In Current Document.ahk "DoIt"                    ; Equivalent to ^f !d using whatever search term that was previously used
;   needle = ^(some text|some other text).*?$
;   Run, Find All In Current Document.ahk "%needle%" %True%         ; regex
;
;---------------------------------------------------------------------------------------
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\utils.ahk
#NoEnv
; #NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_ROOT_DIR%
StringCaseSense Off
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png
SetTitleMatchMode 3     ; exact

search_text := (A_Args[1] == "DoIt") ? "" : A_Args[1]
regex_flag := A_Args[2]

find_wintitle := "Find ahk_class #32770"
edit_wintitle := "ahk_class Notepad++ ahk_exe notepad++.exe"
ControlGetfocus, edit_control, A    ; used to return focus in Notepad++ to where it was before the find all
WinMenuSelectItem, %edit_wintitle%,,Search,Find
Sleep 100

; if any runtime param is passed, Find All in Current Document will 
; execute automatically as explained above.
If A_Args.Length() > 0  
    Gosub !a

; If hotkey was not used then the program would never exit. Timer ensures that the 
; program exits automatically after 10 seconds if the find_wintitle is not active.
; Note: Search is executed with the same options set on the last manual search. 
SetTimer, EXIT_FIND_ALL, 1000   
Return

!a::    ; Set up the Find Window search params and execute Find All In Current Document
    If search_text
        ControlSetText, Edit1, %search_text%, %find_wintitle%
    If regex_flag
    {
        ; Mark regex radio button
        ControlGet, is_checked, Checked,, Button18, %find_wintitle%
        If Not is_checked
            Control, Check,, Button18, %find_wintitle% 
    }
    ; Unmark Backward direction checkbox
    ControlGet, is_checked, Checked,, Button11, %find_wintitle%
    If is_checked
        Control, Uncheck,, Button11, %find_wintitle% 
    ; Unmark Match whole word only checkbox
    ControlGet, is_checked, Checked,, Button12, %find_wintitle%
    If is_checked
        Control, Uncheck,, Button12, %find_wintitle% 
    ; Unmark Match Case checkbox
    ControlGet, is_checked, Checked,, Button13, %find_wintitle%
    If is_checked
        Control, Uncheck,, Button13, %find_wintitle% 
    ; Mark Wrap around checkbox
    ControlGet, is_checked, Checked,, Button14, %find_wintitle%
    If Not is_checked
        Control, Check,, Button14, %find_wintitle% 
    ; Mark Matches Newline checkbox
    ControlGet, is_checked, Checked,, Button19, %find_wintitle%
    If Not is_checked
        Control, Check,, Button19, %find_wintitle% 
    ; Click Find All In Current Document button
    ControlClick, Button26, %find_wintitle%,,,, NA  
    sleep 500
    WinClose, %find_wintitle%     ; sometimes it doesn't close by itself 
    ; return focus from "Find Result" window to editor (personal preference)
    Controlfocus, %edit_control%, A
    Click
    Return
    
EXIT_FIND_ALL:
    If WinActive(find_wintitle)
        Return
    Exitapp

set_find_criteria(p_checked, p_classnn)
{
    
}
ExitApp