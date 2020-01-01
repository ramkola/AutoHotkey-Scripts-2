#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
Global g_debug_switch := True
output_debug("DBGVIEWCLEAR")

new_season_list = 
(Join`r`n
href="/watch/1071-מאסטר-שף-ישראל-master-chef-israel/season/9">9</a>
href="/watch/600-האח-הגדול-ha-ah-hagadol/season/10">10</a>
href="/watch/1647-האח-הגדול-vip-ha-ah-hagadol-vip/season/4">4</a>
href="/watch/1004-הישרדות-ישראל-survivor-il/season/10">10</a>
href="/watch/4655-המדובב-hamedovev/season/2">2</a>
href="/watch/4260-עיר-מקלט-ir-miklat/season/2">2</a>
href="/watch/5076-הנספח-hanisfach/season/2">2</a>
href="/watch/4147-mkr-המטבח-המנצח-mkr-hamitbah-hamenatseah/season/2">2</a>
href="/watch/3445-גוט-טאלנט-ישראל-got-talent-israel/season/3">3</a>
href="/watch/750-דה-וויס-ישראל-the-voice-israel/season/6">6</a>
)

url_prefix = https://www.sdarot.pm/watch/
season_link_prefix = <a class="text-center"
season_link_prefix .= A_Space 
new_season_array := StrSplit(new_season_list, "`n", "`r")
For i, j In new_season_array
{
    output_debug(Format("{:02}) {}", i, j), True)
}


If g_debug_switch
{
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
}

ExitApp