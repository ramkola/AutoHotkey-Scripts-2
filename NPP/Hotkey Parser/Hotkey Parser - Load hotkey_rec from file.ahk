#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\objects.ahk

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

in_file := "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\zzzzzhotkey_rec.dat"

hotkey_file := []
hotkey_rec := {}
FileRead in_file_var, %in_file%
Loop, Parse, in_file_var, `n, `r
{   

    ; blank copy of def_hotkey_rec defined in lib\objects.ahk
    hotkey_rec := def_hotkey_rec.clone()
    array := StrSplit(A_LoopField, ",")
    for i, j in array
    {
        key := RegExReplace(j, "[?<=:].*")
        value := RegExReplace(j, ".*[?=:]")
        hotkey_rec[key] := value
    }

    hotkey_file.push(hotkey_rec)
}

for i_index, hk_rec in hotkey_file
{
    OutputDebug, ------------------------------
    For key, value in hk_rec {
        OutputDebug, %key%:%value%
    }
}

Return
