;--------------------------------------------------------------------------------------
;   Causes script to either exit or show menu when left clicking Tray icon
;
;   *** Note: this is not a function call. It is added to every program that #includes
;         this library. If desired global variable is NOT set to True in the
;         calling program then this does nothing. 
;
;         Set ONLY 1 global variable to True to use.
;---------------------------------------------------------------------------------------
Global g_TRAY_EXIT_ON_LEFTCLICK := False        ; exits program 
Global g_TRAY_MENU_ON_LEFTCLICK := False        ; shows tray menu (like rightclick)
Global g_TRAY_SUSPEND_ON_LEFTCLICK := False     ; suspends hotkeys and hotstrings
Global g_TRAY_PAUSE_ON_LEFTCLICK := False       ; pauses script
Global g_TRAY_RELOAD_ON_LEFTCLICK := False      ; reloads the script
Global g_TRAY_EDIT_ON_LEFTCLICK := False        ; edits script in Notepad++
OnMessage(0x404, "AHK_NOTIFYICON")

AHK_NOTIFYICON(wParam,lParam)
{
    If lParam = 0x202            ; WM_LBUTTONUP
    {
        If g_TRAY_EXIT_ON_LEFTCLICK
            ExitApp
        Else If g_TRAY_MENU_ON_LEFTCLICK
            Menu, Tray, Show
        Else If g_TRAY_SUSPEND_ON_LEFTCLICK
            Suspend, Toggle
        Else If g_TRAY_PAUSE_ON_LEFTCLICK
            Pause, Toggle
        Else If g_TRAY_RELOAD_ON_LEFTCLICK
            Reload
        Else If g_TRAY_EDIT_ON_LEFTCLICK
        {
            ; find default editor for AutoHotkey programs.
            RegRead, exe_path, % "HKEY_CLASSES_ROOT\AutoHotkeyScript\Shell\Edit\Command"
            exe_path := RegExReplace(exe_path,"i)^""([a-z]:\\(\w+|\s*|\\|\(|\)|-|\.)+?.*\.exe).*","$1")
            Run, "%exe_path%" "%A_ScriptFullPath%"
        }
        Else
            OutputDebug, % "Unexpected g_TRAY_<action>_ON_LEFTCLICK error - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    }
    Return
}
;--------------------------------------------------------
;--------------------------------------------------------
;--------------------------------------------------------
;--------------------------------------------------------
/*
    typedef struct _lv_hitesttest_info {
    POINT pt;
    UINT  flags;
    int   iItem;
    int   iSubItem;
    int   iGroup;
} lv_hitesttest_info, *LPlv_hitesttest_info;
*/
;--------------------------------------------------------
listview_get_column_clicked(p_lv_hwnd) 
{
   Static LVM_SUBITEMHITTEST := 0x1039
   VarSetCapacity(point, 8, 0)
   ; Get the current cursor position in screen coordinates
   DllCall("User32.dll\GetCursorPos", "Ptr", &point)
   ; Convert them to client coordinates related to the ListView
   DllCall("User32.dll\ScreenToClient", "Ptr", p_lv_hwnd, "Ptr", &point)
   ; Create a lv_hitesttest_info structure (see above comment)
   VarSetCapacity(lv_hitesttest_info, 24, 0)
   ; Store the relative mouse coordinates
   NumPut(NumGet(point, 0, "Int"), lv_hitesttest_info, 0, "Int")    ; x
   NumPut(NumGet(point, 4, "Int"), lv_hitesttest_info, 4, "Int")    ; y 
   SendMessage, LVM_SUBITEMHITTEST, 0, &lv_hitesttest_info, , ahk_id %p_lv_hwnd%
   If (ErrorLevel = -1)
      Return 0
   column_num := NumGet(lv_hitesttest_info, 16, "Int") + 1
   Return column_num
}
;----------------------------------------------------------------------------
;           ttip(p_msg, p_sleep_time := 0, p_x := 0, p_y := 0)
;
;   Displays a message in a tooltip either near the mouse or 
;   at some given fixed position.
;
;   Parameters:
;       p_msg        = message to display in tooltip
;       p_sleep_time = milliseconds to sleep before closing tooltip
;       p_x, p_y     = fixed position on screen to display tooltip
;
;   Notes: 
;       If p_sleep_time = 0 then tooltip will be displayed until user hits {Escape}.
;       If p_x and/or p_y > 0 then tooltip will be displayed at the given fixed position.
;       If p_x and p_y = 0 then tooltip will be displayed near the current mouse position.
;
;   Examples: 
;       ttip("Hello World")                     ; simple message displayed near mouse
;       ttip(xy_result[1] ", " xy_result[2])    ; will display evaluated expression
;       ttip(write_string,, 100, 100)           ; display message at fixed position and
;                                               ; wait for escape key to close tooltip
;
;----------------------------------------------------------------------------
ttip(p_msg, p_sleep_time := 0, p_x := 0, p_y := 0)
{
    saved_coordmode := A_CoordModeTooltip
    saved_coordmode := A_CoordModeMouse
    CoordMode, Tooltip, Screen
    CoordMode, Mouse, Screen

    If (p_x + p_y = 0)
    {
        MouseGetPos, x, y
        x += 20
        y += 20
    }
    Else
    {
        x := p_x
        y := p_y
    }
    ; OutputDebug, % "x, y: " x ", " y " - " A_CoordModeMouse " - " A_ScriptName "(" A_ThisFunc ")"
    If (p_sleep_time)
        msg := p_msg
    Else
    {
        msg := "{Escape} to exit`n"
        msg .= "----------------`n`n"
        msg .= "    " p_msg "    `n" A_Space
    }
    ToolTip, %msg%, x, y
    If (p_sleep_time)
        Sleep %p_sleep_time%
    Else
        Input, out_var,,{Escape}

    ; OutputDebug, % p_msg
    ToolTip
    CoordMode, Mouse, %saved_coordmode%
    CoordMode, Tooltip, %saved_coordmode%
    Return
}
;----------------------------------------------------------------------------
; Returns various MouseGetPos results useful in #IF commands
;
; p_element: the MouseGetPos argument being compared to by p_compare_value
;   width : checks whether p_compare_value is >= current mouse X position
;   height: checks whether p_compare_value is >= current mouse Y position
;   hover : checks whether mouse is hovering over a given wintitle (p_compare_value) 
;       Any valid wintitle can be used including RegEx. The A_TitleMatchMode
;       should be set in the calling program.
;   
; p_compare_value: see examples
;   
; Examples:
;   1) Checks whether mouse is currently within 100 pixels to the right screen edge
;      #If mouse_position("width", A_ScreenWidth - 100)
;   
;   2) Checks whether mouse is currently within 50 pixels from the bottom of the screen
;      #If mouse_position("height", A_ScreenHeight - 50)   
;   
;   3) Checks whether mouse is hovering over the given wintitle
;      SetTitleMatchMode RegEx
;      #If mouse_position("hover", "i).*YouTube.*Chrome.*")   
;   
;----------------------------------------------------------------------------
mouse_position(p_element, p_compare_value)
{
    saved_coordmode := A_CoordModeMouse
    CoordMode, Mouse, Screen
    MouseGetPos, x, y, win_hwnd, ctrl_classnn
    If (p_element = "width")
        result := x >= p_compare_value
    Else If (p_element = "height")
        result := y >= p_compare_value
    Else If (p_element = "hover")
        result := WinExist(p_compare_value . " ahk_id " . win_hwnd) 
    CoordMode, Mouse, %saved_coordmode%
    Return result
}
;----------------------------------------------------------------------------
;          mouse_hovering(p_hover_interval, p_pad_pixels := 0)
;
;   Checks is if mouse is hovering in the same position on the screen
;   Returns True if mouse is hovering or False if it isn't.
;
;	Parameters:
;		p_hover_interval = number of milliseconds mouse must be in the same 
;       	position for it to be considered as hovering in the same spot.
;
;		p_pad_pixels = (Optional) number of pixels ± mouse is allowed to move 
;			from its current position and still consider it hovering in the same spot.
;			Default is zero meaning mouse must not move at all, for p_hover_interval
;           milliseconds, for it to be considered a hover.
;
;   Example: 
;       
;----------------------------------------------------------------------------
mouse_hovering(p_hover_interval, p_pad_pixels := 0)
{
    MouseGetpos, x1, y1
    Sleep p_hover_interval
    MouseGetpos, x2, y2
    If  ((x1 >= x2 - p_pad_pixels) and (x1 <= x2 + p_pad_pixels)) and ((y1 >= y2 - p_pad_pixels) and (y1 <= y2 + p_pad_pixels))
        Return True
	Else
		Return False
}
;----------------------------------------------------
;   get_file_icon(p_filename)
;
;   Returns an icon handle (hicon) see HBITMAP in AutoHotkey help file
;   used in commands that support HICON for displaying a file's icon.
;
; Example:
;        hicon := get_file_icon(A_LoopFileFullPath)
;        Menu, %parent_menu%, Icon, %A_LoopFileName%, HICON:%hicon% 
;----------------------------------------------------
get_file_icon(p_filename)
{
    ; Get the file's icon.
    VarSetCapacity(fileinfo, fisize := A_PtrSize + 688)
    if DllCall("shell32\SHGetFileInfoW", "WStr", p_filename
        , "UInt", 0, "Ptr", &fileinfo, "UInt", fisize, "UInt", 0x100)
        hicon := NumGet(fileinfo, 0, "Ptr")
    Return %hicon%
}
;----------------------------------------------------
; set_system_cursor() & restore_cursors()
;
; Example:
;    set_system_cursor("IDC_WAIT")
;    restore_cursors()
;----------------------------------------------------
set_system_cursor( Cursor = "", cx = 0, cy = 0 )
{
	BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
	SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
	,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
	,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
	,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
	
	If Cursor = ; empty, so create blank cursor 
	{
		VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
		BlankCursor = 1 ; flag for later
	}
	Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
	{
		Loop, Parse, SystemCursors, `,
		{
			CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
			CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
			SystemCursor = 1
			If ( CursorName = Cursor )
			{
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )	
				Break					
			}
		}	
		If CursorHandle = ; invalid cursor name given
		{
			Msgbox,, SetCursor, Error: Invalid cursor name
			CursorHandle = Error
		}
	}	
	Else If FileExist( Cursor )
	{
		SplitPath, Cursor,,, Ext ; auto-detect type
		If Ext = ico 
			uType := 0x1	
		Else If Ext in cur,ani
			uType := 0x2		
		Else ; invalid file ext
		{
			Msgbox,, SetCursor, Error: Invalid file type
			CursorHandle = Error
		}		
		FileCursor = 1
	}
	Else
	{	
		Msgbox,, SetCursor, Error: Invalid file path or cursor name
		CursorHandle = Error ; raise for later
	}
	If CursorHandle != Error 
	{
		Loop, Parse, SystemCursors, `,
		{
			If BlankCursor = 1 
			{
				Type = BlankCursor
				%Type%%A_Index% := DllCall( "CreateCursor"
				, Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}			
			Else If SystemCursor = 1
			{
				Type = SystemCursor
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )	
				%Type%%A_Index% := DllCall( "CopyImage"
				, Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )		
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}
			Else If FileCursor = 1
			{
				Type = FileCursor
				%Type%%A_Index% := DllCall( "LoadImageA"
				, UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 ) 
				DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )			
			}          
		}
	}	
}

restore_cursors()
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}
;----------------------------------------------------
; Returns Registry's default browser exe path
;----------------------------------------------------
default_browser() 
{
	; Find the Registry key name for the default browser
	RegRead, BrowserKeyName, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html\UserChoice, Progid

	; Find the executable command associated with the above Registry key
	RegRead, BrowserFullCommand, HKEY_CLASSES_ROOT, %BrowserKeyName%\shell\open\command

	; The above RegRead will return the path and executable name of the brower contained within quotes and optional parameters
	; We only want the text contained inside the first set of quotes which is the path and executable
	; Find closing quote position - second occurance of quote_char. 
	; StringGetPos, pos, BrowserFullCommand, ",,1
    quote_char := chr(34)
    pos := InStr(BrowserFullCommand, quote_char, false,,2)
  
	; Decrement the found position by two, to work correctly with the StringMid function
	pos := pos -2
    
	; Extract and return the path and executable of the browser
	; StringMid, BrowserPathandEXE, BrowserFullCommand, 2, %pos%
	BrowserPathandEXE := SubStr(BrowserFullCommand, 2, pos)
	Return BrowserPathandEXE
}
;----------------------------------------------------
; p_HHhh: 1 = 12 hour format
;         2 = 24 hour format
;
; p_seconds: True - displays seconds. False - don't display seconds.
;----------------------------------------------------
get_time(p_HHhh:=2, p_seconds:=True)
{
    hour_format := if p_HHhh = 1 ? "hh" : "HH"
    if p_seconds
        FormatTime, timex,, %hour_format%:mm:ss
    else
        FormatTime, timex,, %hour_format%:mm
    Return timex
}
;----------------------------------------------------
; p_HHhh: 1 = 12 hour format
;         2 = 24 hour format
;
; p_style: 1 = log style ie: 2018/06/08 16:18:40         
;          2 = diary style ie:  08-Jun-2018 16:18
;----------------------------------------------------
timestamp(p_HHhh:=2, p_style:=1)
{
    hour_format := if p_HHhh = 1 ? "hh" : "HH"

    if (p_style == 1)
        FormatTime, timex,, yyyy/MM/dd %hour_format%:mm:ss
    else if (p_style == 2)
        FormatTime, timex,, dd-MMM-yyyy %hour_format%:mm
    
    Return timex
}
;----------------------------------------------------
; Returns an array of all the subdirectories for a given path
; Access the subdirectory your interested in by it's index....
; Example: 
;        ResultArray := []
;        FullFilename = C:\Users\John\AppData\Local\Temp\7zBF42C9E0\AutoHotkeyU32.exe
;        resultarray := get_parent_directories(FullFilename)
;        for index, element in resultarray
;        {
;            msgbox % "(" index "} " element 
;        }
;        msgbox % resultarray[3]
;----------------------------------------------------
get_parent_directories(p_filepath)
{
    oresult := []
    odir := "dummy"
    odrive := "smart"
    While odir != odrive
    {
        SplitPath, p_filepath,,odir,,,odrive
        oresult.push(odir)
        p_filepath := odir
    }
    Return oresult 
}
;----------------------------------------------------
; Returns the full path for a given subdirectory.
; The subdirectory must be an exact match except for case.
; If there is more than 1 matching subdirectory in the path 
; the last one is returned.
;----------------------------------------------------
get_path(p_subdir, p_fullpath)
{
    path := p_fullpath
    root_dir := p_subdir
    len_root_dir := StrLen(root_dir)
    len_path := StrLen(path)
    
    ; Find first occurance from the end (ie: reverse search)
    last_occurance_pos := Instr(path, root_dir, false, 0)
   
    ; Extract the path to root_dir including backslash
    path_len := last_occurance_pos + len_root_dir 
    found_path := SubStr(path, 1, path_len)
    if SubStr(found_path, StrLen(found_path)) != "\"
        found_path := ""
    Return found_path
}
;----------------------------------------------------
; Delete taskbar icon, ordered left to right                                                       
; Author: Dev-X                                                                                    
; Refresh was c++ converted and converted to                                                       ///
; AHK from http://malwareanalysis.com/CommunityServer/blogs/geffner/archive/2008/02/15/985.aspx  
;----------------------------------------------------
delete_taskbar_icon(p_icon_number)
{
    eee := DllCall( "FindWindowEx", "uint", 0, "uint", 0, "str", "Shell_TrayWnd", "str", "")
    ddd := DllCall( "FindWindowEx", "uint", eee, "uint", 0, "str", "TrayNotifyWnd", "str", "")
    ccc := DllCall( "FindWindowEx", "uint", ddd, "uint", 0, "str", "SysPager", "str", "")
    hNotificationArea := DllCall( "FindWindowEx", "uint", ccc, "uint", 0, "str", "ToolbarWindow32", "str", "Notification Area")

    SendMessage, 0x416, %p_icon_number%, , , ahk_id %hNotificationArea%
}
;----------------------------------------------------
;
;----------------------------------------------------
refresh_taskbar_icons()
{
    eee := DllCall( "FindWindowEx", "uint", 0, "uint", 0, "str", "Shell_TrayWnd", "str", "")
    ddd := DllCall( "FindWindowEx", "uint", eee, "uint", 0, "str", "TrayNotifyWnd", "str", "")
    ccc := DllCall( "FindWindowEx", "uint", ddd, "uint", 0, "str", "SysPager", "str", "")
    hNotificationArea := DllCall( "FindWindowEx", "uint", ccc, "uint", 0, "str", "ToolbarWindow32", "str", "Notification Area")

    xx = 3
    yy = 5
    Transform, yyx, BitShiftLeft, yy, 16
    loop, 6 ;152
    {
        xx += 15
        SendMessage, 0x200, , yyx + xx, , ahk_id %hNotificationArea%
    }
}