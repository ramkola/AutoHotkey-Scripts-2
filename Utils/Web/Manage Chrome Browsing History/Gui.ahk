#Include Gui - AddTo.ahk
Global but_mark_hwnd, but_unmark_hwnd, lv_sites_hwnd
Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\Resources\32x32\History-01.png
;-------------------------------------- 
; GUI - Default Chrome Browser History
;-------------------------------------- 
; column 1 controls
Gui, Font, s8, MS Sans Serif
Gui, Add, Radio, Checked0 grad_filter vrad_filter_selected x10 y20 Group, Selected
Gui, Add, Radio, Checked0 grad_filter vrad_filter_checked x+m, Checkmarked
Gui, Add, Radio, Checked0 grad_filter vrad_filter_selected_checked x+m, Both
Gui, Add, Radio, Checked1 grad_filter vrad_filter_none x+m, None 
GuiControlGet, rad_filter_none, Pos
gb_y := rad_filter_noneY - 20
gb_w := rad_filter_noneX + rad_filter_noneW
Gui, Add, GroupBox, vgb_filter x3 y%gb_y% w%gb_w% r1, Filter Websites
; Gui, Add, Checkbox, vchk_selected_status gchk_selected_only, &Selected only
Gui, Font, s16, Consolas
Gui, Add, ListView, vlv_sites glv_sites hwndlv_sites_hwnd x3 w300 r20 Checked Sort AltSubMit Multi,Website|selected|checkmarked
Gui, Font, s8, MS Sans Serif
Gui, Add, Button, vbut_visit_site gbut_visit_site Default w80, &Visit Site 
Gui, Add, Button, vbut_add_to gbut_add_to x+m wp, &Add to...
Gui, Add, Button, vbut_refresh_history gbut_refresh_history x+m wp, &Refresh
GuiControlGet, lv_sites, Pos
; LV_ModifyCol(1,lv_sitesW)
LV_ModifyCol(1,200)
LV_ModifyCol(2,30)
LV_ModifyCol(3,30)
; column 2 controls
col2_x := lv_sitesX + lv_sitesW + 10
Gui, Font, s8 w400, MS Sans Serif
Gui, Add, GroupBox, vgb_select_by_category x%col2_x% y%lv_sitesY% r9, Select by Category
Gui, Add, Checkbox, vchk_porn xp+10 yp+25, Porn Sites
Gui, Add, Checkbox, vchk_streaming, TV/Movie Streaming
Gui, Add, Checkbox, vchk_google_search, Google Search
Gui, Add, Checkbox, vchk_news, News Sites
Gui, Add, Checkbox, vchk_misc, Misc Sites
Gui, Add, Button, vbut_mark gbut_mark hwndbut_mark_hwnd yp+50 w50, &Mark
Gui, Add, Button, vbut_unmark gbut_unmark hwndbut_unmark_hwnd xp+53 yp wp, &Unmark
;
GuiControlGet, gb_select_by_category, Pos
but_focused_y := gb_select_by_categoryY + gb_select_by_categoryH + 25
Gui, Add, Button, vbut_focused_website_links gbut_focused_website_links x%col2_x% y%but_focused_y% +Wrap, Manage &focused website's links
Gui, Add, Button, vbut_clear_all gbut_clear_all wp, % "&Clear All Select && Checked"
Gui, Add, Button, vbut_save_changes_to_chrome gbut_save_changes_to_chrome wp, % "&Save Changes To Chrome"
Gui, Add, Button, vbut_delete_website gbut_delete_website r3 wp +Wrap, % "&Delete Website History"

;------------------------------------------------------------------------
; GUI - Default Event Procedures
;------------------------------------------------------------------------
but_delete_website(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    sql_delete_cmds := ""
    row_num := 0
    countx := 0
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked")
        If (row_num = 0)
            Break
        LV_GetText(website, row_num, 1)
        sql_delete_cmds .= "`r`nDELETE FROM urls WHERE url LIKE " chr(34) "%" website "%" chr(34) ";"
        countx++
    }
    sql_delete_cmds := SubStr(sql_delete_cmds, 3)   ; remove leading CRLF
    If (countx = 0)
        MsgBox, 64,, % "No websites are marked.`r`nNothing was done."
    Else
    {
        osqlite.Exec("BEGIN TRANSACTION;")
        If !osqlite.Exec(sql_delete_cmds)
        {           
            osqlite.Exec("ROLLBACK;")
            MsgBox, 16, Aborting - SQLite Error, % "Msg:`t" . osqlite.ErrorMsg . "`nCode:`t" . osqlite.ErrorCode
        }
        Else
        {
            osqlite.Exec("COMMIT TRANSACTION;")
            changes_made := True
            sql_query_results := ""     ; returned sql "view" object from the following query
            If !osqlite.GetTable("SELECT url FROM urls;", sql_query_results)
                MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . osqlite.ErrorMsg . "`nCode:`t" . osqlite.ErrorCode
            show_websites()
            MsgBox, 64, Success, % sql_delete_cmds
        }
    }   
    Return
}

but_save_changes_to_chrome()
{
    Return
}

but_mark(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    select_by_category(True)
    MsgBox, 64,, % "Done", 1
    ; GuiControl,, chk_porn, 0
    ; GuiControl,, chk_streaming, 0
    ; GuiControl,, chk_google_search, 0
    ; GuiControl,, chk_news, 0
    ; GuiControl,, chk_misc, 0
    Return
}

but_unmark(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    select_by_category(False)
    MsgBox, 64,, % "Done", 1
    ; GuiControl,, chk_porn, 0
    ; GuiControl,, chk_streaming, 0
    ; GuiControl,, chk_google_search, 0
    ; GuiControl,, chk_news, 0
    ; GuiControl,, chk_misc, 0
    Return
}

lv_sites(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
; OutputDebug, DBGVIEWCLEAR
; OutputDebug, % "ctrl_hwnd: " ctrl_hwnd ", gui_event: " gui_event 
           ; .   ", event_info: " event_info ", error_level: " error_level
; OutputDebug, % "but_mark_hwnd: " but_mark_hwnd ", but_mark_hwnd: " but_unmark_hwnd ", lv_sites_hwnd: " lv_sites_hwnd
    Critical
    If (gui_event = "DoubleClick")
        but_visit_site()
    If (gui_event == "I")
    {
        ; Toggle checkbox
        If InStr(error_level, "C", False)
        {
            row_num := 0
            Loop
            {
                row_num := LV_GetNext(row_num)  ; for every selected row 
                If (row_num = 0)
                    Break
                Else
                {
                    check_flag := InStr(error_level, "C", True)
                    LV_Modify(row_num, check_flag ? "Check":"-Check")
                    LV_GetText(website, row_num, 1)
                    LV_Modify(row_num,, website, True, check_flag)
                }
            }
        }           
    }           
    Return
}

but_refresh_history(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    get_chrome_history()
    show_websites()
    Return
}

but_clear_all(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    save_current_row_num := LV_GetNext(0, "Focused")
    save_current_row_num := (save_current_row_num = 0) ? 1 : save_current_row_num
    LV_Modify(0, "-Select -Check")
    GuiControl, Focus, lv_sites
    LV_Modify(save_current_row_num, "+Focus +Select")
    LV_Modify(save_current_row_num, "Vis")
    Return
}

but_visit_site(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    row_num := LV_GetNext(0, "Focused")
    If (row_num = 0)
        Return
    LV_GetText(url, row_num, 1)
    Run, ..\Activate Browser.ahk %False% %True% %url%    
}

but_add_to(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Gui,2:+AlwaysOnTop +ToolWindow
    Gui, 2:Show,, Add To
    Return
}
