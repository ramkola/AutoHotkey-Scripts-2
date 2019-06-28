#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#NoTrayIcon
nircmd_help_wintitle = NirCmd ahk_class HH Parent ahk_exe hh.exe
If Not WinExist(nircmd_help_wintitle)
{
    Run, "C:\Program Files\Nirsoft\NirCmd.chm"
    WinWaitActive, %nircmd_help_wintitle%,,1
    WinMaximize, %nircmd_help_wintitle%
    SendInput ^{WheelUp 10}  ; increase font size
    ; SendInput {Down}{Enter}  ; open command reference treeview
    ; MouseMove, A_ScreenWidth/2, A_ScreenHeight/2
    ; Click   ; Setfocus on command reference text pane
}

nir_cmd = infobox "This is the first line~n~qThis is a second line, in quotes~q" "Example" 
Run, "C:\Program Files\Nirsoft\nircmd.exe" %nir_cmd%
ExitApp
