#SingleInstance Force
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\32x32\Singles

; ImageSearch, x, y, A_ScreenWidth - 430, A_ScreenHeight - 50, A_ScreenWidth, A_ScreenHeight, *25 PangoBright_MAINICON_16x16.ico 

; ; ImageSearch, x, y, A_ScreenWidth - 430, A_ScreenHeight - 50, A_ScreenWidth, A_ScreenHeight, *25 PangoBright_MAINICON.ico 

; If (ErrorLevel == 0)
    ; MsgBox, 48,, % "x,y: " x "," y, 10
; Else
    ; MsgBox, 48,, % "Not Found - ErrorLevel = " ErrorLevel , 1

; 2=100
; 3=90
; 4=80
; 5=70
; 6=60
; 7=50
; 8=40
; 9=30
; 10=20

OutputDebug, DBGVIEWCLEAR
^+Numpad0:: 
^+Numpad9:: 
^+Numpad8:: 
^+Numpad7:: 
^+Numpad6:: 
^+Numpad5:: 
^+Numpad4:: 
^+Numpad3:: 
^+Numpad2::
    MouseMove, 1110, 1005
    SendInput {Click, Right}{Down 3}{Enter}
    
Return 

