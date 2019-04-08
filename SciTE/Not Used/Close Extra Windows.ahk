#SingleInstance Force	
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#NoTrayIcon
SetTitleMatchMode 2
Return

F12::	; Close all extra windows
{
	scite_dialog_wintitle = ahk_class #32770 ahk_exe SciTE.exe
	internal_ahk_wintitle = ahk_class AutoHotkeyGUI ahk_exe InternalAHK.exe

	WinClose, Find %scite_dialog_wintitle%
	WinClose, Replace %scite_dialog_wintitle%
	WinClose, Find in Files %scite_dialog_wintitle%
	WinClose, Scriptlet Utility %internal_ahk_wintitle%
	WinClose, Stream viewer %internal_ahk_wintitle%
	WinClose, GenDocs %internal_ahk_wintitle%
	WinClose, Active Window Info %internal_ahk_wintitle%
	WinClose, MsgBox Creator 

	; Close output window
	ControlGetPos, x , y, w, h, Scintilla2, A	
	If (h > 0)
		WinMenuSelectItem,A,,View,Output
	
	; close Find / Replace strips
    click_close_buttons := ["SciTEWindowContent5", "SciTEWindowContent6"]
	For i_index, classNN in click_close_buttons
	{
		x:=y:=w:=h:=""
		ControlGetPos, x, y, w, h, %classNN%, A	
		If (h > 1)
		{
			x := w - 2 
			y := y + 5 
			Click, %x%, %y%
		}
	}
	Return
}
