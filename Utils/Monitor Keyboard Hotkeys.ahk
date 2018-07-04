#NoEnv
#NoTrayIcon
#SingleInstance Force
SetBatchLines -1

global HotkeysList := {}
global times_called := 0

kbdHook := DllCall("SetWindowsHookExW"
    , "Int", 13
    , "Ptr", RegisterCallback("LowLevelKeyboardProc", "Fast")
    , "Ptr", DllCall("GetModuleHandle", "UInt", 0, "Ptr")
    , "UInt", 0, "Ptr")

OnExit ^!+ScrollLock
return

^!+ScrollLock::
    times_called++
    if (times_called = 1) 
    {
        out_file := "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\Misc\Monitor Keyboard Hotkeys.txt"
        FormatTime, end_time,,yyyy-MM-dd HH:mm  
        out := A_ScriptName " - " end_time "`n" 
        for hotkeyName, clickCount in HotkeysList
            out .= hotkeyName "  " clickCount "`n"
        FileAppend, %out%, %out_file%
        run, notepad.exe "%out_file%"
    }
    DllCall("UnhookWindowsHookEx", "Ptr", kbdHook)
    ExitApp

Pause::
    for hotkeyName, clickCount in HotkeysList
        out .= hotkeyName " - " clickCount "`n"
    OutputDebug, % out
    out := ""
    return

LowLevelKeyboardProc(nCode, wParam, lParam) {
    static ModList := {Ctrl: "^", Shift: "+", Alt: "!"}
   
    Critical

    if (wParam = 256) {
        for mod, modShortName in ModList
            if GetKeyState(mod)
                hotkeyName .= modShortName

        SetFormat IntegerFast, H
        hotkeyName .= GetKeyName("vk" NumGet(lParam+0, 0, "UInt"))
        SetFormat IntegerFast, D
        ObjHasKey(HotkeysList, hotkeyName)
            ? HotkeysList[hotkeyName] += 1
            : HotkeysList[hotkeyName] := 1
    }
    return DllCall("CallNextHookEx", "Ptr", 0, "Int", nCode, "UInt", wParam, "Ptr", lParam)
}