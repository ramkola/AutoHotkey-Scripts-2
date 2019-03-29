#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\utils.ahk
SetWorkingDir %AHK_ROOT_DIR%
SetTitleMatchMode 2
Menu, Tray, Icon, ..\resources\32x32\Misc\Bloody Hatchet.png

process_name := (A_Args[1] == "") ? "AutoHotkey" : A_Args[1] 

; create context menu
Menu, context_menu, Add, C&opy, MENU_HANDLER
Menu, context_menu, Add, &Details, MENU_HANDLER
Menu, context_menu, Add,
Menu, context_menu, Add, &Kill, MENU_HANDLER
Menu, context_menu, Add,
Menu, context_menu, Add, &Edit, MENU_HANDLER
Menu, context_menu, Add, &Refresh, MENU_HANDLER
Menu, context_menu, Add, &Clear All, MENU_HANDLER
Menu, context_menu, Add,
Menu, context_menu, Add, &Mouse, MENU_HANDLER
Menu, context_menu, Add, E&xit, MENU_HANDLER
Menu, context_menu, Add,
Menu, context_menu, Add,
Menu, context_menu, Add, Clear DbgView, MENU_HANDLER

; create gui
lv_width := 700
Gui, Font, s14, Consolas
Gui, Add, ListView
    , r15 w%lv_width% vlv_scripts glv_scripts Backgroundfeffcd +Multi AltSubmit Checked Sort +ReadOnly 
    , Select %process_name% Programs To Kill or Edit: |PID|Full Path
LV_ModifyCol(1, lv_width)    ; ahk script names - sized so that they are the only visible field
LV_ModifyCol(2, 100)         ; PIDs
LV_ModifyCol(3, 50)          ; Script fullpath
Gui, Add, Button, w100 xm, &Kill
Gui, Add, Button, wp X+5 vEditScript gEditScript, &Edit
Gui, Add, Button, wp X+5 gRefresh, &Refresh
Gui, Add, Button, wp X+5 gClearSelection, &Clear All
Gui, Add, Button, wp X+5 Default, E&xit
Gui, Font, s9, Consolas
Gui, Add, Button, wp X+50 vDisableMouse gDisableMouse, Disable`n&Mouse 
Gui, Font, s14, Consolas
; gather process info to populate listview
; filter proc_list for process_name programs
proc_list := {}
result := find_process(proc_list, process_name)
For key, pinfo in proc_list
{
    If InStr(pinfo["Exe"], process_name)
    {
        If Not InStr(process_name, "AutoHotkey")
        {
            script_fullpath := pinfo["Exe"]
            script_name := (pinfo["Params"] == "") ? pinfo["Name"] : pinfo["Params"]
        }
        Else
        {
            script_fullpath := RegExReplace(pinfo["Params"],"i).*(\b[a-z]:.*\.ahk\b).*","$1")
            script_name := A_Space . RegExReplace(script_fullpath,"i).*[a-z]:([\\|\w|\s])+\\(.*\.ahk).*","$2")
        }
        LV_ADD("", script_name, pinfo["PID"], script_fullpath)   
    }
}
; Focus on first script in list
If LV_GetCount()
{
    GuiControl, Focus, lv_scripts   
    LV_Modify(1, "+Focus +Select") 
}
;
menu_wintitle = ahk_class #32768 ahk_exe AutoHotkey.exe
If Instr(process_name, "AutoHotkey")
    main_wintitle = Kill / Edit %process_name% Programs
Else
{
    Menu, context_menu, Disable, &Edit
    GuiControl, Disable, EditScript
    main_wintitle = Kill %process_name% Programs
}
#If WinActive(main_wintitle) and Not WinExist(menu_wintitle)
refresh_tray()  ; removes dead icons from systray when this script reloads/refreshes
mouse_disabled := True      ; toggles disabling mouse with devcon.exe

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
Gui +AlwaysOnTop
Gui, Show,, %main_wintitle%
Return

;---------------------------------------------------------------------------------------------
listview_row_info(p_info_type)
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
    If (p_info_type = "Copy")
    {   
        Clipboard := script_info
        MouseGetPos, x, y
        ttip("Copied to Clipboard: `r`n----------------------`r`n`r`n" script_info "`r`n "
            , 2000, x+20, y+20)
    }
    Else If (p_info_type = "Details")
        display_text(script_info)
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
        listview_row_info("Copy")
    Else If InStr(A_ThisMenuItem,"&Details")
        listview_row_info("Details")
    Else If InStr(A_ThisMenuItem,"Clear DbgView")
        OutputDebug, DBGVIEWCLEAR
    Else
        OutputDebug, % "Unexepected menu item: " A_ThisMenuItem " - A_ThisLabel: " A_ThisLabel " - A_ScriptName: " A_ScriptName 
    Return

LV_SCRIPTS:
    If (A_GuiEvent = "DoubleClick")
    {
        row_num :=  A_EventInfo
        If row_num > 0
        {
            checkmark := (row_num == LV_GetNext(row_num - 1, "Checked")) ? "-Check" : "+Check"
            LV_Modify(row_num, checkmark)
        }
    }
    Else If (A_GuiEvent = "Normal")     ; Leftclick
        1=1
    Else If (A_GuiEvent = "RightClick") Or (A_GuiEvent == "R")
        Goto RButton
    Else If (A_GuiEvent == "K")     ; Keypress
    {
        key := GetKeyName(Format("vk{:x}", A_EventInfo))
        ; OutputDebug, % "key: " key  " - A_GuiEvent: " A_GuiEvent " - A_ThisLabel: " A_ThisLabel " - A_ScriptName: " A_ScriptName 
    }
    Else If (A_GuiEvent = "I")  ; Item changed: A row has changed by becoming selected/deselected, checked/unchecked, etc  of state
    {
        current_row_num := LV_GetNext(0, "Focused")
    }
    Else If A_GuiEvent In A,C,D,d,E,F,f,M,S,s
        1=1 ; ignore these events
    Else
        OutputDebug, % "Unexpected Gui Event: " A_GuiEvent " - A_ThisLabel: " A_ThisLabel " - A_ScriptName: " A_ScriptName 
    Return

EDITSCRIPT:
    row_num = 0  
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked")
        If (row_num = 0) 
        {
            ; if no line is checked then edit the file on the line that has focus.
            row_num := LV_GetNext(row_num, "Focused")
            LV_Modify(row_num, "-Select -Focus")
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
            MsgBox, 48,, % "Suicide not allowed!`r`nSkipping: " A_ScriptName, 10
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
    ; Needs admin priveleges to work
    ; Useful for disabling a mouse that is caught in some 
    ; loop so that its program can be killed via keyboard.
    mouse_disabled := !mouse_disabled
    If mouse_disabled
    {
        Run *RunAs "%A_ProgramFiles%\devcon.exe" Enable *mouse*
        GuiControl,,DisableMouse, Disable`n&Mouse
    }
    Else
    {
        Run *RunAs "%A_ProgramFiles%\devcon.exe" Disable *mouse*
        GuiControl,,DisableMouse, Enable`n&Mouse
    }
    ; Highlight currently focused row in Listview
    GuiControl, Focus, lv_scripts
    row_num := LV_GetNext(0,"Focused")
    row_num := (row_num = 0) ? 1 : row_num
    LV_Modify(row_num, "+Select") 
    Return

ButtonExit:
GuiEscape:
GuiClose:  
    OutputDebug, % "A_ThisHotkey: " A_ThisHotkey " - A_ThisLabel: " A_ThisLabel " - A_ScriptName: " A_ScriptName 
    ; Run *RunAs "%A_ProgramFiles%\devcon.exe" Enable *mouse*
    DetectHiddenWindows Off  
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    ExitApp
;-------------------------------------------------

+Enter::
Enter::
+Space::
Space::    ; Change all << selected >> rows to the check/unchecked state 
    ; of the currently << focused >>  row
    save_selected_row_nums := []
    row_num := LV_GetNext(0, "Focused")
    if (row_num = 0)
    {
        MsgBox, 48, Unexepected Error, % "No Row With Focus Found."
        Return
    }
    save_focused_row := row_num
    found_row := LV_GetNext(row_num - 1, "Checked")     ; look for any row
    checkmark := (row_num == found_row) ? "-Check" : "+Check"       ;
    row_num := 0
    Loop
    {
        row_num := LV_GetNext(row_num)  ; find next selected row
        If (row_num = 0)
            Break
        LV_Modify(row_num, checkmark " -Select")     ; checkmark and deselect row so they
        save_selected_row_nums.push(row_num)
    }
    for i_index, row_num in save_selected_row_nums
        LV_Modify(row_num, "+Select")       ; reselect rows
    LV_Modify(save_focused_row, "+Focus")   ; refocus row
    Return

WheelUp::   ; Scroll single row focus towards top of list
WheelDown:: ; Scroll single row focus towards bottom of list
    max_rows := LV_GetCount()
    row_num := LV_GetNext(0,"Focused")
    If (A_ThisHotkey = "WheelUp") 
        row_num := row_num - 1 
    Else
        row_num := row_num + 1
    row_num := (row_num = 0) ? 1 : row_num
    row_num := (row_num > max_rows) ? max_rows : row_num
    LV_Modify(0, "-Focus -Select")
    LV_Modify(row_num, "+Focus +Select")
    Return

RButton:: ; show context menu
AppsKey:: ; show context menu
    Menu, context_menu, Show
    Return 

^+k:: list_hotkeys()
