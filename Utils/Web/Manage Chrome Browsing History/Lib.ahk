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
    chrome_wintitle = ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
    If WinExist(chrome_wintitle)
    {
        MsgBox, 36, % "Chrome Running", % "Chrome browser is running.`r`n`r`nOk to close all browser windows?"
        IfMsgBox, Yes
            While WinExist(chrome_wintitle)
                WinClose
        IfMsgBox, No
            ExitApp
    }
    
    sqlite3_working_dir := chr(34) StrReplace(A_WorkingDir, "\", "/") chr(34)
    history_db = "C:/Users/Mark/Desktop/History.db"  ; sqlite3.exe filename format (with quotes and forward slashes)
    
    delete_file("commands.txt")
    delete_file("results.csv")
    write_string = 
    (Ltrim Join`r`n
        .cd %sqlite3_working_dir%
        .open %history_db%
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
    Run, %A_ComSpec%
    WinWaitActive, ahk_class ConsoleWindowClass ahk_exe cmd.exe,,5
    SendInput c:\sqlite\sqlite3.exe < commands.txt{Enter}
    Sleep 2000
    WinClose, ahk_class ConsoleWindowClass ahk_exe cmd.exe   
    If Not FileExist("results.csv")
    {
        MsgBox, 48,, % "sqlite3 did not produce: results.csv"
        ExitApp
    }
    Return
}

delete_file(p_filename)
{
    FileDelete, %p_filename%
    If FileExist(p_filename) 
    {
        MsgBox, 48, % "Aborting", % "Could not delete file: " p_filename
        ExitApp
    }
    Return
}

get_websites(websites)
{
    FileRead, in_file_var, results.csv
    Loop, Parse, in_file_var, `n, `r
    {
        website := RegExReplace(A_LoopField, "i)^(.*?)://(.*?)/.*$","$2",1)
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
