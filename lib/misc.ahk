;---------------------------------------------------- 
;
;   get_helpfile_source_pages(p_html_dir)
;
;---------------------------------------------------- 
get_helpfile_source_pages(p_html_dir)
{
    quote := Chr(34)    ;  is ASCII: "
    index_start_tag = <div Class="index" style="visibility: inherit;">
    re_search = O)(?<=<a href=%quote%)https://autohotkey.com/docs/commands/.*?htm
    FileRead, html, Misc\Autohotkey Help HTML Source.html
    links := {}
    index_found := False
    Loop,Parse,html,`n,`r
    {
        If !index_found
            If (InStr(A_LoopField, index_start_tag))
                index_found := True
            Else
                Continue    ; skip beginning of file, only interested in lines that are in the index
    
        ; extract help file's index, unique links only
        pos := 1
        While (pos > 0)
        {
            pos := RegExMatch(A_LoopField, re_search, match, pos + 1)
            If Not links.HasKey(match.value)
                links[match.value] := "h3_tags"
        }

        Break   ; not interested in the rest of the file so exit loop
    }
    
    ; fetch the helpfile pages from the index and save the sources
    FileCreateDir, %p_html_dir%
    For link1, dummy in links
    {
        pos := InStr(link1, "/",, -1)
        fname := SubStr(link1, pos + 1)
        html_fname := p_html_dir fname
        UrlDownloadToFile, %link1%, %html_fname%
        OutputDebug, % html_fname      
    }
    
    Return
}