;--------------------------------------------------------------
; DBGp hotkeys.	*** OBSOLETE ***
; allows these keys to work when focus is not on DBGp panel
;---------------------------------------------------------------
^!d::   ; Add Watch to DBGp watches.
{
    Run, MyScripts\NPP\Misc\DBGp Add Watch.ahk
    Return
}

F10::   ; DBGp plugin Step Into
{
    WinMenuSelectItem, A,, Plugins, DBGp, Step Into
    Return
}

F11::   ; DBGp plugin Step Over
{
    WinMenuSelectItem, A,, Plugins, DBGp, Step Over
    Return
}

+F10::   ; DBGp plugin Step Out
{
    WinMenuSelectItem, A,, Plugins, DBGp, Step Out
    Return
}

+F11::   ; DBGp plugin Run to
{
    WinMenuSelectItem, A,, Plugins, DBGp, Run to
    Return
}


^F10::   ; DBGp plugin Run
{
    WinMenuSelectItem, A,, Plugins, DBGp, Run
    Return
}


^!+d::   ; DBGp plugin Stop
{
    start_dbgp()
    WinMenuSelectItem, A,, Plugins, DBGp, Stop
    Return
}


^F9::   ; DBGp plugin Toggle Breakpoint
{
    start_dbgp()
    WinMenuSelectItem, A,, Plugins, DBGp, Toggle Breakpoint
    Return
}

^!+F5::   ; Debug current script being edited with DBGp debugger
{
    Run, MyScripts\NPP\Misc\Debug Current Script.ahk
    Return
}

^F5::   ; DBGp Clear All Watches
{
    Run, MyScripts\NPP\Misc\DBGp Clear All Watches.ahk
    Return
}

^+F5::   ; DBGp Clear All Breakpoints
{
    Run, MyScripts\NPP\Misc\DBGp Clear All Breakpoints.ahk
    Return
}
; ---------- End of DBGp hotkeys ----------

;--------------------------------------------------------------
; PythonScript hotkeys.	*** OBSOLETE ***
;---------------------------------------------------------------
^+a::   ; Selects word under cursor (like mouse doubleclick on word)
{
    WinMenuSelectItem, A,,Plugins,Python Script,Scripts,select_word_under_cursor
    Return   
}

^!+p::   ; Copies the current word and pastes it to console.write() statement on a new line (Python Script).
{
    the_word := select_and_copy_word()
    send_cmd := "console.write('" the_word ": ' + str(" the_word ") + '\n')"
    Clipboard := send_cmd
    ClipWait,1
    SendInput {End}{Enter}^v{Home}
    Return
}

^F6::   ; PythonScript - Toggle Console
{
    WinMenuSelectItem,A,,Plugins,Python Script,Show Console
    Return
}
!F6::   ; PythonScript - Create New Script
{
    WinMenuSelectItem,A,,Plugins,Python Script,New Script
    Return
}

F6::    ; Execute current PythonScript in console
{
    file_full_path := npp_get_current_filename()
    python_ext := (SubStr(file_full_path, -2) = ".py")
    If Not FileExist(file_full_path)  
    {
        MsgBox, 48,, % file_full_path "`n`nDoes not exist"
        Return
    }
    If Not python_ext
    {
        MsgBox, 48,, % file_full_path "`n`nNot a python file (.py)"
        Return
    }
    WinMenuSelectItem, A,, File, Save
    ControlGetFocus, save_focus, A
    npp_pythonscript_console_show()
    ; SetTitleMatchMode 2
    ControlFocus, Edit1, A
    ControlGetFocus, got_focus, A
    if not instr(got_focus, "Edit")
    {
        MsgBox, 48,, % "Can not find python console.`n`nControl with focus: " got_focus
        Return
    }
    SplitPath, file_full_path, fname, fdir 
    SendInput ^a{Delete}
    Send {Text}import os; os.chdir('%fdir%')
    Sleep 10
    SendInput {Enter}
    Send {Text}execfile('%fname%')
    Sleep 10
    SendInput {Enter}
    Sleep 1000  ; needs to let fname finish before it change focus
    ControlFocus, %save_focus%, A
    Click
    Return
}

^!F6::    ; PythonScript - Run Previous Script
{
    WinMenuSelectItem,A,,File,Save
    WinMenuSelectItem,A,,Plugins,Python Script,Run Previous Script
    Return
}

^!+F6::     ; PythonScript - Execute commands in console or launch Scintilla web help 
{
    Run, MyScripts\Utils\PythonScript Commands from Scintilla Methods.ahk
    Return
}
; ------------------- End of PythonScript hotkeys ------------------------
