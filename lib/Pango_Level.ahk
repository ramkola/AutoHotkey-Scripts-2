;--------------------------------------------------------------------------------------
;
;   Parameter:
;       p_dimmer_level:
;           0 - get current dimmer level
;           1 - view pango menu for 2 seconds
;         > 1 - set dimmer level. must be one of the valid level numbers:
;               20,30,40,50,60,70,80,90,100 only. 20 is darkest, 100 is brightest
;
;           Returns -999 if bad parameter passed. See examples for other return codes.
;
;   Examples:
;       #1) Get the current dimmer level (0 or no parameter passed) 
;           MsgBox, 64,, % "Pango Level: " pango_level()
;           MsgBox, 64,, % "Pango Level: " pango_level(0)
;           Returns the current dimmer level (20, 30, 40..100) or False if ImageSearch fails
;         
;       #2) View pango menu to see current dimmer level
;           pango_level(1)
;           Returns True 
;
;       #3) Set a specific dimmer level
;           pango_set_flag := pango_level(30)        
;           Returns True if ImageSearch worked otherwise False
;
;   Notes: 
;        Calling script must either: 
;                 #Include lib\pango_level.ahk 
;                 #Include lib\trayicon.ahk 
;                       or
;                 Store those files in the #Include <default library directory>
;--------------------------------------------------------------------------------------
pango_level(p_dimmer_level = 0)
{
    If (p_dimmer_level <> 0)
        If Not RegExMatch(p_dimmer_level, "\b(1|20|30|40|50|60|70|80|90|100)\b")
            Return -999       ; bad parameter

    get_level  := (p_dimmer_level = 0)
    view_level := (p_dimmer_level = 1)
    set_level  := (p_dimmer_level > 1)
    
    saved_working_dir := A_WorkingDir
    SetWorkingDir, C:\Users\Mark\Desktop\Misc\resources\Images\Pangolin
    pango_menu_wintitle = ahk_class #32768 ahk_exe PangoBright.exe

    ; show menu in an arbitrary fixed position so that we can ImageSearch in a fixed rectangle
    ; for better performance. (Otherwise the menu pops up relative to whatever the current mouse position is.
    ; Note: MouseGetPos x,y gives bottom right of menu - not top left as expected.)
    saved_coordmode := A_CoordModeMouse
    CoordMode, Mouse, Screen
    MouseMove, 1100, 800    ; just happened to work with these numbers, no special reason   
    TrayIcon_Button("PangoBright.exe", "L", False, 1)    

    ; p_dimmer_level = 1 means user requested to just view the menu
    If view_level
    {
        Sleep 2000          ; gives chance for user to view menu 
        Goto PANGO_EXIT     ; no need for imagesearch
    }
    Else
        Sleep 100   ; minimum time needed for menu to display so that it can be imagesearched

    ; p_dimmer_level > 1 means user requested to set dimmer level (not just report the current level)
    If set_level
    {
        menu_accelerator_key := Round(p_dimmer_level / 10)
        ControlSend,, %menu_accelerator_key%, %pango_menu_wintitle% 
        controlsend_errorlevel := ErrorLevel
        If ErrorLevel
            OutputDebug, % "ErrorLevel: " ErrorLevel

        TrayIcon_Button("PangoBright.exe", "L", False, 1)    ; ControlSend causes menu to close
        Sleep 100
    }

    ; if p_dimmer_level = 0 then imagesearch all possible dimmer levels
    ; until the image with the dot indicating the current level is found.
    ;
    ; if p_dimmer_level > 1 then just search for the image of the user provided level to confirm 
    ; that it was set correctlu above with the ControlSend.
    ; 
    ; searching from 100 backwards (to 20) because it is usually set around 70 or 80 
    ; so it will usually be found quicker.
    pango_level := (p_dimmer_level <= 0) ? 100 : p_dimmer_level
    While (pango_level > 19)
    {
        ; ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight, *2 Pango %pango_level% - Menu Level Indicator.png
        ImageSearch, x, y, 600, 300, 800, 500, *2 Pango %pango_level% - Menu Level Indicator.png
        imagesearch_errorlevel := ErrorLevel
        ; OutputDebug, % "x, y: " x ", " y " - ErrorLevel: " ErrorLevel " - Pango Level: " pango_level
        If set_level
            Break   ; only searched to confirm whether controlsend worked, can exit now
            
        If (ErrorLevel = 0)
            Break   ; level found so exit loop
        Else 
            pango_level -= 10   ; level not found so try next level down
    }
    
PANGO_EXIT:
    WinClose, %pango_menu_wintitle%    
    CoordMode, Mouse, %saved_coordmode%
    SetWorkingDir, %saved_working_dir%
    
    ; result of get current level
    If get_level
        Return % (imagesearch_errorlevel = 0) ? pango_level : False

    ; result of view dimmer level
    If view_level
        Return True

    ; result of set dimmer level
    If set_level
        Return (imagesearch_errorlevel = 0)
}

