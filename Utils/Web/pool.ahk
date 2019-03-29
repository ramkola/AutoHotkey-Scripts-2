#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\constants.ahk
SetWorkingDir %AHK_ROOT_DIR%

Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\resources\32x32\Singles\GamesLol.net.png
Menu, Tray, Add, Start Pool, START_POOL
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; see lib\utils.ahk
SetTitleMatchMode RegEx

Run,  MyScripts\Utils\Web\Youtube Keys.ahk

elements_erased := True
pool_wintitle = Billiards Master Pro - Play Free Online Games - Google Chrome
#If WinActive(pool_wintitle)
SetTimer, EXIT_APP, 5000
Goto START_POOL
Return

s::    ; play again
    If elements_erased
        Click 930, 370
    Else
        Click 930, 325
    save_window()
    Return

Space::
r::    ; restart game 
    If elements_erased
        Click 630, 205
    Else
        Click 610, 155
    If elements_erased
        Click 930, 340
    Else
        Click 930, 295
    save_window()
    Return

save_window()
{
    WinGetPos, x, y, w, h, A
    OutputDebug, % x "," y "," w "," h
    ; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    Return
}

START_POOL:
    OutputDebug, % "here"
    If Not WinExist(pool_wintitle)
    {
        Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
        WinWaitActive, Google - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe,,5
        Run, http://en.gameslol.net/billiards-master-pro-15.html
    }
    WinActivate, ^.*YouTube - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    WinActivate, %pool_wintitle%
    Return

EXIT_APP:
    If WinExist(pool_wintitle)
        Return
    Else
        ExitApp
