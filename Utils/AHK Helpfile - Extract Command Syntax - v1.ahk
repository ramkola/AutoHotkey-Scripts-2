#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\misc.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_ROOT_DIR%
; #NoTrayIcon
Menu, Tray, Icon, ..\resources\32x32\icons8-under-construction-32.png

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, DBGVIEWCLEAR
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe

html_dir := A_WorkingDir "\misc\html_source\"
already_ran := True
If Not already_ran
    get_helpfile_source_pages(html_dir)

out_file := create_script_outfile_name(A_WorkingDir, A_ScriptName)
write_string := ""
FileDelete, %out_file% 

html_doc := ComObjCreate("HTMLfile")
file_pattern := html_dir "*.htm"
countx := 0
Loop, Files, %file_pattern%
{
    FileRead, html, %A_LoopFileFullPath%
    html_doc.open()
    html_doc.Write(html)
    html_doc.close()
    Sleep 0         ; performs unreliably without this in
    
    Splitpath, A_LoopFileFullPath,,,,out_name_no_ext
    if (SubStr(out_name_no_ext, 1, 1) == "_")
        command_name := "#" SubStr(out_name_no_ext, 2)
    else
        command_name := out_name_no_ext
    
If instr(command_name, "Transform")
    dbgp_breakpoint := True

    syntax_texts := html_doc.getElementsByClassname("Syntax")
    optional_texts := html_doc.getElementsByClassname("optional")
    write_string := command_name chr(7)
    ; i_index := 0
    Loop
    {
        Try 
            ; syntax_text := syntax_texts[i_index].InnerText 
            ; syntax_text := syntax_texts[a_index - 1].InnerText 
            syntax_text := syntax_texts[0].InnerText 
        Catch
            Break   ; end of syntax tags exit loop
        ; Try optional_text := optional_texts[i_index].InnerText
        ; Try optional_text := optional_texts[a_index - 1].InnerText
        Try optional_text := optional_texts[0].InnerText
        ;
        syntax_text := StrReplace(syntax_text, optional_text, "[" optional_text "]")
        write_string .= syntax_text "`n"
        ; i_index++
    }
    if (i_index > 1)
        OutputDebug, % command_name
    FileAppend, %write_string%, %out_file% 
}    

SendInput !fo 
Sleep 300 
SendInput %out_file%{Enter}

ExitApp
