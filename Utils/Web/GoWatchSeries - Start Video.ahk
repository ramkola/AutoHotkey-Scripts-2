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
;g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetRegView 64
SetWorkingDir %AHK_ROOT_DIR%
Run, MyScripts\Utils\Web\Video (youtube) Remote Mouse Control.ahk

Global g_debug_switch := True
Global rad_server_num := 3
Global chk_do_not_ask_again := True    ; prompt for preferred server....
Global server_name := ""
RegRead, server_name, HKEY_CURRENT_USER, SOFTWARE\MyAHKScripts\GoWatchSeries, PreferredServerName
If ErrorLevel
    MsgBox, % "RegRead - PreferredServerName - ErrorLevel: " ErrorLevel " - A_LastError: " A_LastError
RegRead, chk_do_not_ask_again, HKEY_CURRENT_USER, SOFTWARE\MyAHKScripts\GoWatchSeries, PromptPrefferedServer
If ErrorLevel
    MsgBox, % "RegRead - PromptPrefferedServer - ErrorLevel: " ErrorLevel " - A_LastError: " A_LastError

set_pango_level := pango_level(100)
; OutputDebug, DBGVIEWCLEAR

play_streamango := False
play_serverhd := play_vidnode := play_xstreamcdn := !play_streamango



chk_do_not_ask_again := False     ; ************************************* TESTING

If Not chk_do_not_ask_again
    get_preferred_server()

If server_name
    select_server()

SetWorkingDir C:\Users\Mark\Desktop\Misc\resources\Images\GoWatchSeries
SetTitleMatchMode RegEx
gowatchseries_wintitle = ^Watch.*Season (\d|,)* Episode \d{1,3}.*Watchseries - Google Chrome$ ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe
WinActivate, %gowatchseries_wintitle%
WinWaitActive, %gowatchseries_wintitle%,,2
If Not WinActive(gowatchseries_wintitle)
{
    MsgBox, 48,, % "Could not activate: " gowatchseries_wintitle
    Goto GOWATCH_EXIT
}

; check if video is in fullscreen or not 
; (if control_classnn = Chrome_RenderWidgetHostHWND1 then video is NOT in Fullscreen mode)
MouseMove, 500, 500
MouseGetPos,,,,control_classnn
If (A_Args[1] == "")
    full_screen := (control_classnn = "Intermediate D3D Window1") 
Else
    full_screen := A_Args[1]
output_debug("A_Args[1]: " A_Args[1] " - full_screen: " full_screen " - control_classnn: " control_classnn)

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
    ; result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        ; , "*10 GoWatchSeries - small screen maximized - zoom100 Pango " current_pango_level " - ServerHD Start Button.png"
        ; , "start", 20, 15, 3000, gowatchseries_wintitle, 50, True, True)  
    result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*10 GoWatchSeries - small screen maximized - zoom100 Pango " current_pango_level " - ServerHD Start Button.png"
        , "start", 20, 15, 1000, gowatchseries_wintitle, 50, True, True)  
    If !result[1]
    {
        Loop, 10
        {
            Click 470, 570
            Sleep 10
        }
        output_debug("Clicking hard coded coordinates for SERVERHD Start Button.")
        ; MsgBox, 48,, % "ImageSearch did not find: ServerHD Start Button."
        Goto GOWATCH_EXIT
    }
}
Else If play_streamango
    start_streamango(gowatchseries_wintitle, current_pango_level)

FULLSCREEN:
If full_screen
{
    output_debug("FULLSCREEN WAS EXECUTED")
    ; SendInput f     ;   play video in fullscreen
}

GOWATCH_EXIT:
; WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
RegWrite, REG_SZ, HKEY_CURRENT_USER, SOFTWARE\MyAHKScripts\GoWatchSeries, PreferredServerName, %server_name%
If ErrorLevel
    MsgBox, % "RegWrite - PreferredServerName - ErrorLevel: " ErrorLevel " - A_LastError: " A_LastError
RegWrite, REG_SZ, HKEY_CURRENT_USER, SOFTWARE\MyAHKScripts\GoWatchSeries, PromptPrefferedServer, %chk_do_not_ask_again%
If ErrorLevel
    MsgBox, % "RegWrite - PromptPrefferedServer - ErrorLevel: " ErrorLevel " - A_LastError: " A_LastError
output_debug("EXITAPP - " server_name " - " chk_do_not_ask_again)
set_pango_level := pango_level(70)
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
output_debug("ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
            save_coords := x+p_x_offset "," y+p_y_offset
            MouseMove, x+p_x_offset, y+p_y_offset
            If p_click
            {
                SendEvent {Click, Left, Down}{Click, Left, Up}
                output_debug("Click: " countx)
            }
            Sleep %p_sleep%
            If Not WinActive(p_wintitle)
            {
                MsgBox, % p_wintitle " - Aborting...Clicked on wrong button or link, wrong page is active"
                GoSub GOWATCH_EXIT
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
    output_debug( save_coords " " countx " - " A_ThisFunc " (" A_ScriptName ")")
    restore_cursors()
    Return (x+y <> 0)
}

start_streamango(p_wintitle, p_pango_level)
{
    countx := 1 
    retries := 5
    streamango_failed := True
    While streamango_failed And (countx <= retries)
    {
        ; xy_result := select_server("Streamango", p_wintitle, p_pango_level)
        streamango_failed := (xy_result[1] + xy_result[2] = 0)
        countx++
        Sleep 100
    }
    If streamango_failed and countx > retries
    {
        output_debug("Couldn't click Streamango menu server button - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
        MsgBox, % "Couldn't click Streamango menu server button - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
        Gosub GOWATCH_EXIT
    }
    
    ; find Streamango Start button and click it
    xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 80 - Streamango Start Button.png"
        , "Streamango Start Button", 3, 3, 1500
        , p_wintitle, 10, True, True)
    If (xy_result[1] + xy_result[2] = 0)
    {
        output_debug("Streamango start button xy_result: " xy_result[1] "," xy_result[2] " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
        MsgBox, % "Streamango start button xy_result: " xy_result[1] "," xy_result[2] " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
        Gosub GOWATCH_EXIT
    }
}


select_server()
{
    saved_titlematchmode := A_TitleMatchMode
    saved_workingdir := A_WorkingDir
    SetTitleMatchMode 2
    SetWorkingDir C:\Users\Mark\Desktop\Misc\Resources\Images\GoWatchSeries
    chrome_wintitle = Watchseries - Google Chrome
    WinActivate, %chrome_wintitle%
    retries := 0
    SELECTSERVER:
    ; ; find Streamango Start button and click it
    ; image_file = *2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 100 - menu - %server_name% button.png
    ; xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight, image_file
        ; , server_name " Start Button", 3, 3, 1500
        ; , p_wintitle, 10, True, True)
    ; If (xy_result[1] + xy_result[2] = 0)
    ; {
        ; output_debug("Streamango start button xy_result: " xy_result[1] "," xy_result[2] " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
        ; ; MsgBox, % "Streamango start button xy_result: " xy_result[1] "," xy_result[2] " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
        ; Gosub GOWATCH_EXIT
    ; }

    ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 100 - menu - %server_name% button.png
    If (ErrorLevel = 0)
        {
            MouseMove x+20, y+1
            Click
            ttip("`r`n    " server_name " server selected.    `r`n ", 3000,500,500)
            Sleep 1000
        }
    Else
    {
        ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango 100 - menu button.png
        If (ErrorLevel = 0)
        {
            MouseMove x+15, y+10
            Click
            Sleep 500
            If retries < 1
            {
                retries++
                Goto, SELECTSERVER
            }
        }
        Else
            ttip("`r`n COULD NOT START " server_name " `r`n ", 3000, 500, 500)
    }
    SetTitleMatchMode %saved_titlematchmode%
    SetWorkingDir %saved_workingdir%
    Return
}

get_preferred_server()
{
    Global server_list := ["ServerHD", "Xstreamcdn", "Vidnode", "Openload", "Streamango"]
    Gui, Add, Radio, vrad_server_num Group, % server_list[1]
    Gui, Add, Radio,, % server_list[2]
    Gui, Add, Radio,, % server_list[3]
    Gui, Add, Radio,, % server_list[4]
    Gui, Add, Radio,, % server_list[5]
    Gui, Add, Text, ; spacer
    Gui, Add, Checkbox, vchk_do_not_ask_again, Do not ask again
    Gui, Add, Text,  ; spacer
    Gui, Add, Button, gbut_ok w45 Default, Ok
    Gui, Add, Button,x+m, Cancel
    GuiControl,, %server_name%, 1
    GuiControl,, chk_do_not_ask_again, %chk_do_not_ask_again%
    Gui, +ToolWindow 
    Gui, Show,, Choose Server
    While WinExist("Choose Server")
        Sleep 300
    Return

but_ok:
    Gui, Submit, NoHide
    server_name := server_list[rad_server_num]
    output_debug("server_name: " server_name)
    Goto, GuiClose
Return

GuiEscape:
GuiClose:
    Gui, Destroy
Return
}

^+x::ExitApp

/*  OLD select server routine

select_server(p_server_name,p_wintitle, p_pango_level)
{
    If (p_server_name == "") Or (p_wintitle == "")
    {
        output_debug("p_server_name: " p_server_name " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
        output_debug("p_wintitle: " p_wintitle " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
        Return
    }
        
    ; find server menu and click it
    ; xy_result := find_and_click_button(A_ScreenWidth * .5 , 0, A_ScreenWidth, A_ScreenHeight *.5
    xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango " p_pango_level " - menu button.png"
        , "Server Menu", 10, 5, 10
        , p_wintitle, 5, True, False)
    If (xy_result[1] + xy_result[2] = 0)
    {
        output_debug("ImageSearch did not find - menu button. Sending fixed position Click. Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
        MsgBox, % "ImageSearch did not find - menu button. Sending fixed position Click. Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
        SendEvent {Click, Down}{Click, Up}
        ; Click, Left  ,  830, 380   ; Server Menu Button
        Sleep 100
        
        Pause
    }    
SELECT_SERVER:
    ; find Streamango server menu option and click it
    xy_result := find_and_click_button(0, 0, A_ScreenWidth, A_ScreenHeight
        , "*2 *TransBlack GoWatchSeries - small screen maximized - zoom100 Pango " p_pango_level " - menu Streamango.png"
        , "Streamango", 10, 1, 10
        , p_wintitle, 5, True, False)
    If (xy_result[1] + xy_result[2] = 0)
    {
        output_debug("ImageSearch did not find - menu option Streamango. Sending fixed position Click. Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")")
        ; MsgBox, % "ImageSearch did not find - menu button. Sending fixed position Click. Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
        MouseMove,  810, 555  ; menu option - Streamango
        xy_result[1] := 810
        xy_result[2] := 555
        MsgBox, 48,, % "MouseMove,  810,  555"
    }    
    Return xy_result
}
*/