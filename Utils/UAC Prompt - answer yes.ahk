#SingleInstance Force
#Persistent
Loop
{
    Sleep 500
    ; If WinExist("User Account Control")
    If WinExist("ahk_exe consent.exe")
        SendInput !y
}
