;
; 1) Open kodi to the season of episodes you want to mark as watched/unwatched
; 2) Ensure Kodi/Options/Viewtype is Wall.
; 3) Ensure that the proper filter is set in Kodi/Options/View Options ... Watched or Unwatched 
;   ie: 
;   If marking the episodes as watched the filter needs to be Unwatched (the usual scenario)
;   If marking the episodes as Unwatched the filter needs to be watched
;   (The episode needs to disappear from the list after being marked)
#SingleInstance Force 
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
g_TRAY_EXIT_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
#If WinExist("Kodi ahk_class Kodi ahk_exe kodi.exe")
sleep_time := 2000     ; millisecs to wait for servers to update. If servers are slow this time may have to be increased, if they are fast decreased.
;
num := 0
While (num < 1)
{
    InputBox, num, Kodi - Mark As Watched,`n1) Open kodi to the season of episodes you want to mark as      watched or unwatched.`n`n2) Enter number of episodes:
    if ErrorLevel = 1
        Goto KODI_EXIT ; cancel was pressed
}
BlockInput, On
MsgBox, 64,BlockInput On, ALL INPUT IS BEING BLOCKED UNTIL PROGRAM ENDS`t, 2
WinActivate, Kodi ahk_class Kodi ahk_exe kodi.exe
WinWaitActive, Kodi ahk_class Kodi ahk_exe kodi.exe,,2
Sleep 100
SendInput {Home}
Sleep 100
Loop, %num%
{
    SendInput {Home}{Right}w
    Sleep %sleep_time%
}
   
KODI_EXIT:
BlockInput Off
MsgBox, 64,, "Done"`t
; WinActivate, ahk_class Notepad++
WinActivate, Kodi ahk_class Kodi ahk_exe kodi.exe
Return

!r::Reload   
^p::Pause
^x::ExitApp
