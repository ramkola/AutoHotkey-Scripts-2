#SingleInstance Force
#Include %A_ScriptDir%
#Include Lib.ahk

OutputDebug, DBGVIEWCLEAR

p_url := A_Args[1]
If (p_url == "")
{
    MsgBox, 48,, % "No website has focus"
    Return
}

get_chrome_history("Select title, url, id from urls where url like ""%://" p_url "%"" order by id;")
links := []
get_links(links)

Gui, Add, ListView, vlv_links glv_links w300 r20 Checked Sort AltSubMit Multi,TITLE|URL|DB_ID
Loop, % links.Count()
    LV_Add("", links[A_Index, 1], links[A_Index, 2], links[A_Index, 3])
GuiControlGet, lv_links, POS
LV_ModifyCol(1,lv_linksw)
LV_ModifyCol(2,100)
LV_ModifyCol(3,100)
Gui , +AlwaysOnTop
Gui, Show, , Manage Website Links
Return

lv_links(ctrl_hwnd:=0, gui_event:="", event_info:="", error_level:="")
{
    Return
}

GuiEscape:
GuiClose:
    ExitApp
    
get_links(links)
{
    Loop, Read, results.csv
    {
        line_num := A_Index
        Loop, parse, A_LoopReadLine, CSV
            links[line_num, A_Index] := A_LoopField
    }
    Return
}
