#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
Global g_debug_switch := True

; make sure the season and 2 episode fields are filled in correctly.
new_episode_list = 
(Join`r`n
href="/watch/1071-מאסטר-שף-ישראל-master-chef-israel/season/9/episode/1">1</a>
href="/watch/1647-האח-הגדול-vip-ha-ah-hagadol-vip/season/4/episode/1">1</a>
href="/watch/1004-הישרדות-ישראל-survivor-il/season/10/episode/1">1</a>
href="/watch/4655-המדובב-hamedovev/season/2/episode/1">1</a>
href="/watch/4260-עיר-מקלט-ir-miklat/season/2/episode/1">1</a>
href="/watch/5076-הנספח-hanisfach/season/2/episode/1">1</a>
href="/watch/4147-mkr-המטבח-המנצח-mkr-hamitbah-hamenatseah/season/2/episode/1">1</a>
href="/watch/3445-גוט-טאלנט-ישראל-got-talent-israel/season/3/episode/1">1</a>
href="/watch/750-דה-וויס-ישראל-the-voice-israel/season/6/episode/1">1</a>
href="/watch/1178-משחקי-השף-mishakei-ha-chef/season/5/episode/1">1</a>
href="/watch/825-הכוכב-הבא-hakochav-haba/season/7/episode/21">21</a>
href="/watch/600-האח-הגדול-ha-ah-hagadol/season/10/episode/1">1</a>
href="/watch/1508-פאודה-fauda/season/3/episode/1">1</a>
)

; new_episode_list = 
; (Join`r`n
; href="/watch/5076-הנספח-hanisfach/season/1/episode/1">1</a>
; href="/watch/825-הכוכב-הבא-hakochav-haba/season/6/episode/21">21</a>
; href="/watch/600-האח-הגדול-ha-ah-hagadol/season/9/episode/1">1</a>
; href="/watch/1508-פאודה-fauda/season/3/episode/1">1</a>
; )
output_debug("DBGVIEWCLEAR")
url_prefix = https://www.sdarot.pm/watch/
season_link_prefix = <a class="text-center"
season_link_prefix .= A_Space 
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
/* 
    *******************
    *** New Episode ***
    *******************
*/
msg := ""
new_episode_array := StrSplit(new_episode_list, "`n", "`r")
For i_ndx, href In new_episode_array
{
    season_url := RegExReplace(href
        , "i)href=""/watch/(\d+-[a-z]*[^a-z]+-[a-z\-]+/season/\d+)/episode/\d+.*</a>", "$1")
    new_episode_string_english := RegExReplace(href
        , "i)href=""/watch/\d+-[a-z]*[^a-z]+-([a-z\-]+/season/\d+/episode/\d+.*</a>)", "$1")
    whr.Open("GET", url_prefix season_url, true)
    whr.Send()
    whr.WaitForResponse()
    If RegExMatch(whr.ResponseText, new_episode_string_english)
        msg .= "New Episode: " new_episode_string_english "`r`n"
}

If (msg == "")
    MsgBox, 64,, % "No new episodes found.", 3
Else
{
    output_debug(msg)
    MsgBox, 64,, % msg
}

If g_debug_switch and (msg <> "")
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe

ExitApp
