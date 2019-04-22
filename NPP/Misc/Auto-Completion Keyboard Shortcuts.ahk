#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%
Run, MyScripts\NPP\Misc\Toggle Preferences Setting.ahk Off "Enable auto-completion on each input" False False 
SetWorkingDir, C:\Users\Mark\Desktop\Misc\resources\Images\Notepad++
SplashImage, Auto-Completion Keyboard Shortcuts.png, B y0 FM16 FS10 CTRed,, Auto-completion is OFF
           ,, Lucida Console
Sleep 7000
ExitApp

Escape:: ExitApp