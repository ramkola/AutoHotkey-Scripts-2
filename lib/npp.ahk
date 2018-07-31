Global python_script_ahk_file := "C:\Users\Mark\Desktop\Misc\PythonScript\PythonScriptAhkFile.txt"
;------------------------------------------------------------------------------------------------
; 
; This function requires PythonScript plugin
;
; npp_get_current_filename()
; 
; Returns currently active document open in Notepad++
;
;------------------------------------------------------------------------------------------------
npp_get_current_filename()
{
    
    WinMenuSelectItem, A,,Plugins,Python Script,Scripts,AHK Modules,notepad_get_current_filename
    Sleep 500
    If FileExist(python_script_ahk_file)
        FileRead, filename, %python_script_ahk_file%
    Return %filename%
}
;------------------------------------------------------------------------------------------------
;
; This function requires PythonScript plugin
;
; npp_activate_bufferid(p_buffer_id)
; 
; Retrieves all filenames opened in Notepad++ with their associated tab number
;
;------------------------------------------------------------------------------------------------
npp_activate_bufferid(p_buffer_id)
{
    FileDelete, %python_script_ahk_file%
    FileAppend, %p_buffer_id%, %python_script_ahk_file%
    WinMenuSelectItem, A,,Plugins,Python Script,Scripts,AHK Modules,notepad_activate_bufferid
    Sleep 100
    Return
}
;------------------------------------------------------------------------------------------------
;
; This function requires PythonScript plugin
;
; get_npp_tab_list(p_npp_tab_list)
; 
; Retrieves all filenames opened in Notepad++ with their associated tab number
;
;------------------------------------------------------------------------------------------------
get_npp_tab_list(p_npp_tab_list)
{
    WinMenuSelectItem, A,,Plugins,Python Script,Scripts,AHK Modules,notepad_getfiles
    Sleep 500
    ;
    If Not FileExist(python_script_ahk_file)
    {
        OutputDebug, % A_ThisFunc " - notepad_getfiles.py did not work."
        Return
    }
    FileRead, notepad_getfiles, %python_script_ahk_file% 
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
;------------------------------------------------------------------------------
; get_current_npp_filename(p_fname_only := False) 
;
; Returns the fullpath of the current file being edited in Notepad++ 
; To get the filename only without the path, pass True for the parameter.
;------------------------------------------------------------------------------
get_current_npp_filename(p_fname_only := False) 
{
    WinGetTitle, current_file, ahk_class Notepad++ ahk_exe notepad++.exe
    RegExMatch(current_file, ".*(?=\s-\sNotepad++)", fname)
    If (SubStr(fname,1,1) == "*")  
        fname := SubStr(fname, 2)
    If p_fname_only
    {
        SplitPath, fname, out_filename
        fname := out_filename
    }
    Return %fname%
}
