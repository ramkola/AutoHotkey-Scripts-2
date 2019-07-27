;------------------------------------------
;  Subroutines - Functions, Procedures
;------------------------------------------
is_lvrow_selected(p_row_num)
{
    row_num := LV_GetNext(p_row_num - 1)
    Return (row_num = p_row_num ? "Select" : "-Select")
}

is_lvrow_checked(p_row_num)
{
    row_num := LV_GetNext(p_row_num - 1, "Checked")
    Return (row_num = p_row_num ? "Check" : "-Check")
}

get_chrome_history(p_sql_query)
{
    source = C:\Users\Mark\AppData\Local\Google\Chrome\User Data\Default\History
    ; dest := A_WorkingDir "\History.db"
    dest = History.db
    FileDelete, %dest%
    FileCopy, %source%, %dest%, 1
    If ErroLevel
    {
        MsgBox, % "ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
        exit_func()
    }
    ; sqlite3.exe filename format (with quotes and forward slashes)
    sqlite3_working_dir := chr(34) StrReplace(A_WorkingDir, "\", "/") chr(34)
    sqlite3_history_db := chr(34) StrReplace(dest, "\", "/") chr(34)
    
    delete_file("commands.txt")
    delete_file("results.csv")
    write_string = 
    (Ltrim Join`r`n
        .cd %sqlite3_working_dir%
        .open %sqlite3_history_db%
        .mode csv
        .once results.csv
        %p_sql_query%
        .exit
    )
    FileAppend, %write_string%, commands.txt
    If Not FileExist("commands.txt") 
    {
        MsgBox, 48, % "Aborting", % "Could not create file: commands.txt"
        Return
    }

    cmd_wintitle = ahk_class ConsoleWindowClass ahk_exe cmd.exe
    If Not WinExist(cmd_wintitle)
    {
        Run, %A_ComSpec%
        WinWaitActive, %cmd_wintitle%,,5
        WinSetTitle, %cmd_wintitle%,, Sqlite3
        WinMove, %cmd_wintitle%,, 100, 100, 200, 100 
    }
    Else
    {
        WinActivate, %cmd_wintitle%
        WinWaitActive, %cmd_wintitle%,,1
    }
    If WinActive(cmd_wintitle)
    {
        SendInput c:\sqlite\sqlite3.exe < commands.txt{Enter}
        While Not FileExist("results.csv")
            Sleep 10
    }
    Else
    {
        MsgBox, 48, % "Aborting", % "Could not run cmd.exe for sqlite."
        exit_func()
    }

    If Not FileExist("results.csv")
    {
        MsgBox, 48, % "Aborting", % "sqlite3 did not produce: results.csv`r`n" A_WorkingDir 
        exit_func()
    }
    Return
}

delete_file(p_filename)
{
    FileDelete, %p_filename%
    If FileExist(p_filename) 
    {
        MsgBox, 48, % "Aborting", % "Could not delete file: " p_filename
        exit_func()
    }
    Return
}

get_websites(websites)
{
    FileRead, in_file_var, results.csv
    Loop, Parse, in_file_var, `n, `r
    {
        website := RegExReplace(A_LoopField, "i)^(.*?)://(.*?)/.*$","$2",1)
        website := RegExReplace(website, "i)^ww.*?\.(.*)$", "$1", replaced_count)
        if replaced_count
            OutputDebug, % website " = " A_LoopField
        
        websites_temp .= website "`r`n"
    }
    ; remove duplicate entries
    Sort websites_temp
    websites_string := RegExReplace(websites_temp, "m)^(.*?)$\s+?^(?=.*^\1$)", "")
    ; return array of unique website entries
    Loop, Parse, websites_string, `n, `r
        If (A_LoopField != "")
            websites.push(A_LoopField)
    Return
}
