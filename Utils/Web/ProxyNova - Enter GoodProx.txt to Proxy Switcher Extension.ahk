; Arguements: None or !F7   
#SingleInstance Force
SetTitleMatchMode 2

hot_key := (A_ARGS[1] == "") ? "!+F7" : A_Args[1]
goodprox_file = C:\Users\Mark\Desktop\goodprox.txt
chrome_wintitle = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
notepad_wintitle = goodprox.txt - Notepad ahk_class Notepad ahk_exe NOTEPAD.EXE
ClipBoard := ""
If WinExist(notepad_wintitle)
    WinActivate
Else
{
    Run, Notepad.exe "%goodprox_file%"
    Sleep 1000
    If Not WinExist(notepad_wintitle)
    {
        MsgBox, 48,, % "Can't find: " goodprox_file, 5
        Return
    }
}
; copy current row (where caret is) from goodprox_file
SendInput {Home}{Shift Down}{End}{Shift Up}{LControl Down}c{LControl Up}
ClipWait, 2
; parse proxy info
proxy_info := ClipBoard
server_type := RegExReplace(proxy_info, "([#|\+|\*])(\d{1,3}\.){3}\d{1,3}:\d{1,5}:[A-Z]{2}", "$1")
ip_address := RegExReplace(proxy_info, "[#|\+|\*]((\d{1,3}\.){3}\d{1,3}):\d{1,5}:[A-Z]{2}", "$1")
port_num := RegExReplace(proxy_info, "[#|\+|\*](\d{1,3}\.){3}\d{1,3}:(\d{1,5}):[A-Z]{2}", "$2")
country_code := RegExReplace(proxy_info, "[#|\+|\*](\d{1,3}\.){3}\d{1,3}:\d{1,5}:([A-Z]{2})", "$2")
; OutputDebug, % "ip_address: " ip_address " port_num: " port_num
; OutputDebug, % "server_type: " server_type " country_code: " country_code

WinActivate, %chrome_wintitle%
WinWaitActive, %chrome_wintitle%
WinMaximize, %chrome_wintitle%
;---------------------------------------------------
; the order of following imagesearches is important
;---------------------------------------------------
MouseMove, 0, 0
SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\Chrome

; Check if Proxy Switcher Entry Page is already open
ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 *TransBlack Zoom 110 Pango 70 - Extension - Proxy Switcher - Entry Page.png
If ErrorLevel = 0
{
    SendInput {Escape}  ; close the page
    Sleep 500
}


; Manual Proxy Entry 
ImageSearch, x, y, A_ScreenWidth/2, 0, A_ScreenWidth, 70,*2 *TransBlack Zoom 110 Pango 70 - Extension - Proxy Switcher - Direct Icon.png
If ErrorLevel = 0
    Goto ENTER_PROXY

ImageSearch, x, y, A_ScreenWidth/2, 0, A_ScreenWidth, 70,*2 *TransBlack Zoom 110 Pango 70 - Extension - Proxy Switcher - Manual Icon.png
If ErrorLevel
{
    OutputDebug, % "ErrorLevel: " ErrorLevel
    Goto EXIT_APP
}

ENTER_PROXY:    ; enters proxy info into Proxy Switcher chrome extension
    MouseMove, x+8, y+6
    Click   ; clicks Proxy Switcher icon in chrome
    Sleep 200
    ;
    If (hot_key == "^!+F7")  
        Click 50,15         ; Direct (no proxy) button
    Else If (hot_key == "!+F7")
    {
        Click 267, 220  ; manual proxy - ip address
        SendInput ^a%ip_address%{Tab}%port_num%
        Click 55,200    ; manual proxy - Manual label button
    }
    Else
    {
        OutputDebug, % "A_ThisLabel: " A_ThisLabel " - A_ScriptName: " A_ScriptName
        OutputDebug, % "Unexpected hot_key param: " hot_key
    }

EXIT_APP:
WinActivate, %notepad_wintitle%
; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe 
ExitApp
