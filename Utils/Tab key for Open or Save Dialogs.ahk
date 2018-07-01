#NoTrayIcon
#SingleInstance Force 
SetTitleMatchMode RegEx

#If WinActive("^[Open|Save].*")  ;ahk_class #32770 ahk_exe notepad++.exe")
               
Tab::   ; Switches focus between the filename textbox and the file treeview only in Open/Save dialogs.
        ; Forces tab to go directly where I want it to go instead of scrolling through all the buttons and controls.
    ControlGetFocus, got_focus, A
    if (got_focus == "SysListView321") or (got_focus == "DirectUIHWND2")
        ControlFocus, Edit1, A
    else
    {
        ControlFocus, DirectUIHWND2, A
        ControlFocus, SysListView321, A
    }