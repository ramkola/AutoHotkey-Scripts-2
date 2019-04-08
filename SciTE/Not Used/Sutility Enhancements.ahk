#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
scriptlet_wintitle = Scriptlet Utility ahk_class AutoHotkeyGUI ahk_exe InternalAHK.exe
#If WinActive(scriptlet_wintitle)
Return

Enter::
	ControlGetFocus, got_focus, A
	If (got_focus <> "ListBox1") or not WinActive(scriptlet_wintitle)
	{
		SendInput {Enter}
		Return
	}
	ControlGet, scriptlet_name, Choice,, ListBox1, A 
    If (scriptlet_name <> "")
    {
        ControlGetPos, x, y, w, h, Button5, A 
        x += 50
        y += 10
        Click, %x%, %y%
    }
    Return

#If WinExist(scriptlet_wintitle)
^+3:: WinActivate, %scriptlet_wintitle%


