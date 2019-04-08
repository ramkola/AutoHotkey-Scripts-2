create_scite_comobj()
{
	If !WinExist("ahk_class SciTEWindow ahk_exe SciTE.exe")
	{
		Run, C:\Program Files\AutoHotkey\SciTE\SciTE.exe
		WinWait,,2
		Sleep 2000
		If ErrorLevel
		{
			err_msg := "Can't start SciTE4AHK"
			Goto SCITE_COM_EXIT
		}
	}

	Try
		oSciTE := ComObjActive("SciTE4AHK.Application")
	Catch e
	{
		OutputDebug, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
			. "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
		OutputDebug, % "ErrorLevel: " ErrorLevel " - A_LastError: " A_LastError
		err_msg := "Can't create COMOBJ: " e.message 
		Goto SCITE_COM_EXIT
	}

SCITE_COM_EXIT:
	If err_msg
		MsgBox, 48,, % err_msg
	Else 
		Return oSciTE
}