;
; 1) Open kodi to the season of episodes you want to mark as watched
;
#SingleInstance Force 
#If WinExist("Kodi ahk_class Kodi ahk_exe kodi.exe")
;***********************************************************
;***********************************************************
;****** Verify the number of times you have to press *******
;****** the down key to get to the Mark As Watched   *******
;****** option. It can vary between shows and if the *******
;****** menu has changed since the last time run     *******
;***********************************************************
;***********************************************************
;***********************************************************
down_num := 4  
sleep_time := 4000     ; millisecs to wait for servers to update. If servers are slow this time may have to be increased, if they are fast decreased.
;
num := 32
While (num < 1)
{
    inputbox, num, Kodi - Mark As Watched,`n1) Open kodi to the season of episodes you want to mark as      watched.`n`n2) Enter number of seasons:
    if ErrorLevel = 1
        ExitApp ; cancel was pressed
}

Sleep 1000 ; time to take hands off mouse and keyboard
BlockInput, On
MsgBox, 64,BlockInput On, ALL INPUT IS BEING BLOCKED UNTIL PROGRAM ENDS`t, 5
WinActivate, Kodi ahk_class Kodi ahk_exe kodi.exe
WinWaitActive, Kodi ahk_class Kodi ahk_exe kodi.exe,,5
Sleep 100
SendInput {Home}
Sleep 100
Loop, %num%
{
   SendInput {Right}{AppsKey}
   Sleep 500
   SendInput {Down %down_num%}{Enter} 
   Sleep %sleep_time%
}
   
BlockInput Off
WinActivate, ahk_class Notepad++
MsgBox, 64,, "Done"`t
ExitApp
   
^p::Pause
^x::ExitApp
