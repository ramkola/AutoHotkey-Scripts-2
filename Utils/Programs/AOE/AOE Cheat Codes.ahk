; AutoHotkey Version: 1.x
; Language:       English
; Platform:       XP
; Author:         CRTL+1
; Age Of Empires 2 Cheat Prep


Gui, Add, Text,, Age Of Empires 2 Cheat Prep script
Gui, Add, Text,, Before running this script:
Gui, Add, Text,, Ensure you have started AOE2--Start your game--Alt-Tab out to this script


Gui, Add, Checkbox, Checked vrec, Boost Resources
Gui, Add, Text,, How many x1000 do you want to boost your resources:
Gui, Add, Edit, vtotal, 5
Gui, Add, Checkbox, Checked vexp, Mini Map Explored
Gui, Add, Checkbox, Checked vvis, Fog of war removed
Gui, Add, Checkbox, vbul, Instant building
Gui, Add, Text,, After you click OK you must return to AOE2 immediately
Gui, Add, Text,, Script will start in 2 seconds


Gui, Add, Button, default, OK  ; run when the button is pressed.
Gui, Add, Button, , Cancel ; exit when pressed
Gui, Show,, Simple Input Example
return  ; End of auto-execute section. The script is idle until the user does something.

GuiClose:
ButtonOK:
    Gui, Submit  ; Save the input from the user
    WinActivate, Age of Empires II Expansion ahk_class Age of Empires II Expansion ahk_exe age2_x1.exe
    sleep 2000
    
    BlockInput, On
    If rec
    gosub, aresources
    
    If exp
    gosub, amap
    
    If vis
    gosub, afog
	
    
    If bul
    gosub, abuilding
    
    BlockInput, Off
    ExitApp

ButtonCancel: 
    setcapslockstate, off
    MsgBox Canceled 
    ExitApp ; end of the app 

aresources:
Loop, %total%
{
    Sleep, 100
    send {enter} ; chat
    Sleep, 100
    sendinput cheese steak jimmy's
    Sleep, 100
    send {enter} ; submit
    Sleep, 100
    send {enter} ; chat
    Sleep, 100
    sendinput lumberjack
    Sleep, 100
    send {enter} ; out
    Sleep, 100
    send {enter} ; submit
    Sleep, 100
    sendinput robin hood
    Sleep, 100
    send {enter} ; out
    Sleep, 100
    send {enter} ; submit
    Sleep, 100
    sendinput rock on
    Sleep, 100 
    send {enter} ; out
}
return

amap:
Sleep, 100
send {enter} ; chat
Sleep, 100
sendinput marco
Sleep, 100
send {enter} ; submit
return

afog:
Sleep, 100
send {enter} ; chat
Sleep, 100
sendinput polo
Sleep, 100
send {enter} ; submit
return

abuilding:
Sleep, 100
send {enter} ; chat
Sleep, 100
sendinput aegis
Sleep, 100
send {enter} ; submit
return