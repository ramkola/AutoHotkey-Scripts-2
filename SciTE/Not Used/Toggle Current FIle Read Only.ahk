#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\scite.ahk
#Include lib\utils.ahk

OutputDebug, DBGVIEWCLEAR
if toggle_file_read_only(True)
	MsgBox, 48,, % "Success", 1
else
	MsgBox, 48,, % "Fail", 1
ExitApp

toggle_file_read_only(p_desired_state)
{
	oscite := create_scite_comobj()
	If (oscite = 0)
		Return False
	;
	cur_state_not_found := False
	replaced_count := 0
	cur_filename := oscite.CurrentFile
	myproperties_file := oscite.UserDir() "\myproperties.txt" 
	FileRead, org_myproperties_text, %myproperties_file%
	;
	; get current readonly state of active file
	cur_state := get_current_state(org_myproperties_text, cur_filename)
	If (cur_state == "Not Found")
	{
		cur_state := oscite.ResolveProp("read.only") 		; assumption
		cur_state_not_found := True
	}
	new_state := (cur_state = p_desired_state) ? cur_state : !cur_state
	new_myproperties_text := set_new_state(org_myproperties_text, new_state, cur_filename, cur_state_not_found)
	;
	; Close current_filename 
	WinMenuSelectItem,A,,File,Close 
	While WinExist("SciTE4AutoHotkey ahk_class #32770 ahk_exe SciTE.exe")
		Sleep 500	; wait for user to answer prompt whether file should be saved or not
	;
	; set new read_only_state
	FileDelete, %myproperties_file%
	FileAppend, %new_myproperties_text%, %myproperties_file% 
	oscite.ReloadProps()	; current file in SciTE should now be read only
	;
	; reopen the file with the new read_only_state active
	oscite.OpenFile(current_filename)
	; restore read.only to original state
	FileDelete, %myproperties_file%
	FileAppend, %org_myproperties_text%, %myproperties_file% 
	oscite.ReloadProps()	; current file in SciTE remains read only but other files remain same
	read_only_state := oscite.ResolveProp("read.only") 
	Return read_only_state = org_state
	




	WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
	Return result
}

set_new_state(p_myproperties_text, p_state, p_filename, p_state_not_found)
{
	new_state_string := get_state_search_string(p_filename) p_state
	If p_state_not_found
	
	new_text := StrReplace(p_myproperties_text, 
	{
		new_text := p_myproperties_text "`r`n" new_state_string
		Goto RETURN_NEW_TEXT
	}
	
RETURN_NEW_TEXT:
	Return new_text
}

get_current_state(p_myproperties_text, p_filename)
{
	state_search := get_state_search_string(p_filename)
	cur_state := "Not Found"
	Loop, Parse, p_myproperties_text, `n, `r
	{
		If InStr(A_LoopField, state_search)
		{
			cur_state := SubStr(A_LoopField, 0)
			Break
		}
	}
	Return cur_state
}

get_state_search_string(p_filename)
{
	; note: need to check/edit existing entries in myproperties.properties 
	;       file if I change this string in any way.
	Return "#READONLY# " p_filename " READONLY=" 
}