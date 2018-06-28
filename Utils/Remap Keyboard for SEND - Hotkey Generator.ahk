#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk

key_names := "Alt,AppsKey,BackSpace,Break,Browser_Back,Browser_Favorites,Browser_Forward,Browser_Home,Browser_Refresh,Browser_Search,Browser_Stop,CapsLock,Control,CtrlBreak,Delete,Down,End,Enter,Escape,F1,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F2,F20,F21,F22,F23,F24,F3,F4,F5,F6,F7,F8,F9,Help,Home,Insert,LAlt,Launch_App1,Launch_App2,Launch_Mail,Launch_Media,LButton,LControl,Left,LShift,LWin,MButton,Media_Next,Media_Play_Pause,Media_Prev,Media_Stop,NumLock,Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadAdd,NumpadClear,NumpadDel,NumpadDiv,NumpadDot,NumpadDown,NumpadEnd,NumpadEnter,NumpadHome,NumpadIns,NumpadLeft,NumpadMult,NumpadPgDn,NumpadPgUp,NumpadRight,NumpadSub,NumpadUp,Pause,PgDn,PgUp,PrintScreen,RAlt,RButton,RControl,Right,RShift,RWin,ScrollLock,Shift,Sleep,Space,Tab,Up,Volume_Down,Volume_Mute,Volume_Up,WheelDown,WheelLeft,WheelRight,WheelUp,Win,XButton1,XButton2"

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

key_list := StrSplit(key_names, ",")

quote_char := chr(34)

x := ""
for i, j in key_list
{
    x .= j "::type_in(" quote_char "{"  j "}" quote_char ")`n"
    x .= j " & Up::type_in(" quote_char "{"  j " Up}" quote_char ")`n"
    x .= j " & Down::type_in(" quote_char "{"  j " Down}" quote_char ")`n"
}    


Clipboard := x    

MsgBox % "Check Clipboard"    
    
exitapp