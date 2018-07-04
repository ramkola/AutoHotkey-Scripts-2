#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

key_stats:=[]
sum_by_key := []

in_file := "Misc\Monitor Keyboard Hotkeys.txt"
FileRead, in_file_var, %in_file%
countx := 0

; create raw table of collected stats
Loop, Parse, in_file_var, `n, `r
{
    If InStr(A_LoopField, "Monitor Keyboard Hotkeys.ahk - ")
        Continue    ; header
 
    x := StrSplit(A_LoopField, "  ")
    key_stats.push([x[1], x[2]])
    countx++
}

; accumulate
For i, j in key_stats
{
    key := j[1]
    value := j[2]
    ; OutputDebug, % key " = " value
    index_num := look_up(key, sum_by_key) 
    If index_num
    {
        sum_by_key[index_num][2] += value
        ; OutputDebug, % "Cumulating Total: " sum_by_key[index_num][1] " = " sum_by_key[index_num][2]
    }
    Else
    {
        sum_by_key.push([key,value])
        ; OutputDebug, % "Adding new key"
    }
}

write_string := ""
For i, j in sum_by_key
{
    OutputDebug, % Format("{:03})     ", i) j[1] " = " j[2]
    write_string .= j[1] " = " j[2] "`n"
}


out_file := AHK_MY_ROOT_DIR "\Misc\" SubStr(A_ScriptName, 1, -4) ".txt" 
FileDelete, %out_file% 
FileAppend, %write_string%, %out_file% 
SendInput !fo 
Sleep 300 
SendInput %out_file%{Enter}

ExitApp

look_up(p_key, p_array)
{
    result := 0
    For i, kv_pair in p_array
    {
        If kv_pair[1] = p_key
        {
            result := i
            Break
        }
    }
    
    Return %result%
}

^p::Pause
^x::ExitApp

