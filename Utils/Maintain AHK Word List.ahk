/* 
    Maintains lib\ahk_word_lists.ahk "word_list" by checking if a new word
    to be added already exists. If it doesn't, then it will add it the library
    file in its proper alphabetical location.

    command line parameters:
        A_Args[1] = p_word_list: filename / string / array
        A_Args[2] = p_delimeter: (optional) default ","

        p_word_list:
            1) can be a filename containing a list of words. 1 word on each line.
            2) string of 1 or more words delimited by anything you want.
               See p_delimeter. Any spaces will be removed.
            3) 1 dimensional array (list) of words.
        
        p_delimeter: (optional) default ","
            If p_word_list is a string, it can be delimited by any delimeter you want.
            If the delimeter is anything except a comma then you should specify it in 
            this parameter.
    
    Examples:
        1) Run, Maintain AHK Word List.ahk "C:\My List of New Words to Add.txt"

        2) Run, Maintain AHK Word List.ahk "NewWord1; NewWord2; NewWord3; NewWord4" ";"

        3) new_words_array := ["NewWord1","NewWord2","NewWord3","NewWord4"]
           Run, Maintain AHK Word List.ahk %new_words_array%

    Note: Make sure words you want to add are spelled correctly with the 
          CamelCase you want it to appear as in case sensitive applications. 
          For instance, programs like Beautify.ahk will alter the words in code 
          according to how it is spelled in word_list.
*/
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\processes.ahk
#Include lib\strings.ahk
#Include lib\constants.ahk
#Include lib\utils.ahk
#Include lib\ahk_word_lists.ahk
#NoEnv
#NoTrayIcon
#SingleInstance Force
SetWorkingDir %AHK_MY_ROOT_DIR%

If (A_Args.Length() = 1)
{
    p_word_list := A_Args[1]
    p_delimeter := ","
}
Else If (A_Args.Length() = 2)
{
    p_word_list := A_Args[1]
    p_delimeter := A_Args[2]
}
Else
{
    MsgBox, 48,, % "Missing parameter(s): p_word_list, p_delimeter"
    Return 
}

If FileExist(p_word_list)
{
    in_file := p_word_list
    FileRead words_to_add, %in_file% 
}
Else If (p_word_list.Count() == "")
    ; a delimited string was passed
    words_to_add := StrSplit(p_word_list, p_delimeter, A_Space)
Else If (p_word_list.Count() >= 0)
    ; an array has been passed
    words_to_add := p_word_list
Else    
{
    MsgBox, 48,, % "Unexpected parameter(s): `n" p_word_list "`n" p_delimeter 
    Return 
}

; word_list definition is in lib\ahk_word_lists.ahk 
ahk_word_list := {}
Loop, Parse, word_list, `n, `r
    ahk_word_list[A_LoopField] := 1

new_words := remove_duplicate_entries(words_to_add)
words_to_add := ""
For i_index, word in new_words 
{
    If (ahk_word_list[word] = 1)        ; case insensitive comparison
        OutputDebug, % "Already exists: " word
    Else
        words_to_add .= word "`n"
}
if (words_to_add == "")
{
    MsgBox, 64,, % "There are no new words to add.", 10
    ExitApp
}
;---------------------------------------------------------------
;
; Rewrite "lib\ahk_word_lists.ahk" file with updated word_list
;
;---------------------------------------------------------------
MsgBox, 292,, % "Are you sure you want to add the following words?`n`n" words_to_add
IfMsgBox, No
    ExitApp

in_file := "lib\ahk_word_lists.ahk"
FileRead in_file_var, %in_file% 

new_word_list := word_list "`n" words_to_add
Sort, new_word_list
new_in_file_var := RegExReplace(in_file_var, word_list, new_word_list)

FileDelete, %in_file%
FileAppend, %new_in_file_var%, %in_file%
SendInput !fo 
Sleep 300 
SendInput %in_file%{Enter}

ExitApp
