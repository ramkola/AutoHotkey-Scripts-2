#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\misc.ahk
#Include lib\constants.ahk
#Include lib\strings.ahk
#Include lib\ahk_word_lists.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SendMode Input
SetWorkingDir %AHK_ROOT_DIR%

word_array := {}
Loop, Parse, word_list, `n, `r
    word_array[A_LoopField] := A_LoopField

html_dir := A_WorkingDir "\misc\html_source\"
already_ran := True
If Not already_ran
    get_helpfile_source_pages(html_dir)

out_file := create_script_outfile_name(A_ScriptFullPath)
FileDelete, %out_file% 
write_string := ""


tag_list := ["H2","H3","H4"]
html_doc := ComObjCreate("HTMLfile")
file_pattern := html_dir "*.htm"
countx := 0
Loop, Files, %file_pattern%
{
    FileRead, html, %A_LoopFileFullPath%
    ; FileAppend, Words from: %A_LoopFileName%`n, %out_file% 
    html_doc.open()
    html_doc.Write(html)
    html_doc.close()
    title := html_doc.getElementsByTagName("TITLE")[0].InnerText
    title := RegExReplace(title, "\(|\)")    
    add_words := {}
    add_words[title] := 1
    
    For tag_index, tag in tag_list
    {
        tags := html_doc.getElementsByTagName(tag)
        Sleep 0         ; performs unreliably without this in
        i_index := 0
        Loop
        {
            Try { 
                key_name := tags[i_index].InnerText
                add_words[key_name] := 1
                i_index++
            } Catch e
                Break ; end of tags so exit
        }
        
        For key, value in add_words
        {
            duplicate_word := (word_array[key] = key) ; case insensitve
            RegExReplace(key, "(\b\w+\b)", "$1", word_count)
            too_many_words := (word_count != 1)
            illegal_chars := RegExMatch(key, "\W+")
            If key in Block,Blocks,Example,Examples,Failure,Flag,Flags,Method,Methods,Option,Options,Parameter,Parameters,Performance,Related,Remark,Remarks,Usage,(Blank)
                unwanted_words := True
            Else
                unwanted_words := False
            
            If duplicate_word or too_many_words or illegal_chars or unwanted_words
                1=1 ; OutputDebug, % "Not adding word : " key
            Else
            {
                write_string := key "`n"
                FileAppend,%write_string%, %out_file%
                countx++
            }
        } 
    }   ; endfor tag_list
}   


SendInput !fo 
Sleep 300 
SendInput %out_file%{Enter}

ExitApp



^p::Pause
^x::ExitApp


