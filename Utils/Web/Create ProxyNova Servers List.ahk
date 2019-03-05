#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
SetTitleMatchMode RegEx
; proxy_wintitle = .*Proxy Server List.*Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
proxy_wintitle = .*Proxy Server List.*
If Not WinExist(proxy_wintitle)
{
    browser := default_browser() 
    Run, "%browser%"
    Run, https://www.proxynova.com/proxy-server-list/country-gb/#
}
WinActivate, %proxy_wintitle%
WinWaitActive, %proxy_wintitle%,,2

Clipboard := "" 
SendInput ^a^c      ; select all / copy
ClipWait, 2
Click   ; deselect text
write_string := ""
proxy_server_list := StrSplit(Clipboard, Chr(10))
For i_index, Line in proxy_server_list
{ 
    replaced_count := 0
    ip_address := RegExReplace(Trim(Line),"(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s\d{1,5}.*", "$1", replaced_count)
    If replaced_count
    {
        replaced_count := 0
        port_num := RegExReplace(Trim(Line),"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\s(\d{1,5}).*", "$1", replaced_count)
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
; WinActivate, .*Notepad\+\+ ahk_class Notepad\+\+ ahk_exe notepad\+\+\.exe
; SendInput !fo 
; Sleep 300 
; SendInput %out_file%{Enter}
ClipBoard := out_file
ClipWait, 2
If Not WinExist("Web Proxy Checker.* ahk_class TForm1 ahk_exe wpc.exe")
    Run, C:\Program Files (x86)\Opt-In Software\wpc.exe
Else
    WinActivate
Click 470, 380 ; Start proxy checker 
ExitApp
