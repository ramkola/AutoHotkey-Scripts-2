; Sends active window to next available virtual desktop
; and activates virtual desktop #1
#SingleInstance Force
SendMode Input
Send #{Tab}				; activate virtual window switcher screen
Sleep 1000
MouseMove, 280, 300		; location of first active thumbnail
Send {AppsKey}			; context menu
Sleep 200
Send {Down 2}			; "Move to" menuitem
Sleep 200
Send {Right}			; "desktop #" menuitem
Sleep 200
Send {Enter}			; 
Click, Left, 100, 65	; activate desktop #1 (thumbnail)
