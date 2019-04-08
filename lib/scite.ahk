#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk

;==========================================================

move_variable_list()
{
	countx := 0 
	While !WinExist("Variable list") and countx < 10
	{
		Click 535, 63		; activate variable list
		Sleep 200
		countx++
	}
	If !WinExist("Variable list")
	{
		MsgBox, 48, Unexpected Error, % A_ThisFunc " - " A_ScriptName "`r`nCould not open Variable List"
		Return False
	}
	WinMove,,, 840, 0, 450, 995
	WinActivate
	SendInput ^NumpadAdd	; auto configure column widths
	Sleep 200
	SendEvent {Click 324, 50, Down}{click 446, 50, Up}
	WinActivate, ahk_class SciTEWindow ahk_exe SciTE.exe
	MouseMove, 500, 500
	Return True
}
;-----------------------------------------------------------------------------
;	create_scite_comobj()	
;
;-----------------------------------------------------------------------------
create_scite_comobj()
{
	Loop
	{
		err_msg := ""
		If !WinExist("ahk_class SciTEWindow ahk_exe SciTE.exe")
		{
			Run, C:\Program Files\AutoHotkey\SciTE\SciTE.exe
			WinWait,,2
			Sleep 2000
			If ErrorLevel
			{
				err_msg := "Can't start SciTE4AHK"
				Break
			}
		}
		Try
		{
			oSciTE := ComObjActive("SciTE4AHK.Application")
			Break
		}
		Catch e
		{
			If Instr(e.message, "0x800401E3")
			{
				MsgBox, 48,% A_ThisFunc "-" A_ScriptName, % e.message "`r`n`r`n*** RETRYING ***"
				If WinExist("ahk_class SciTEWindow ahk_exe SciTE.exe")
				{
					WinClose
					Sleep 500
				}
			}
			Else
			{
				OutputDebug, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
					. "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
				OutputDebug, % "ErrorLevel: " ErrorLevel " - A_LastError: " A_LastError
				err_msg := "Can't create COMOBJ: " e.message "`r`nUnexpected error in " A_ThisFunc " - " A_ScriptName "`r`nCheck DbgView" 
ttip("`r`nerr_msg: " err_msg " `r`n ")
				Break
			}
		}
	}
	
	If err_msg
	{
		MsgBox, 48,, % err_msg
		Return False
	}
	Else 
		Return IsObject(oSciTE) ? oSciTE : False
}
