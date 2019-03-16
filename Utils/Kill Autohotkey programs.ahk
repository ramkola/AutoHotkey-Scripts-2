#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\processes.ahk
#Include lib\utils.ahk
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\Misc\Bloody Hatchet.png

If Not A_IsAdmin 
{
    Run, *RunAs %A_ScriptFullPath%
    ExitApp
}

refresh_tray()  ; removes dead icons from systray when this script reloads/refreshes

; retrieve process info to clipboard
SetTitleMatchMode 2
DetectHiddenWindows On
mouse_disabled := True
Clipboard = 
retry_flag := True
RETRY_MESSAGE:
If WinExist("Get Process List ahk_class AutoHotkeyGUI")
{
    ; request all process info be saved to the clipboard
    PostMessage, 0x5550, 0, 0
    ClipWait, 2
}
Else
{
    OutputDebug % "Error: Get Process List / Message Receiver Window - NOT FOUND - " A_ScriptName
    If Not retry_flag
        ExitApp
    Else
    {
        Run, C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\lib\Get Process List.ahk
        Sleep 1000
        retry_flag := False
        Goto RETRY_MESSAGE
    }
}

; parse string info into array for easier handling
proc_string := ClipBoard
proc_list := []
Loop, Parse, proc_string, `n
{
    pd := StrSplit(A_LoopField, Chr(7))
    proc_list.Push({"Name": pd[1], "Params": pd[2], "Exe": pd[3], "PID": pd[4]})
}

; filter proc_list for Autohotkey programs
lv_width := 700
Gui, Font, s14, Consolas

Gui, Add, ListView,Checked Sort r15 w%lv_width% vMyListView gMyListView
    , Select AutoHotkey Programs To Kill or Edit: |PID|Full Path
LV_ModifyCol(1, lv_width)    ; ahk script names size that they are the only visible field
LV_ModifyCol(2, 100)         ; PIDs
LV_ModifyCol(3, 50)          ; Script fullpath
Gui, Add, Button, w100 xm, &Kill
Gui, Add, Button, wp X+5 gEditScript, &Edit
Gui, Add, Button, wp X+5 gRefresh, &Refresh
Gui, Add, Button, wp X+5 gClearSelection, &Clear 
Gui, Add, Button, wp X+5 Default, E&xit
Gui, Font, s9, Consolas
Gui, Add, Button, wp X+50 vDisableMouse gDisableMouse, Disable`n&Mouse 
Gui, Font, s14, Consolas

autohotkey_list := []
For i, pinfo in proc_list
{
    If InStr(pinfo["Exe"], "autohotkey")
    {
        script_fullpath := RegExReplace(pinfo["Params"],"i).*(\b[a-z]:.*\.ahk\b).*","$1")
        script_name := A_Space . RegExReplace(script_fullpath,"i).*[a-z]:([\\|\w|\s])+\\(.*\.ahk).*","$2")
        LV_ADD("", script_name, pinfo["PID"], script_fullpath)
    }
}

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
If LV_GetCount()
{
    GuiControl, Focus, MyListView   
    LV_Modify(1, "+Select") 
}

; create context menu
Menu, context_menu, Add, &Kill, MENU_HANDLER
Menu, context_menu, Add, &Edit, MENU_HANDLER
Menu, context_menu, Add, &Refresh, MENU_HANDLER
Menu, context_menu, Add, &Clear, MENU_HANDLER
Menu, context_menu, Add, E&xit, MENU_HANDLER
Menu, context_menu, Add, &Mouse, MENU_HANDLER

; Gui -MaximizeBox    ; -Sysmenu ; +ToolWindow 
Gui, Show,, Kill / Edit AutoHotkey Programs

Return

;---------------------------------------------------------------------------------------------

GuiContextMenu:
MENU_HANDLER:
    OutputDebug, % "A_ThisMenuItem: " A_ThisMenuItem
    If InStr(A_ThisMenuItem,"Kill")
        Goto BUTTONKILL
    Else If InStr(A_ThisMenuItem,"Edit")
        Goto EDITSCRIPT         
    Else If InStr(A_ThisMenuItem,"Refresh")
        Goto REFRESH            
    Else If InStr(A_ThisMenuItem,"Clear")
        Goto CLEARSELECTION
    Else If InStr(A_ThisMenuItem,"Exit")
        Goto BUTTONEXIT
    Else If InStr(A_ThisMenuItem,"Mouse")
        Goto DISABLEMOUSE
    Else
        OutputDebug, % "Unexepected menu item: " A_ThisMenuItem
    Return

MYLISTVIEW:
    OutputDebug, % "A_ThisFunc: " A_ThisFunc
    Return

EDITSCRIPT:
    row_num = 0  
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked")
        If (row_num = 0) 
            Break   ; no more checked rows
        LV_GetText(script_fullpath, row_num, 3)
        Run "C:\Program Files (x86)\Notepad++\notepad++.exe" "%script_fullpath%"
    }
    Return

CLEARSELECTION:
    LV_Modify(0, "-Check")
    Return

REFRESH:
    Reload
    Return

BUTTONKILL:
    processes_killed := False
    row_num = 0  
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked") 
        If not row_num  
            Break   ; The above returned zero, so there are no more selected rows.

        LV_GetText(ahk_prog, row_num, 1)
        LV_GetText(ahk_proc, row_num, 2)
        Process, Close, %ahk_proc%
        processes_killed := (ErrorLevel != 0)
    }
 
   If Instr(ahk_prog, "Get Process List.ahk") 
        MsgBox, 48,, % "Won't refresh list of processes because that would restart " ahk_prog
    Else If processes_killed
        Goto REFRESH
    Return   

DISABLEMOUSE:
    ; Useful for disabling a mouse that is caught in some 
    ; loop so that its program can be killed via keyboard.
    mouse_disabled := !mouse_disabled
    If mouse_disabled
    {
        Run, "%A_ProgramFiles%\devcon.exe" Enable *mouse*
        ; GuiControl,,Button6, Disable`n&Mouse
        GuiControl,,DisableMouse, Disable`n&Mouse
    }
    Else
    {
        Run, "%A_ProgramFiles%\devcon.exe" Disable *mouse*
        GuiControl,,DisableMouse, Enable`n&Mouse
    }
    ; Highlight currently focused row in Listview
    GuiControl, Focus, MyListView   
    row_num := LV_GetNext(0,"Focused")
    row_num := (row_num = 0) ? 1 : row_num
    LV_Modify(row_num, "+Select") 
    Return

ButtonExit:
GuiEscape:
GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
    Run, "%A_ProgramFiles%\devcon.exe" Enable *mouse*
    DetectHiddenWindows Off  
    ExitApp
;-------------------------------------------------

#If WinActive("Kill / Edit AutoHotkey Programs") and Not WinExist("ahk_class #32768 ahk_exe AutoHotkey.exe")

Enter::Return   ; disable enter key preventing it to "default" and press Cancel button.

RButton::
AppsKey:: 
    Menu, context_menu, Show
    Return 
