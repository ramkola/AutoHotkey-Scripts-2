Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\Resources\32x32\History-01.png
;-------------------------------------- 
; GUI - Default Chrome Browser History
;-------------------------------------- 
; column 1 controls
Gui, Font, s8 w700, MS Sans Serif
Gui, Add, Checkbox, vchk_selected_status gchk_selected_only, &Selected only
Gui, Font, s16 w400, Consolas
Gui, Add, ListView, vlv_sites glv_sites w300 r20 Checked Sort AltSubMit Multi,URL|Name
Gui, Font, s8 w700, MS Sans Serif
Gui, Add, Button, vbut_visit_site gbut_visit_site Default w80, &Visit Site 
Gui, Add, Button, vbut_add_to gbut_add_to x+m wp, &Add to...
Gui, Add, Button, vbut_refresh_history gbut_refresh_history x+m wp, &Refresh

; column 2 controls
GuiControlGet, lv_sites, Pos
col2_x := lv_sitesX + lv_sitesW + 10
Gui, Font, s8 w400, MS Sans Serif
Gui, Add, GroupBox, vgb_select_by_category x%col2_x% y%lv_sitesY% r7, Select by Category
Gui, Add, Checkbox, vchk_porn xp+10 yp+25, Porn Sites
Gui, Add, Checkbox, vchk_streaming, TV/Movie Streaming
Gui, Add, Checkbox, vchk_google_search, Google.ca Search
Gui, Add, Button, vbut_mark gbut_mark yp+50 w50, &Mark
Gui, Add, Button, vbut_unmark gbut_unmark xp+53 yp wp, &Unmark

GuiControlGet, gb_select_by_category, Pos
but_focused_y := gb_select_by_categoryY + gb_select_by_categoryH + 25
Gui, Add, Button, vbut_focused_website_links gbut_focused_website_links x%col2_x% y%but_focused_y% +Wrap, Manage &focused website's links
;
LV_ModifyCol(1,lv_sitesW)
LV_ModifyCol(2,10)
    
;------------------------------- 
; GUI 2 - Add to...
;------------------------------- 
Gui, 2:Add, GroupBox, r4, Add marked websites to:
Gui, 2:Add, Radio, Checked0 vrad_porn xp+5 y25 Group, Porn
Gui, 2:Add, Radio, Checked0 vrad_porn1, Porn1
Gui, 2:Add, Radio, Checked0 vrad_porn2, Porn2
Gui, 2:Add, Radio, Checked0 vrad_porn3, Porn3
Gui, 2:Add, Button, vbut_add gbut_add, &Add
Gui, 2:Add, Button, vbut_cancel gbut_cancel, &Cancel

;------------------------------------------------------------------------
; GUI - Default Event Procedures
;------------------------------------------------------------------------
lv_sites(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Critical
    If (gui_event = "DoubleClick")
        but_visit_site()
    If (gui_event == "I" and Instr(ErrorLevel, "C", False))
    {
        action := InStr(ErrorLevel, "C", True) ? "Check" : "-Check"
        row_num := 0
        Loop
        {
            row_num := LV_GetNext(row_num)
            If (row_num = 0)
                Break
            Else
                LV_Modify(row_num, action)
        }           
    }
    Return
}


but_refresh_history()
{
    LV_Delete()
    websites := []
    get_chrome_history("Select url from urls;")
    get_websites(websites)
    ; initialize listview
    For i, j In websites
        LV_ADD("",j)
    Return
}
;---------------------------------
; GUI - 2 Add to Event Procedures
;---------------------------------
but_add(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    ; GUI 2 - Add to
    GuiControlGet, rad_porn
    GuiControlGet, rad_porn1
    GuiControlGet, rad_porn2
    GuiControlGet, rad_porn3
    Return
}

but_cancel(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    ; GUI 2 - Cancel
    GoSub 2GuiClose
    Return
}
