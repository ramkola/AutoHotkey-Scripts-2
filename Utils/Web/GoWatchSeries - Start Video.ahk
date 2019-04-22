/* 
    Monitor resolution is 1280 x 1024
    Browser zoom level should be %100 Pango %80 for imagesearch to work
*/
#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\strings.ahk
#Include lib\utils.ahk
#Include lib\constants.ahk
#Include lib\pango_level.ahk
#Include lib\trayicon.ahk
#NoTrayIcon
SetWorkingDir %AHK_ROOT_DIR%

g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk

OutputDebug, DBGVIEWCLEAR

play_streamango := True
play_serverhd := play_vidnode := play_xstreamcdn := play_streamango ? False : True

set_pango_level := play_streamango ? 80:100
current_pango_level := pango_level(set_pango_level) ? set_pango_level : 0
If Not RegExMatch(current_pango_level, "(80|100)") 
{
    MsgBox, 48,, % "Aborting....Could not set Pango to the required level (80 or 100): " current_pango_level
    Return
}
Run, MyScripts\Utils\Web\Youtube - hotkeys.ahk
    SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
SetTitleMatchMode RegEx
OutputDebug, DBGVIEWCLEAR

; wintitle examples:
;    Watch Chicago Fire - Season 2 Episode 8 English subbed - Watchseries - Google Chrome
;    Watch The Voice UK - Season 8 Episode 3- Blind Auditions 3 English subbed - Watchseries - Google Chrome ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
gowatchseries_wintitle = ^Watch.*Season \d{1,2} Episode \d{1,3}.*Watchseries - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %gowatchseries_wintitle%
WinWaitActive, %gowatchseries_wintitle%,,2
If ErrorLevel
    OutputDebug, % "ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " in " A_LineFile " | " A_ThisFunc " (" A_ScriptName ")"

; check if video is in fullscreen or not
MouseGetPos,,,,control_classnn
If (A_Args[1] == "")
    full_screen := (control_classnn = "Intermediate D3D Window1") 
Else
    full_screen := A_Args[1]

; OutputDebug, % "A_Args[1]: " A_Args[1] " - full_screen: " full_screen " - control_classnn: " control_classnn
;
; position browser to allow imagesearch to work more consistently 
WinMaximize, %gowatchseries_wintitle%
SendInput {Home}
Sleep 10
;---------------------
; start button
;---------------------
If play_serverhd or play_vidnode or play_xstreamcdn
{
    xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*10 GoWatchSeries - small screen maximized - zoom100 Pango " current_pango_level " - ServerHD Start Button.png"
        , "start", 20, 15, 3000, gowatchseries_wintitle, 50, True, True)  
    If (xy_result[1] + xy_result[1] = 0)
    {
        OutputDebug, % "ImageSearch did not find: ServerHD Start Button"
        ExitApp
    }
}
Else If play_streamango
    start_streamango(gowatchseries_wintitle, current_pango_level)

FULLSCREEN:
If full_screen
{
    OutputDebug, % "FULLSCREEN WAS EXECUTED"
    SendInput f     ;   play video in fullscreen
}

; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
OutputDebug, % "EXITAPP"
ExitApp

;--------------------------------------------------------------------------------------
; 
;   p_x1, p_y1, p_x2, p_y2, p_image - ImageSearch command parameters. p_image includes options (ie *2 *TransBlack myimage.png)
;   p_button_name - just for documentation value doesn't matter
;   p_x_offset, p_y_offset - the offset from the x,y results of the found image to where you 
;        want to click on the image. (ie Image x,y found is top left corner of button and then
;        offsets are added to x and y to click at the center of the button.
;   p_sleep - the amount of time in milliseconds to sleep after a Click is done.
;   p_wintitle - The page you expect to be on after the click is done (Regex works too) helps avoid redirects.
;   p_retry - the number of times to try imagesearch and click. Especially useful for 
;             webpages that make you click through may ads etc... before playing a video.
;   p_click - True clicks the found image. False - no click wanted (just imagesearch result needed)
;   p_image_exists_after_click_error - ie: Clicking a start video button usually makes that button
;           disappear if successful and the video starts playing. This param tells the program
;           whether to treat the existence of the image AFTER a click is an error or not.
;           True - image still exists after a click is considered and error. False it is not.
;--------------------------------------------------------------------------------------
find_and_click_button(p_x1, p_y1, p_x2, p_y2, p_image
    , p_button_name, p_x_offset, p_y_offset, p_sleep 
    , p_wintitle, p_retry := 5, p_click := True, p_image_exists_after_click_error := False)
{
    MouseMove 0,0           ; move mouse so won't interfere with imagesearch by hovering and changing colors etc...
    set_system_cursor("")   ; hide mouse (precaution even when xy=0,0) not really necessary
    x:=y:=countx:=0
    save_coords := x "," y
    ErrorLevel := 9999
    While (ErrorLevel And countx <= p_retry)
    {
        countx++
        ImageSearch, x, y, %p_x1%, %p_y1%, %p_x2%, %p_y2%, %p_image% 
        If (ErrorLevel = 0)
        {
            save_coords := x+p_x_offset "," y+p_y_offset
            MouseMove, x+p_x_offset, y+p_y_offset
            If p_click
            {
                SendEvent {Click, Left, Down}{Click, Left, Up}
                OutputDebug, % "Click: " countx
            }
            Sleep %p_sleep%
            If Not WinActive(p_wintitle)
            {
                OutputDebug, % p_wintitle " - Aborting...Clicked on wrong button or link, wrong page is active"
                ExitApp
            }
            ; if an image not disappearing after clicking it, 
            ; is considered an error, then retry clicking it.
            If p_image_exists_after_click_error
            {
                MouseMove, 0, 0
                ImageSearch, x, y, %p_x1%, %p_y1%, %p_x2%, %p_y2%, %p_image% 
                If (ErrorLevel = 0)
                    ErrorLevel = 9999   ; force retry
            }
        }
    }
    OutputDebug, % save_coords " " countx " - " A_ThisFunc " (" A_ScriptName ")"
    restore_cursors()
    Return StrSplit(save_coords, ",")
}

start_streamango(p_wintitle, p_pango_level)
{
    countx := 1 
    retries := 5
    streamango_failed := True
    While streamango_failed And (countx <= retries)
    {
        xy_result := select_server("Streamango", p_wintitle, p_pango_level)
        streamango_failed := (xy_result[1] + xy_result[2] = 0)
        countx++
        Sleep 100
    }
    If streamango_failed and countx > retries
        OutputDebug, % "Couldn't click Streamango menu server button - Line#" A_LineNumber " in " A_LineFile " | " A_ThisFunc " (" A_ScriptName ")"
    
    ; find Streamango Start button and click it
    xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 80 - Streamango Start Button.png"
        , "Streamango Start Button", 3, 3, 1500
        , p_wintitle, 10, True, True)
    OutputDebug, % "Streamango start button xy_result: " xy_result[1] "," xy_result[2] " - " A_ThisFunc " - Line#" A_LineNumber " - " A_ScriptName
}

select_server(p_server_name,p_wintitle, p_pango_level)
{
    If (p_server_name == "") Or (p_wintitle == "")
    {
        OutputDebug, % "p_server_name: " p_server_name " - " A_ThisFunc " - Line#" A_LineNumber " - " A_ScriptName
        OutputDebug, % "p_wintitle: " p_wintitle " - " A_ThisFunc " - Line#" A_LineNumber " - " A_ScriptName
        Return
    }
        
    ; find server menu and click it
    xy_result := find_and_click_button(A_ScreenWidth * .5 , 0, A_ScreenWidth, A_ScreenHeight *.5
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango " p_pango_level " - menu button.png"
        , "Server Menu", 10, 5, 10
        , p_wintitle, 5, True, False)
    If (xy_result[1] + xy_result[2] = 0)
    {
        OutputDebug, % "ImageSearch did not find - menu button.  - " A_ThisFunc " - Line#" A_LineNumber " - " A_ScriptName
        ExitApp
    }    
SELECT_SERVER:
    ; find Streamango server menu option and click it
    xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango " p_pango_level " - menu Streamango.png"
        , "Streamango", 10, 1, 10
        , p_wintitle, 5, True, False)
    Return xy_result
}

^+k:: list_hotkeys()