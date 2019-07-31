;------------------------------------------
;  Subroutines - Functions, Procedures
;------------------------------------------
get_add_to_category_filename()
{
    category_filename_prefixes := ["porn", "streaming", "google", "news", "misc"]
    category_name := category_filename_prefixes[saved_category_num]
    inc_name := (saved_include_num = 1) ? "included" : "excluded"
    edit_filename := "zzdata_" category_name "_sites_" inc_name ".txt"
    If FileExist(edit_filename)
        Return edit_filename
    Else
    {
        MsgBox, 48,, % "File does not exist: " edit_filename
        Return
    }
}

select_by_category(p_mark)
{
    GuiControlGet, chk_porn
    GuiControlGet, chk_streaming
    GuiControlGet, chk_google_search
    GuiControlGet, chk_news
    GuiControlGet, chk_misc
    If chk_porn 
        FileRead, porn_sites_included, zzdata_porn_sites_included.txt
    If chk_streaming
        FileRead, streaming_sites_included, zzdata_streaming_sites_included.txt
    If chk_google_search
        FileRead, google_sites_included, zzdata_google_sites_included.txt
    If chk_news
        FileRead, news_sites_included, zzdata_news_sites_included.txt
    If chk_misc
        FileRead, misc_sites_included, zzdata_misc_sites_included.txt      
    
    select_include_list := porn_sites_included "`r`n" streaming_sites_included "`r`n" 
        . google_sites_included "`r`n" news_sites_included "`r`n" misc_sites_included

    LV_Modify(0, "-Focus -Select")
    Sort select_include_list
    Loop, Parse, select_include_list, `n, `r
    {
        website_included := A_LoopField
        If (website_included == "")
            Continue
        row_num := 1
        Loop
        {
            LV_GetText(website, row_num, 1)
            If (website < website_included)
            {
                row_num++
                Continue
            }
            Else If (website = website_included)
            {
                If p_mark
                    LV_Modify(row_num, "+Select +Check")
                Else
                    LV_Modify(row_num, "-Select -Check")
                Break
            }
            Else If (website > website_included)
            {
                Break
            }
        }
    }
    Return
}
    
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
