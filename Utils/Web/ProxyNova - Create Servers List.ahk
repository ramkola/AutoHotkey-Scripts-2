#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
SetTitleMatchMode RegEx

goodprox_file = C:\Users\Mark\Desktop\goodprox.txt
goodprox_wintitle = goodprox.txt - Notepad ahk_class Notepad ahk_exe NOTEPAD.EXE
wpc_wintitle = Web Proxy Checker.* ahk_class TForm1 ahk_exe wpc.exe
proxy_wintitle = .*Proxy Server List.*
If WinExist(goodprox_wintitle)
    WinClose
If Not WinExist(proxy_wintitle)
{
    browser := default_browser() 
    Run, "%browser%"
    Run, https://www.proxynova.com/proxy-server-list/country-gb/#
}
WinActivate, %proxy_wintitle%
WinWaitActive, %proxy_wintitle%,,2
WinMaximize, %proxy_wintitle%
Clipboard := "" 
SendInput ^a^c      ; select all / copy
ClipWait, 2
Click   ; deselect text
write_string := ""
proxy_server_list := StrSplit(Clipboard, Chr(10))
For i_index, line_num in proxy_server_list
{ 
    replaced_count := 0
    ip_address := RegExReplace(Trim(line_num),"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s\d{1,5}.*", "$1", replaced_count)
    If replaced_count
    {
        replaced_count := 0
        port_num := RegExReplace(Trim(line_num),"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\s(\d{1,5}).*", "$1", replaced_count)
        If replaced_count
        {
           write_string .= ip_address ":" port_num "`r`n"
           OutputDebug, % write_string
        }
        Else
            OutputDebug, % "No port_num for: " ip_address
    }
}

out_file := "C:\Users\Mark\Desktop\p.txt"
FileDelete, %out_file% 
FileAppend, %write_string%, %out_file% 

RunWait, "%A_ScriptDir%\ProxyNova - Run NovaProxySuite.jar.ahk"
Sleep 10000

If Not WinExist(wpc_wintitle)
    Run, C:\Program Files (x86)\Opt-In Software\wpc.exe
Else
    WinActivate, %wpc_wintitle%
WinWaitActive, %wpc_wintitle%, 3
If WinActive(wpc_wintitle)
{
    Click 470, 380 ; Start proxy checker 
    MouseMove, 10, 10
    Sleep 500
    ; Wait for proxy checker to stop running
    SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\Web Proxy Checker
    countx := 0
    ErrorLevel = 9999
    While ErrorLevel and countx < 120
    {
        ; Sleep time * max countx (120) is number of seconds to wait for proxy checker
        ; to stop running and the Start Button turns green again.
        ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 Pango 70 - Start Button.png
        Sleep 1000      
        countx++
    }
    Run, Notepad.exe "%goodprox_file%"
}

Return

#If WinExist(goodprox_wintitle)
^!+F7::
!+F7::
    Run, "%A_WorkingDir%\Enter Proxy From GoodProx.txt into Proxy Switcher Extension.ahk" %A_ThisHotkey%
    Return
