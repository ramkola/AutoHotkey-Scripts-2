#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\misc.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_MY_ROOT_DIR%

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

    syntax_texts := html_doc.getElementsByClassname("Syntax")    ;[0].InnerText
    optional_texts := html_doc.getElementsByClassname("optional")    ;[0].InnerText
    write_string := "                                           --- " A_LoopFileName " ---`n"
    i_index := 0
    Loop
    {
        Try 
            syntax_text := syntax_texts[i_index].InnerText 
        Catch
            Break   ; end of syntax tags exit loop
        Try optional_text := optional_texts[i_index].InnerText
        ;
        syntax_text := StrReplace(syntax_text, optional_text, "[" optional_text "]")
        write_string .= syntax_text "`n"
        i_index++
    }
    FileAppend, %write_string%, %out_file% 
}    

SendInput !fo 
Sleep 300 
SendInput %out_file%{Enter}

ExitApp
