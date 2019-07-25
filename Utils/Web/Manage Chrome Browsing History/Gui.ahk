Menu, Tray, Icon, C:\Users\Mark\Desktop\Misc\Resources\32x32\History-01.png
;------------------------------- 
; GUI - Chrome Browser History
;------------------------------- 
; column 1 controls
Gui, Font, s8 w700, MS Sans Serif
Gui, Add, Checkbox, vchk_selected_status gchk_selected_only, &Selected only
Gui, Font, s16 w400, Consolas
Gui, Add, ListView, vlv_sites glv_sites r20 Checked Sort AltSubMit Multi,URL|Name
Gui, Font, s8 w700, MS Sans Serif
Gui, Add, Button, vbut_visit_site gbut_visit_site Default w80, &Visit Site 
Gui, Add, Button, vbut_add_to gbut_add_to x+m wp, &Add to...

; column 2 controls
GuiControlGet, lv_sites, Pos
col2_x := lv_sitesX + lv_sitesW + 10
Gui, Font, s8 w400, MS Sans Serif
Gui, Add, GroupBox, x%col2_x% y%lv_sitesY% r5, Select by Category
Gui, Add, Checkbox, vchk_porn xp+10 yp+25, Porn
Gui, Add, Button, vbut_mark gbut_mark yp+50 w50, &Mark
Gui, Add, Button, vbut_unmark gbut_unmark xp+53 yp wp, &Unmark
LV_ModifyCol(1,lv_sitesW)
LV_ModifyCol(2,10)
    
;------------------------------- 
; GUI -  Add to...
;------------------------------- 
Gui, 2:Add, GroupBox, r4, Add marked websites to:
Gui, 2:Add, Radio, Checked0 vrad_porn xp+5 y25 Group, Porn
Gui, 2:Add, Radio, Checked0 vrad_porn1, Porn1
Gui, 2:Add, Radio, Checked0 vrad_porn2, Porn2
Gui, 2:Add, Radio, Checked0 vrad_porn3, Porn3
