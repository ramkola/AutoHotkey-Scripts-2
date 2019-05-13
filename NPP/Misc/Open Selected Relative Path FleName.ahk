#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\npp.ahk
#Include lib\constants.ahk

SetWorkingDir, %AHK_ROOT_DIR%
Clipboard := ""

line_text := copy_selection(True)
If (line_text == "")
    Return

SplitPath, line_text, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
; MsgBox, % "OutFileName: " OutFileName "`r`nOutDir: " OutDir  "`r`nOutExtension: " OutExtension  "`r`nOutNameNoExt: " OutNameNoExt  "`r`nOutDrive: " OutDrive  
If (OutDrive = "")
    fullpath := A_WorkingDir "\" line_text
Else
    fullpath := line_text

result := FileExist(fullpath)
If (result == "")
{
    MsgBox, 48,, % "Can't find file: `r`n" line_text
    WinMenuSelectItem, A,, File, Open
    Goto OPEN_SELECTED_EXIT
}
npp_open_file(fullpath)

OPEN_SELECTED_EXIT:
Clipboard := saved_clipboard
ExitApp 