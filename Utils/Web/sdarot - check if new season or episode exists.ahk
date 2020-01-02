#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
Global g_debug_switch := True

new_season_list = 
(Join`r`n
href="/watch/1071-מאסטר-שף-ישראל-master-chef-israel/season/9">9</a>
href="/watch/600-האח-הגדול-ha-ah-hagadol/season/11">11</a>
href="/watch/1647-האח-הגדול-vip-ha-ah-hagadol-vip/season/4">4</a>
href="/watch/1004-הישרדות-ישראל-survivor-il/season/10">10</a>
href="/watch/4655-המדובב-hamedovev/season/2">2</a>
href="/watch/4260-עיר-מקלט-ir-miklat/season/2">2</a>
href="/watch/5076-הנספח-hanisfach/season/2">2</a>
href="/watch/4147-mkr-המטבח-המנצח-mkr-hamitbah-hamenatseah/season/2">2</a>
href="/watch/3445-גוט-טאלנט-ישראל-got-talent-israel/season/3">3</a>
href="/watch/750-דה-וויס-ישראל-the-voice-israel/season/6">6</a>
href="/watch/1178-משחקי-השף-mishakei-ha-chef/season/5">5</a>
)

new_episode_list = 
(Join`r`n
href="/watch/825-הכוכב-הבא-hakochav-haba/season/7/episode/21">21</a>
)

output_debug("DBGVIEWCLEAR")
Clipboard := ""

url_prefix = https://www.sdarot.pm/watch/
season_link_prefix = <a class="text-center"
season_link_prefix .= A_Space 
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
/* 
    ******************
    *** New Season ***
    ******************
*/
new_season_array := StrSplit(new_season_list, "`n", "`r")
For i_ndx, href In new_season_array
{
    new_season_string_english := RegExReplace(href, "i)href=""/watch/\d+-[^a-z]*-([a-z\-]*/season/\d+.*</a>)", "$1")
    program_number := RegExReplace(href, "i)href=""/watch/(\d+)-.*</a>", "$1")
    new_season_url := url_prefix program_number
    whr.Open("GET", new_season_url, true)
    whr.Send()
    whr.WaitForResponse()
    If RegExMatch(whr.ResponseText, new_season_string_english)
    {
        msg := "*** New season found: " new_season_string_english, 1
        output_debug(msg)
        MsgBox, 48,, % msg
    }
}
/* 
    *******************
    *** New Episode ***
    *******************
*/
new_episode_array := StrSplit(new_episode_list, "`n", "`r")
For i_ndx, href In new_episode_array
{
    season_url := RegExReplace(href, "i)href=""/watch/(\d+-[^a-z]*-[a-z\-]*/season/\d+)/episode/\d+.*</a>", "$1")
    new_episode_string_english := RegExReplace(href, "i)href=""/watch/\d+-[^a-z]*-([a-z\-]*/season/\d+/episode/\d+.*</a>)", "$1")
    whr.Open("GET", url_prefix season_url, true)
    whr.Send()
    whr.WaitForResponse()
    If RegExMatch(whr.ResponseText, new_episode_string_english)
    {
        msg := "*** New episode found: " new_episode_string_english, 1
        output_debug(msg)
        MsgBox, 48,, % msg
    }
}

If g_debug_switch
{
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
}

ExitApp