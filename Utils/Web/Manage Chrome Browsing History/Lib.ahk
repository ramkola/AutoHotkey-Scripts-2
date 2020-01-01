;------------------------------------------
;  Subroutines - Functions, Procedures
;------------------------------------------
set_select_by_category_checkboxes(p_check)
{
    GuiControl,, chk_porn, %p_check%
    GuiControl,, chk_streaming, %p_check%
    GuiControl,, chk_google_search, %p_check%
    GuiControl,, chk_news, %p_check%
    GuiControl,, chk_misc, %p_check%
    Return
}

select_by_regex_search()
{
    set_select_by_category_checkboxes(0)
    ; GuiControl, -Redraw, lv_sites
    GuiControl,, rad_filter_none, 1
    rad_filter()
    LV_Modify(0, "-Select -Check")
    GuiControlGet, edt_regex_search
    row_num := 1
    Loop, % LV_GetCount()
    {
        LV_GetText(website, row_num, 1)
        If RegExMatch(website, ".*" edt_regex_search ".*")
        {
            sleep 1
            LV_Modify(row_num, "+Select +Check")
        }
        row_num++
        ; LV_Modify(row_num, "Vis")
    }
    If (LV_GetCount("Selected") = 0)
    {
        MsgBox, 48,, % "Nothing found for search term: " edt_regex_search, 3
        GuiControl,, rad_filter_none, 1
        rad_filter()
    }
    Else
    {
        GuiControl,, rad_filter_both, 1
        rad_filter()
    }
    ; GuiControl, +Redraw, lv_sites
    Return
}

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

select_by_category(p_control_name, p_check_mark)
{
    ; output_debug("p_control_name: " p_control_name " - p_check_mark: " p_check_mark)

    If (p_control_name = "chk_porn") 
        category_filename = zzdata_porn_sites_included.txt
    If (p_control_name = "chk_streaming")
        category_filename = zzdata_streaming_sites_included.txt
    If (p_control_name = "chk_google_search")
        category_filename = zzdata_google_sites_included.txt
    If (p_control_name = "chk_news")
        category_filename = zzdata_news_sites_included.txt
    If (p_control_name = "chk_misc")
        category_filename = zzdata_misc_sites_included.txt       
    FileRead, websites_include_list, %category_filename% 
    GuiControl,, rad_filter_none, 1
    rad_filter()
    Loop, Parse, websites_include_list, `n, `r
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
                If p_check_mark
                    LV_Modify(row_num, "+Select +Check")
                Else
                    LV_Modify(row_num, "+Select -Check")
                Break
            }
            Else If (website > website_included)
            {
                Break
            }
        }
    }
    If p_check_mark
        GuiControl,, rad_filter_both, 1
    Else If Not p_check_mark
        GuiControl,, rad_filter_selected, 1
    rad_filter()
    Return
}

save_changes_to_chrome()
{
    source := A_WorkingDir "\History.db"
    dest = C:\Users\Mark\AppData\Local\Google\Chrome\User Data\Default\History
    If changes_made
    {
        Loop
        {
            FileCopy, %source%, %dest%, 1
            If (ErrorLevel = 0)
            {
                changes_made := False
                MsgBox, 64, Success, % "Changes saved to Chrome history."
                Break
            }
            Else
            {
                MsgBox, 37, % "Filecopy Failed"
                    , % "Could not save changes to Chrome history.`r`n`r`n"
                    . "Close Chrome browser windows and check that there are no background processes running.`r`n`r`n"
                    . "ErrorLevel: " ErrorLevel "  A_LastError: "  A_LastError
                IfMsgBox, Cancel
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
