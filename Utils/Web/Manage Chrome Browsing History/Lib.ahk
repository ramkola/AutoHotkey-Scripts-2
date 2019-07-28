;------------------------------------------
;  Subroutines - Functions, Procedures
;------------------------------------------
is_lvrow_selected(p_row_num, p_text_flag := True)
{
    row_num := LV_GetNext(p_row_num - 1)
    If p_text_flag
        Return (row_num = p_row_num ? "Select" : "-Select")
    Else
        Return (row_num = p_row_num)
}

is_lvrow_checked(p_row_num, p_text_flag := True)
{
    row_num := LV_GetNext(p_row_num - 1, "Checked")
    If p_text_flag
        Return (row_num = p_row_num ? "Check" : "-Check")
    Else
        Return (row_num = p_row_num)
}

get_chrome_history()
{
    source = C:\Users\Mark\AppData\Local\Google\Chrome\User Data\Default\History
    dest = History.db
    FileDelete, %dest%
    FileCopy, %source%, %dest%, 1
    If ErroLevel
    {
        MsgBox, % "ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
        exit_func()
    }
    If !osqlite.OpenDB(dest) 
    {
       MsgBox, 16, SQLite Error, % "Msg:`t" . osqlite.ErrorMsg . "`nCode:`t" . osqlite.ErrorCode
       exit_func()
    }
    sql_query_results := ""     ; returned sql "view" object from the following query
    If !osqlite.GetTable("SELECT url FROM urls;", sql_query_results)
       MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . osqlite.ErrorMsg . "`nCode:`t" . osqlite.ErrorCode
    Return
}

show_websites()
{
    ; sql_query_results is an sql "view" created in get_chrome_history()
    ; get list of urls
    websites := []
    If (sql_query_results.HasRows) 
    {
        Loop, % sql_query_results.RowCount 
        {
            sql_query_results.Next(record)
            websites.push(record[1])
        }
    }   
    ; remove all unnecessary data in url field to get to website name
    For i_index, website_url in websites
    {
        website := RegExReplace(website_url, "i)^(.*?)://(.*?)/.*$","$2",1)
        website := RegExReplace(website, "i)^ww.*?\.(.*)$", "$1", replaced_count)
        websites_temp .= website "`r`n"
    }
    ; remove duplicate website names
    Sort websites_temp
    websites_string := RegExReplace(websites_temp, "m)^(.*?)$\s+?^(?=.*^\1$)", "")
    ; display unique websites in lv_sites
    GuiControl, -ReDraw, lv_sites
    LV_Delete()
    Loop, Parse, websites_string, `n, `r
    {
        If (A_LoopField != "")
            LV_Add("",A_LoopField, False, False)
    }
    GuiControl, +ReDraw, lv_sites
    Return
}
