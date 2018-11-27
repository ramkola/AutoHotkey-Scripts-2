;**********************************
; Needs to be run as administrator
;**********************************
LButton Up::
	Run, "%A_ProgramFiles%\devcon.exe" disable *mouse*
    SendMessage,0x112,0xF170,2,,Program Manager         ; turn off monitor (sleep)
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
	Run, "%A_ProgramFiles%\devcon.exe" enable *mouse*
    ExitApp