#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\scite.ahk

script_fullpath := get_filepath_from_wintitle()
oscite := create_scite_comobj()
If (oscite = False)
	Return

oscite.Message(0x111,1110)  ; open containing folder

ExitApp