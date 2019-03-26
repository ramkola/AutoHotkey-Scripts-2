#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\processes.ahk
#Include lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
SetTitleMatchMode 2
Menu, Tray, Icon, ..\resources\32x32\Misc\Bloody Hatchet.png
#If WinActive("Kill / Edit AutoHotkey Programs") and Not WinExist("ahk_class #32768 ahk_exe AutoHotkey.exe")

OutputDebug, DBGVIEWCLEAR

; removes dead icons from systray when this script reloads/refreshes
refresh_tray()  

lv_width := 700
Gui, Font, s14, Consolas
Gui, Add, ListView, +ReadOnly +Multi AltSubmit Checked Sort r15 w%lv_width% vMyListView gMyListView
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

; parse string info into array for easier handling
proc_list := {}
result := find_process(proc_list, "AutoHotkey")
; filter proc_list for Autohotkey programs
autohotkey_list := []
For key, pinfo in proc_list
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
    LV_Modify(1, "+Focus") 
    LV_Modify(1, "+Select") 
}

; create context menu
Menu, context_menu, Add, C&opy, MENU_HANDLER
Menu, context_menu, Add,
Menu, context_menu, Add, &Kill, MENU_HANDLER
Menu, context_menu, Add,
Menu, context_menu, Add, &Edit, MENU_HANDLER
Menu, context_menu, Add, &Refresh, MENU_HANDLER
Menu, context_menu, Add, &Clear, MENU_HANDLER
Menu, context_menu, Add,
Menu, context_menu, Add, &Mouse, MENU_HANDLER
Menu, context_menu, Add, E&xit, MENU_HANDLER
Menu, context_menu, Add,
Menu, context_menu, Add,
Menu, context_menu, Add, Clear DbgView, MENU_HANDLER

; Gui -MaximizeBox    ; -Sysmenu ; +ToolWindow 
Gui, Show,, Kill / Edit AutoHotkey Programs

Return

;---------------------------------------------------------------------------------------------
listview_copy_info()
{
    ; copy current row info to clipboard
    row_num := LV_GetNext(row_num, "Focused")
    If row_num
    {
        LV_GetText(script_name, row_num, 1)
        LV_GetText(script_pid,  row_num, 2)
        LV_GetText(script_path, row_num, 3)
    }
    script_info := trim(script_name) "`r`n" script_pid "`r`n" script_path
    Clipboard := script_info
    MouseGetPos, x, y
    ttip("Copied to Clipboard: `r`n----------------------`r`n`r`n" script_info "`r`n "
        , 2000, x+20, y+20)
    Return
}
;---------------------------------------------------------------------------------------------

GuiContextMenu:
MENU_HANDLER:
    ; OutputDebug, % "A_ThisMenuItem: " A_ThisMenuItem
    If InStr(A_ThisMenuItem,"Kill")
        Goto BUTTONKILL
    Else If InStr(A_ThisMenuItem,"&Edit")
        Goto EDITSCRIPT         
    Else If InStr(A_ThisMenuItem,"&Refresh")
        Goto REFRESH            
    Else If InStr(A_ThisMenuItem,"&Clear")
        Goto CLEARSELECTION
    Else If InStr(A_ThisMenuItem,"E&xit")
        Goto BUTTONEXIT
    Else If InStr(A_ThisMenuItem,"&Mouse")
        Goto DISABLEMOUSE
    Else If InStr(A_ThisMenuItem,"C&opy")
        listview_copy_info()
    Else If InStr(A_ThisMenuItem,"Clear DbgView")
        OutputDebug, DBGVIEWCLEAR
    Else
        OutputDebug, % "Unexepected menu item: " A_ThisMenuItem
    Return

MYLISTVIEW:
    If A_GuiEvent in Normal,DoubleClick,A
    {
        row_num := A_EventInfo
        checkmark := (row_num == LV_GetNext(row_num - 1, "Checked")) ? "-Check" : "+Check"
        LV_Modify(row_num, checkmark)
    }
    Else If A_GuiEvent In I,C,f,K
        1=1
    Else If (A_GuiEvent = "RightClick")
        Goto RButton
    Else
        OutputDebug, % "A_GuiEvent: " A_GuiEvent " - A_ThisLabel: " A_ThisLabel " - A_ScriptName: " A_ScriptName 
        
    Return

EDITSCRIPT:
    row_num = 0  
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked")
        If (row_num = 0) 
        {
            row_num := LV_GetNext(row_num, "Focused")
            LV_Modify(row_num, "-Focus")
            LV_Modify(row_num, "-Select")
            If (row_num = 0) 
                Break   ; no row is checked or has focus
        }
        LV_GetText(script_fullpath, row_num, 3)
        Run "C:\Program Files (x86)\Notepad++\notepad++.exe" "%script_fullpath%"
    }
    Goto ButtonExit
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
        If InStr(ahk_prog, A_ScriptName)
            msgbox, % "Suicide not allowed!`r`nSkipping: " A_ScriptName
        Else
        {
            Process, Close, %ahk_proc%
            processes_killed := (ErrorLevel != 0)
        }
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

Escape::
ButtonExit:
GuiEscape:
GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
    Run, "%A_ProgramFiles%\devcon.exe" Enable *mouse*
    DetectHiddenWindows Off  
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    ExitApp
;-------------------------------------------------


; #If WinActive("Kill / Edit AutoHotkey Programs") and Not WinExist("ahk_class #32768 ahk_exe AutoHotkey.exe")
; Enter::Return   ; disable enter key preventing it to "default" and press Cancel button.

RButton::
AppsKey:: 
    Menu, context_menu, Show
    Return 

ExitApp 