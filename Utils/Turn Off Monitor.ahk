;**********************************
; Needs to be run as administrator
;**********************************
#SingleInstance Force
BlockInput, On
Run, "%A_ProgramFiles%\devcon.exe" Disable *mouse*
SendMessage,0x112,0xF170,2,,Program Manager         ; turn off monitor (sleep)
BlockInput, Off
Return

Escape::
1::
2::
3::
4::
5::
6::
7::
8::
9::
0::
	Run, "%A_ProgramFiles%\devcon.exe" Enable *mouse*
    ; xdWinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    ExitApp
