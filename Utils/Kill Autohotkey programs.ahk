#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR

; retrieve process info to clipboard
SetTitleMatchMode 2
DetectHiddenWindows On
Clipboard = 
If WinExist("Get Process List ahk_class AutoHotkeyGUI")
{
    ; request all process info be saved to the clipboard
    PostMessage, 0x5550, 0, 0
    ClipWait, 2
}
Else
    OutputDebug % "Error: Get Process List / Message Receiver Window - NOT FOUND."

; parse string info into array for easier handling
proc_string := ClipBoard
proc_list := []
Loop, Parse, proc_string, `n
{
    pd := StrSplit(A_LoopField, Chr(7))
    proc_list.Push({"Name": pd[1], "Params": pd[2], "Exe": pd[3], "PID": pd[4]})
}

; filter proc_list for Autohotkey programs
Gui, Font, s14, Consolas
Gui, Add, ListView,Checked Sort r15 w700 gMyListView, Select AutoHotkey Programs To Kill:|PID
LV_ModifyCol(1, 700)    ; command line params
LV_ModifyCol(2, 0)      ; PID
Gui, Add, Button,, &Kill
Gui, Add, Button, Default, &Cancel
autohotkey_list := []
For i, pinfo in proc_list
{
    If InStr(pinfo["Exe"], "autohotkey")
    {
        params := StrReplace(pinfo["Params"],AHK_ROOT_DIR,"...")
        LV_ADD("",params,pinfo["PID"])
        autohotkey_list.push({"Name": pinfo["Name"], "Params": pinfo["Params"]
                            , "Exe": pinfo["Exe"], "PID": pinfo["PID"]})
    }
}
Gui, Show,, Kill AutoHotkey Programs
DetectHiddenWindows Off  
Return

BUTTONKILL:
    OutputDebug, DBGVIEWCLEAR
    row_num = 0  
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked")  ; Resume the search at the row after that found by the previous iteration.
        if not row_num  ; The above returned zero, so there are no more selected rows.
            break
        LV_GetText(ahk_prog, row_num, 1)
        LV_GetText(ahk_proc, row_num, 2)
        OutputDebug, % ahk_proc " - " ahk_prog 
    }
    Return   

MYLISTVIEW:
    Return

ButtonCancel:
GuiEscape:
GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
    ExitApp