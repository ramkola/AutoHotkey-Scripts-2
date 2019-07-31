Global saved_category_num, saved_include_num

Gui, 2:Add, GroupBox, r5, Save to category:
Gui, 2:Add, Radio, vrad_selected_category grad_add_to_category Checked0  xp+5 y25 Group Section, Porn Sites
Gui, 2:Add, Radio, grad_add_to_category Checked0, % "TV/Movie Streaming"
Gui, 2:Add, Radio, grad_add_to_category Checked0, % "Google Search"
Gui, 2:Add, Radio, grad_add_to_category Checked0, % "News Sites"
Gui, 2:Add, Radio, grad_add_to_category Checked0, % "Misc Sites"
Gui, 2:Add, Radio, Checked1 vrad_include grad_add_to_category xs+150 ys Group, % "Include"
Gui, 2:Add, Radio, Checked0 grad_add_to_category, % "Exclude"
Gui, 2:Add, Button, gbut_add_to_category_file xm, % "&Add to File..."
Gui, 2:Add, Button, gbut_edit_category_file x+m, % "&Manually Edit File..."

but_add_to_category_file()
{
    edit_filename := get_add_to_category_filename()
    If Not FileExist(edit_filename)
        Return
    save_default_gui := A_GUI
    Gui, 1:Default  ; need for Listview functions to access lv_sites
    row_num := 0
    websites := ""
    Loop
    {
        row_num := LV_GetNext(row_num, "Checked")
        OutputDebug, % "row_num: " row_num
        If (row_num = 0)
            Break
        LV_GetText(website, row_num, 1)
        websites .= website "`r`n" 
    }
    Gui, %save_default_gui%:Default
    FileAppend, %websites%, %edit_filename%
    ; remove duplicate website names
    FileRead, in_file_var, %edit_filename%
    Sort in_file_var
    websites := RegExReplace(in_file_var, "m)^(.*?)$\s+?^(?=.*^\1$)", "")
    ; recreate file
    FileDelete, %edit_filename%
    FileAppend, %websites%, %edit_filename%
    Run, Notepad.exe %edit_filename% 
    Return
}

but_edit_category_file()
{
    edit_filename := get_add_to_category_filename()
    Run, Notepad.exe %edit_filename%
    2GuiClose()
    Return
}

2GuiEscape()
{
    2GuiClose()
    Return
}
2GuiClose()
{
    Gui, 2:Show, Hide
    Gui, 1:Show
    Return
}
    

