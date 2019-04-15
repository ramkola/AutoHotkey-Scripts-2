;-------------------------------------------------------------------
; This function requires PythonScript plugin
;
; run_python_script(p_pythonscript_menu_name, p_delete_file)
;
; Note:
;   Couldn't get a proper IPC working to send/receive messages to PythonScript
;   so clipboard is being used for now.....
;-------------------------------------------------------------------
run_python_script(p_pythonscript_menu_name, p_send_to_python := "")
{
    Static script_running := False
    while script_running
        Sleep 10
    script_running := True
    If (g_hwnd_editor = "")
        ; calling program didn't define and set a Global g_hwnd_editor variable
        WinGet,g_hwnd_editor, ID, ahk_class Notepad++ ahk_exe notepad++.exe
    
    saved_clipboard := ClipboardAll
    Clipboard := ""
    while Clipboard
        Sleep 1
    if p_send_to_python
    {
        Clipboard := p_send_to_python
        While (Clipboard = "")
            Sleep 1
    }
    ; OutputDebug, % A_ThisFunc format(" - params: {} - {}", p_pythonscript_menu_name, Clipboard)
    Sleep 200    ; avoid running 2 scripts at same time error and allow time for the clipboard to empty
    WinMenuSelectItem, ahk_id %g_hwnd_editor%,,Plugins,Python Script,Scripts,AHK Modules,%p_pythonscript_menu_name%
    Sleep 700    ; allow time for the clipboard to receive pythonscript return code
    result := Clipboard 
    Clipboard := saved_clipboard
    script_running := False
; OutputDebug, % A_ThisFunc ":" p_pythonscript_menu_name " - result: " result
    Return %result% 
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_activate_and_goto_line(p_line_num, p_filename)
; activates / opens filename and goes to the specified line number
;------------------------------------------------------------------------------------------------
npp_activate_and_goto_line(p_line_num, p_filename)
{
    params := p_line_num chr(7) p_filename
    result := run_python_script("notepad_activate_and_editor_goto_line", params)
    Return %result%        
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_activate_file(p_fullpath)
; Activates a file opened in Notepad++ by its filename.
;------------------------------------------------------------------------------------------------
npp_activate_file(p_fullpath)
{
    result := run_python_script("notepad_activate_file", p_fullpath)
    Return %result%        
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_activate_bufferid(p_buffer_id)
; Activates a file opened in Notepad++ by its associated buffer ID.
;------------------------------------------------------------------------------------------------
npp_activate_bufferid(p_buffer_id)
{
    filename := run_python_script("notepad_activate_bufferid", p_buffer_id)
    Return %filename%        
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_goto_line(p_line_num)
; goes to the specified line number in the currently active npp document
;------------------------------------------------------------------------------------------------
npp_goto_line(p_line_num, p_filename)
{
    params := p_line_num chr(7) p_filename
    line_num := run_python_script("editor_goto_line", params)
    Return %line_num%        
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_get_current_filename()
; Returns currently active document open in Notepad++
;------------------------------------------------------------------------------------------------
npp_get_current_filename(p_fname_only := False, p_activate := False)
{
    filename := run_python_script("notepad_get_current_filename")
    If p_fname_only
        SplitPath, filename, filename
    if Not filename
        filename := get_current_npp_filename_ahk_version(p_fname_only)

    Return %filename%
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_tab_list := []
; get_npp_tab_list(p_npp_tab_list)
; 
; Retrieves all filenames opened in Notepad++ with their associated tab number
;------------------------------------------------------------------------------------------------
get_npp_tab_list(p_npp_tab_list)
{
    notepad_getfiles := ""
    notepad_getfiles := run_python_script("notepad_getfiles")
    If Not notepad_getfiles
    {
        OutputDebug, % A_ThisFunc ": notepad_getfiles.py did not work."
        Return
    }
    notepad_getfiles := SubStr(notepad_getfiles, 1, -1)    ; truncate eof blank line
    Loop, Parse, notepad_getfiles, `n, `r 
    {
        tab_info := StrSplit(A_LoopField, Chr(7))
        filename := tab_info[1]
        bufferID := tab_info[2]
        index    := tab_info[3]
        view     := tab_info[4]
        p_npp_tab_list.Push([filename, bufferID, index, view])
    }
    p_npp_tab_list.Pop()                ; last record entry from pythonscript's notepad.getfiles() method is unwanted.
    Return %p_npp_tab_list%
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_pythonscript_console_show(p_clearscreen := False)
;------------------------------------------------------------------------------------------------
npp_pythonscript_console_show(p_clearscreen := False)
{
    result := run_python_script("console_show", p_clearscreen)
    Return %result%        
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_pythonscript_console_hide()
;------------------------------------------------------------------------------------------------
npp_pythonscript_console_hide()
{
    result := run_python_script("console_hide")
    Return %result%        
}
;------------------------------------------------------------------------------------------------
; This function requires PythonScript plugin
; npp_pythonscript_console_hide()
;------------------------------------------------------------------------------------------------
npp_show_tab_context_menu()
{
OutputDebug, % "Here 1 - " A_ScriptName 
    result := run_python_script("notepad_show_tab_context_menu")
    Return %result%        
}
;------------------------------------------------------------------------------
; get_current_npp_filename(p_fname_only := False) 
;
; Returns the fullpath of the current file being edited in Notepad++ 
; To get the filename only without the path, pass True for the parameter.
;------------------------------------------------------------------------------
get_current_npp_filename_ahk_version(p_fname_only := False) 
{
	If (A_TitleMatchMode = "RegEx")
		WinGetTitle, current_file, ahk_class Notepad\+\+ ahk_exe notepad\+\+\.exe
	Else
		WinGetTitle, current_file, ahk_class Notepad++ ahk_exe notepad++.exe
	OutputDebug, % "current_file: " current_file
    RegExMatch(current_file, ".*(?=\s-\sNotepad++)", fname)
    If (SubStr(fname,1,1) == "*")  
        fname := SubStr(fname, 2)
    If p_fname_only
    {
        SplitPath, fname, out_filename
        fname := out_filename
    }
    OutputDebug, % fname " - (" A_ThisFunc ")"
    Return %fname%
}
