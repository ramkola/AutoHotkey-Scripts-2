; Purpose: To have 1 routine that uniformly formats a code snippet and is shared by
; multiple programs (ie: Display Code Snippet Info.ahk and Insert Selected Text into Code Snippets.txt.ahk)
;
;   Parameters:
;       p_key_word     - This word is used as the key value in the code_snippetz array in lib\Code Snippets.txt
;                        It is also used like a hotstring by Insert Snippet for Selected Word.ahk
;
;       p_code_snippet - 
;
;   Return: 
;       write_string   - The snippet of code needed to insert into Code Snippets.txt file
;
;   Notes:
;       write_string is a literal string template of the code inserted into Code Snippets.txt
;       the template is then modified with the StrReplace commands to include the specific
;       supplied key_word and code text for this snippet. 
;       
;       The first Join statement is actually constructing the write_string template. 
;       The second Join statement is the literal string of code that gets inserted 
;       into Code Snippets.txt, it shouldn't evaluate to anything other the raw text.
;       (backticks, `n, `r, `t, % should all stay unevaluated as literal strings.)
;
; CAREFUL editing this string, every backtick, percent sign, close bracket, 
; quote and newline has its reason for being there....
create_code_snippet_entry(p_key_word, p_code_snippet)
{
    write_string =
    (Join`r`n ` LTrim %
        
        
        ; ***keyword***
        cs = 
        (Join`r`n % `
        ***codesnippet***
        `)
        code_snippetz["***keyword***"] := cs
    )   ; end of write_string Join

    ; escape any backticks in code_snippet so that they are interpreted as literal strings
    p_code_snippet := StrReplace(p_code_snippet, "``","````")
    ; get rid of backtick in first closed bracket only needed here because nested under 
    ; first Join statement and we don't want this bracket to signal end of first Join statement.
    write_string := StrReplace(write_string, "``)", ")")    
    write_string := StrReplace(write_string, "***keyword***", p_key_word)
    write_string := StrReplace(write_string, "***codesnippet***", p_code_snippet)
    Return write_string
}
/* ----------------------------------------------------------------------------------------
                                Custom Combinations
You can define a custom combination of two keys (except joystick buttons) by using " & " between them. 
In the below example, you would hold down Numpad0 then press the second key to trigger the hotkey:
Numpad0 & Numpad1::MsgBox You pressed Numpad1 while holding down Numpad0.
Numpad0 & Numpad2::Run Notepad

            <<< THE PREFIX KEY LOSES ITS NATIVE FUNCTION: >>> 

In the above example, Numpad0 becomes a prefix key; 
but this also causes Numpad0 to lose its original/native function when it is pressed by itself. 

This routine restores the native function of the prefix key by turning off all custom combinations
that use that prefix key. Those combinations will be disabled but the native function is restored to 
prefix key.

For example, if your script has the following type of hotkey definitions you get to do 5
neat things that you couldn't do before. However, sometimes you really want that native
context menu to  appear but you can't do it because it is being used as a prefix key in
a custom combination hotkey. 

RButton & 1::do_rbutton1_thing
RButton & 2::do_rbutton2_thing
RButton & 3::do_rbutton3_thing
RButton & 4::do_rbutton4_thing
RButton::replace_native_function_with_my_own_thing

That's where this routine comes in. It allows you to temporarily toggle between using your
custom hotkeys and native function of the prefix key (RButton in the above example)

You can define a hotkey with regular modifiers to toggle between native state / custom state. Example:
!RButton::
    rbutton_switch := !rbutton_switch
    toggle_prefix_key_native_function("RButton", rbutton_switch)
    Return
    
Press !RButton to turn custom hotkeys off and restore the native rightclick function (ie: a context menu)
Press !RButton again to get back your custom hotkeys (ie do_rbutton3_thing) but lose your native rightclick function.
*/
toggle_prefix_key_native_function(p_prefix_key, p_on_off)
{
    toggle_list := []
    in_file := A_ScriptFullPath
    FileRead, in_file_var, %in_file% 
    Loop, Parse, in_file_var, `n, `r 
    {
        hotkey_def := RegExReplace(A_LoopField, "i)^(.*" p_prefix_key " & .*)::.*$", "$1", replaced_count)
        If replaced_count
        {
            If InStr(hotkey_def, "RegExReplace(A_LoopField")   
                do_nothing := True   ; skip the line in this code (4 lines up) searching for hotkeys
            Else If RegExMatch(hotkey_def, "\s*;")
                do_nothing := True   ; skip comments
            Else
                toggle_list.Push(hotkey_def)
        }
    }

    write_string := ""
    on_off := p_on_off ? "On" : "Off"
    For i, custom_hotkey in toggle_list
    {
        write_string .= "Hotkey, " custom_hotkey ", " on_off "`r`n"
        If IsLabel(custom_hotkey)
            Hotkey, %custom_hotkey%, %on_off%
        Else
            OutputDebug, % "Skipping... " custom_hotkey 
    }
    If IsLabel(p_prefix_key)
    {
        Hotkey, %p_prefix_key%, %on_off% 
        write_string .= "Hotkey, " p_prefix_key ", " on_off
    }
    Else
        OutputDebug, % "Skipping... " p_prefix_key 

    ; OutputDebug, % "write_string: " write_string
    ttip("`r`n`r`n    Prefix key is turned... " on_off "    `r`n`r`n ", 2000)
    Return
}
;---------------------------------------------------- 
;
;   get_helpfile_source_pages(p_html_dir)
;
;---------------------------------------------------- 
get_helpfile_source_pages(p_html_dir)
{
    quote := Chr(34)    ;  is ASCII: "
    index_start_tag = <div Class="index" Style="visibility: inherit;">
    re_search = O)(?<=<a href=%quote%)https://autohotkey.com/docs/commands/.*?htm
    FileRead, HTML, Misc\Autohotkey Help HTML Source.HTML
    links := {}
    index_found := False
    Loop,Parse,HTML,`n,`r
    {
        If !index_found
            If (InStr(A_LoopField, index_start_tag))
                index_found := True
            Else
                Continue    ; skip beginning of file, only interested in lines that are in the index
    
        ; extract help file's index, unique links only
        Pos := 1
        While (Pos > 0)
        {
            Pos := RegExMatch(A_LoopField, re_search, match, Pos + 1)
            If Not links.HasKey(match.value)
                links[match.value] := "h3_tags"
        }

        Break   ; not interested in the rest of the file so exit loop
    }
    
    ; fetch the helpfile pages from the index and save the sources
    FileCreateDir, %p_html_dir%
    For link1, dummy in links
    {
        Pos := InStr(link1, "/",, -1)
        fname := SubStr(link1, Pos + 1)
        html_fname := p_html_dir fname
        UrlDownloadToFile, %link1%, %html_fname%
        OutputDebug, % html_fname      
    }
    Return
}
