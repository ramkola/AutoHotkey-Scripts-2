;************************************************************************
;
; Hotkeys that are for SciTE4AutoHotkey only 
;
; (mainly used to make SciTe work like Notepad++)
;
;************************************************************************
#If WinActive("ahk_class SciTEWindow ahk_exe SciTE.exe")

#e::    ; open current file's path in explorer
{    
    Run, MyScripts\SciTE\utils\Open Containing Folder.ahk
    Return
}

F7::    ; start debugging with a customized setup   (overrides SciTE's F7 - debug)
^+d::	; start debugging with a customized setup
^!d::   ; customized setup for session that is already in debug mode
{
	WinMenuSelectItem, A,,Tabs,Save All
    If (A_ThisHotkey <> "^!d")
		WinMenuSelectItem, A,, Tools, Debug
	Sleep 200
	move_variable_list()
	Return
}
	
^+/::	; Toggle line comments
^/::	; Toggle line comments
{
	SendInput ^q
	Return
}

^+Up::		; move current line up
^+Down::	; move current line down
{
	direction := SubStr(A_ThisHotkey, 3)
	If (direction = "Up")
		SendInput ^t{Up}
	Else
		SendInput, {Down}^t
	Return
}

; note: ^tab is set internally in SciTE
!Right::	; activate next tab
!Left::		; activate previous tab
{
	If (A_ThisHotkey = "!Left") 
		WinMenuSelectItem, A,,Tabs,Previous
	Else
		WinMenuSelectItem, A,,Tabs,Next
	Return
}

^h::	; Search/Replace	SciTE's original hotkey
^r::	; Search/Replace
{
	WinMenuSelectItem, ahk_class SciTEWindow ahk_exe SciTE.exe,,Search,Replace
	Return
}

^+r::	; Toggle readonly for current file
{
	WinMenuSelectItem, A,,Options,Read-Only
	Return
}

^!r::	; Reloads all SciTE property files
{
	script_fullpath := get_filepath_from_wintitle()
	oscite := create_scite_comobj()
	If (oscite != 0)
	{
		oscite.ReloadProps()
		ttip("`r`nReloaded all SciTE property files`r`n ", 1500)
	}
	Else
		MsgBox, 48,, % "Could not reload SciTE property files"
	Return
}

^!+r::	; shutdown and restart SciTE4AutoHotkey
{
	WinMenuSelectItem, A,,Tabs,Save All
	WinClose, A
	Run, C:\Program Files\AutoHotkey\SciTE\SciTE.exe
	Return
}

^!x::	; cut current line
{
	SendInput ^l
	Return
}

^F9::	 ; Toggle Breakpoint
{
	SetMouseDelay, -1
	MouseGetPos x,y
	Click, Left, 55, %A_CaretY%
	MouseMove, x, y
	Return
}

!n::    ; Open new scratch ahk file
{
    Run, MyScripts\SciTE\lib\Create New AHK Scratch File (scite).ahk
    Return
}

F12::   ; Close Extra Windows
{
    Run, MyScripts\SciTE\Close Extra Windows.ahk
    Return
}

^!w::	; Toggle Wrap
{
	WinMenuSelectItem, A,, Options, Wrap
	Return
}

^!p::    ; toggle show whitespace and eol
{
    WinMenuSelectItem, A,, View, Whitespace
    WinMenuSelectItem, A,, View, End of Line
    Return
}

; ============================================================================

#If WinActive("Scriptlet Utility ahk_class AutoHotkeyGUI ahk_exe InternalAHK.exe")
scriptlet_wintitle = Scriptlet Utility ahk_class AutoHotkeyGUI ahk_exe InternalAHK.exe

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

