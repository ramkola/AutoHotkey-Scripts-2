#NoEnv
#SingleInstance Force
;------------------------------------------------------
;
; Starts DBGp's debugger if it isn't already running
; Returns True if started. False if not started
;
;------------------------------------------------------
start_dbgp()
{
    WinGetTitle, win_title, A
    undocked_DBGp_win_title := "DBGp ahk_class #32770 ahk_exe notepad++.exe"
    
    undocked := WinExist(undocked_DBGp_win_title)
    ControlGet, is_visible, Visible,,TNppDockingForm11, %win_title%  
    if not undocked and not is_visible
    {
        WinMenuSelectItem, %win_title%,, Plugins, DBGp, Debugger 
        Sleep 10      
    }
    undocked := WinExist(undocked_DBGp_win_title)
    ControlGet, is_visible, Visible,,TNppDockingForm11, %win_title%  
    Return (undocked or is_visible)
}
;------------------------------------------------------
;
; Retrieves a list of running processes via COM.
;
;------------------------------------------------------
get_running_processes1()
{
    Gui, Add, ListView, x2 y0 w400 h500, Process Name|Command Line
    for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
        LV_Add("", process.Name, process.CommandLine)
    Gui, Show,, Process List
Return
}
;------------------------------------------------------
;
; Retrieves a list of running processes via DllCall.
;
;------------------------------------------------------
get_running_processes2()
{
    ; Example #4: Retrieves a list of running processes via DllCall then shows them in a MsgBox.

    d := "  |  "  ; string separator
    s := 4096  ; size of buffers and arrays (4 KB)

    Process, Exist  ; sets ErrorLevel to the PID of this running script
    ; Get the handle of this script with PROCESS_QUERY_INFORMATION (0x0400)
    h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel, "Ptr")
    ; Open an adjustable access token with this process (TOKEN_ADJUST_PRIVILEGES = 32)
    DllCall("Advapi32.dll\OpenProcessToken", "Ptr", h, "UInt", 32, "PtrP", t)
    VarSetCapacity(ti, 16, 0)  ; structure of privileges
    NumPut(1, ti, 0, "UInt")  ; one entry in the privileges array...
    ; Retrieves the locally unique identifier of the debug privilege:
    DllCall("Advapi32.dll\LookupPrivilegeValue", "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
    NumPut(luid, ti, 4, "Int64")
    NumPut(2, ti, 12, "UInt")  ; enable this privilege: SE_PRIVILEGE_ENABLED = 2
    ; Update the privileges of this process with the new access token:
    r := DllCall("Advapi32.dll\AdjustTokenPrivileges", "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)
    DllCall("CloseHandle", "Ptr", t)  ; close this access token handle to save memory
    DllCall("CloseHandle", "Ptr", h)  ; close this process handle to save memory

    hModule := DllCall("LoadLibrary", "Str", "Psapi.dll")  ; increase performance by preloading the library
    s := VarSetCapacity(a, s)  ; an array that receives the list of process identifiers:
    c := 0  ; counter for process idendifiers 
    DllCall("Psapi.dll\EnumProcesses", "Ptr", &a, "UInt", s, "UIntP", r)
    Loop, % r // 4  ; parse array for identifiers as DWORDs (32 bits):
    {
        id := NumGet(a, A_Index * 4, "UInt")
       ; Open process with: PROCESS_VM_READ (0x0010) | PROCESS_QUERY_INFORMATION (0x0400)
        h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id, "Ptr")
        if !h
            continue
        VarSetCapacity(n, s, 0)  ; a buffer that receives the base name of the module:
        e := DllCall("Psapi.dll\GetModuleBaseName", "Ptr", h, "Ptr", 0, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
        if !e    ; fall-back method for 64-bit processes when in 32-bit mode:
            if e := DllCall("Psapi.dll\GetProcessImageFileName", "Ptr", h, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
                SplitPath n, n
        DllCall("CloseHandle", "Ptr", h)  ; close process handle to save memory
        if (n && e)  ; if image is not null add to list:
            l .= n . d, c++
    }
    DllCall("FreeLibrary", "Ptr", hModule)  ; unload the library to free memory
    ; Sort, l, C  ; uncomment this line to sort the list alphabetically
    ; MsgBox, 0, %c% Processes, %l%
    Return, %l%
}