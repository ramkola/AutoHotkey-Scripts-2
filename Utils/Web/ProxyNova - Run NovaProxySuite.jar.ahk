#SingleInstance Force
SetTitleMatchMode RegEx

OutputDebug, DBGVIEWCLEAR
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\Web Proxy Checker

wpc_wintitle = Web Proxy Checker.* ahk_class TForm1 ahk_exe wpc.exe
proxy_nova_wintitle = Nova Proxy-Suite \d+\.\d+ by ProxyNova\.com ahk_class SunAwtFrame ahk_exe javaw.exe
If WinExist(proxy_nova_wintitle)
    WinClose

Run, "C:\Program Files (x86)\NovaProxy\NovaProxySuite.jar" 
WinWaitActive, %proxy_nova_wintitle%,, 2
Sleep 500
If WinExist("Software out of date ahk_class SunAwtDialog ahk_exe javaw.exe")
    SendInput {Enter}
Sleep 500
Click 69, 474
SendInput {Down 2}{Enter}
Sleep 500
SendInput C:\Users\Mark\Desktop\p.txt{Enter}
Sleep 500
If WinExist("Message ahk_class SunAwtDialog ahk_exe javaw.exe")
    SendInput {Enter}

Sleep 500
WinActivate, %proxy_nova_wintitle%
WinWaitActive, %proxy_nova_wintitle%,, 2
Click 199, 76

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
ExitApp

^+x::ExitApp    

; C:\Users\Mark\Desktop\p.txt

