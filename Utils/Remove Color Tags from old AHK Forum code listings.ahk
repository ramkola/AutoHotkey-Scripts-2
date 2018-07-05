#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#SingleInstance Force

Msgbox, 64,, Go to the file that has color tags in its code`n`nPress RAlt to execute. 

RAlt::
in_file := get_current_npp_filename()
SplitPath, in_file, fname

FileRead vText, %in_file% 
vText := StrReplace(vText, "[/color]")
vText := RegExReplace(vText, "\[color=.+?]")
OutputDebug, % vText

out_file := AHK_MY_ROOT_DIR "\zzz-" SubStr(fname, 1, -4) ".txt" 
FileDelete, %out_file% 
FileAppend, %vText%, %out_file% 

SendInput !fo 
Sleep 300 
SendInput %out_file%
Sleep 100
SendInput {Enter}


ExitApp