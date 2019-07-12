; map_list := ["Random","Random Land Map","Arabia","Archipelago","Arena","Baltic","Black Forest"
	; , "Coastal","Continental","Ghost Lake","Gold Rush","Highland","Islands","Mediterranean"
	; , "Mongolia","Oasis","Rivers","Salt Marsh","Scandinavia","Team Islands","Yucatan"]

exit_app()
{
    result = 0
    While Not result
        result := pango_level(70)
    WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    ExitApp
}

format_inputbox_prompt(p_text_array)
{
	For i_ndx, text_line in p_text_array
	{	
		spacing := (Mod(i_ndx,2) = 0) ? "`r`n" : "`t`t"
		result_string .= Format("{:1}) {}{}", i_ndx, text_line, spacing)
	}
	result_string := "`r`n" result_string
	Return result_string
}

get_game_type(p_game_type)
{
	game_list := ["Random Map","Regicide","Death Match","Scenario"
		,"King of the Hill","Wonder Race","Defend the Wonder"]
	For i_ndx, text_line in game_list
		If (p_game_type = text_line)
			Return p_game_type
	Loop
	{
		ib_text := format_inputbox_prompt(game_list)
		max_options := game_list.MaxIndex()
		game_ndx = 0
		InputBox, game_ndx, Choose Game Type# 1-%max_options%, %ib_text%
		If ErrorLevel
			exit_app()

		If game_ndx Between 1 And %max_options%
			Break
	}
	Return game_list[game_ndx]
}

get_difficulty_level(p_difficulty)
{
	difficulty_list := ["Easiest","Standard","Moderate","Hard","Hardest"]
	For i_ndx, text_line in difficulty_list
		If (p_difficulty = text_line)
			Return p_difficulty
	Loop
	{
		ib_text := format_inputbox_prompt(difficulty_list)
		max_options := difficulty_list.MaxIndex()
		diff_ndx = 0
		InputBox, diff_ndx, Choose Difficulty Level# 1-%max_options%, %ib_text%
		If ErrorLevel
			exit_app()

		If diff_ndx Between 1 And %max_options%
			Break
	}
	Return difficulty_list[diff_ndx]
}

set_game_type(p_game_type)
{
	Click, Left, 775, 70		   
	Sleep 100
	If (p_game_type = "Random Map")
		Click, Left, 660,  90
	Else If (p_game_type = "Regicide")
		Click, Left, 660, 115
	Else If (p_game_type = "Death Match")
		Click, Left, 660, 135
	Else If (p_game_type = "Scenario")
		Click, Left, 660, 155
	Else If (p_game_type = "King of the Hill")
		Click, Left, 660, 175
	Else If (p_game_type = "Wonder Race")
		Click, Left, 660, 200
	Else If (p_game_type = "Defend the Wonder")
		Click, Left, 660, 220
	Sleep 100
	Return
}

set_game_difficulty(p_difficulty)
{
	Click, Left  ,  776,  180			   
	Sleep 100
	If (p_difficulty = "Easiest")
		Click, Left, 658, 205
	Else If (p_difficulty = "Standard")
		Click, Left, 647, 230
	Else If (p_difficulty = "Moderate")
		Click, Left, 638, 249
	Else If (p_difficulty = "Hard")
		Click, Left, 625, 273
	Else If (p_difficulty = "Hardest")
		Click, Left, 637, 288
	Sleep 100
	Return
}

focus_mouse_on_selected_object(p_set_gather_point := "None"
                               , p_same_gather_point_x := 0
                               , p_same_gather_point_y := 0
                               , p_object_type := "Building")
{
    ; *******************************************************************************
    ; *** OBJECT MUST BE VISIBLE ON SCREEN TO BE SELECTED AND FOCUSED MOUSE ON IT ***
    ; *******************************************************************************
    xy_return := []
    ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*2 Pango 100 - Selected Object - Green Marker.png
    If ErrorLevel
    {
        SendInput {F3}      ; Pause game
        ttip("Green Marker Failed.`nCheck that Pango is at the correct setting.`nErrorLevel: " ErrorLevel)
        Return
    }
    Else
    {
        If (p_object_type = "Building")
            MouseMove, x+20, y+50   ; mouse should be over center of building
        Else If (p_object_type = "Villager")
            MouseMove, x+4, y+30  ; mouse should be over center of villager
        MouseGetPos, x, y
        xy_return[1] := x
        xy_return[2] := y
        If (p_set_gather_point <> "None")
        {
            ; ttip(p_set_gather_point)  ; debugging
            If (p_set_gather_point == "Same")
            {
                MouseMove, p_same_gather_point_x, p_same_gather_point_y + 20
            }
            SendInput i{Click, Right}   ; if mouse wasn't moved above then gather point is "Self"
        }
    }
    Return xy_return
}

build_at_mousepos_offset(p_x, p_y, p_sleep_time, p_build_num_init := 1, p_reset_build_num := False)
{
    Static build_num 
    If p_reset_build_num
    {
        build_num := 1
        Return
    }
    If (build_num < p_build_num_init)
        build_num := p_build_num_init
    MouseGetPos, x,y
    MouseMove, x + p_x, y + p_y
    Sleep 100
    SendInput +{Click, Left}   
    Sleep %p_sleep_time%            ; allows longer delays for debugging   
    build_num++
    Return
}

start_game(p_difficulty, p_game_type := "Random Map", p_record_game := False)
{
	game_type := get_game_type(p_game_type)
	difficulty := get_difficulty_level(p_difficulty)
    ToolTip, % "`r`n`r`n    Starting game....please wait    `r`n`r`n ", 200, 200
    BlockInput, On
    SendInput, {Click, Left, 375,  96}      ; Single Player
	SendInput, {Click, Left, 610,  170}		; Standard Game
	Sleep 2000
    set_game_type(game_type)
	set_game_difficulty(difficulty)
	;
    If p_record_game
        SendInput, {Click, Left, 758, 442}
    Sleep 100
	Click, Left, 109, 565     ; Start Game
    ToolTip, % "`r`n`r`n    Starting game....please wait    `r`n`r`n ", 200, 200
    Sleep 8000
    Gosub ^!+s      ; standard start games commands
    SendInput !o    ; display game objectives
    BlockInput, Off
    ToolTip
    Return
}

perimeter_current_pos(p_scout_type := "Scout")
{

OutputDebug, DBGVIEWCLEAR

    image_x := image_y := 100
    image_file=*2 Pango 100 - Unexplored - Main Map - %image_x%X%image_y% Square.png

    SendInput {F3}{F4}9]    ; F3=pause/F4=no score/9=select scout/]=no attack
    focus_mouse_on_selected_object()

    OutputDebug, % "**** direction - Up"
    ; Scroll map up to reveal unexplored areas
    scroll_to_unexplored_area("Up")
    MouseGetPos, x, y
    x1 := x, y1 := 0 
    x2 := x, y2 := 10
    ; search for unexplored areas
    x1 := x, y1 := 0
    ErrorLevel = 0
    While (ErrorLevel = 0)
    {
        ImageSearch, x, y, x1, y1, A_ScreenWidth, A_ScreenHeight, %image_file%
        If (ErrorLevel = 0)
        {
            MouseMove, x + Round(image_x/2), y + Round(image_y/2)
            SendInput +{Click, Right}
        }
        x1 := x + 200
        OutputDebug, % Format("{:4}, {:4} - {:4}, {:4} - ErrorLevel: {}", x, y, x1, y1, ErrorLevel)
    }
    ;==================================================================
    OutputDebug, % "**** direction - Right"
    ; Scroll map right to reveal unexplored areas
    scroll_to_unexplored_area("Right")
    x1 := A_ScreenWidth, y1 := y
    x2 := x1 - 10, y2 := y
    ; search for unexplored areas    
    x1:=A_ScreenWidth-200, y1:=0
    ErrorLevel = 0
    While (ErrorLevel = 0)
    {
        ImageSearch, x, y, x1, y1, A_ScreenWidth, Y_BOT_MAIN_MAP, %image_file%
        If (ErrorLevel = 0)
        {
            MouseMove, x + Round(image_x/2), y + Round(image_y/2)     
            SendInput +{Click, Right}
        }
        y1 := y + 200
        OutputDebug, % x ", " y " - " x1 ", " y1 " - "A_CoordModeMouse ", ErrorLevel: " ErrorLevel  
    }   
    ;==================================================================
    OutputDebug, % "**** direction - Down"
    ; Scroll map down to reveal unexplored areas
    scroll_to_unexplored_area("Down")
    MouseGetPos, x, y
    x1 := x, y1 := A_ScreenHeight
    x2 := x, y2 := y - 10
    ; search from right to left (reverse imagesearch) for unexplored areas    
    x2:=A_ScreenWidth, y2:=Y_BOT_MAIN_MAP
    x1:=x2-200, y1:=y2-200
    While (x1 >= 0)
    {
        ImageSearch, x, y, x1, y1, x2, y2, %image_file%
        If (ErrorLevel = 0)
        {
            MouseMove, x + Round(image_x/2), y + Round(image_y/2)
            SendInput +{Click, Right}
        }
        OutputDebug, % x ", " y " - " x1 ", " y1 " - " x2 ", " y2 " - "A_CoordModeMouse ", ErrorLevel: " ErrorLevel  
        x1 -= 200
        x2 -= 200
    }
    ;==================================================================
    OutputDebug, % "**** direction - Left"
    ; Scroll map down to reveal unexplored areas
    scroll_to_unexplored_area("Left")
    MouseGetPos, x, y
    x1 := 0, y1 := y
    x2 := 10, y2 := y
    ; search from bottom to top (reverse imagesearch) for unexplored areas    
    x2:=200, y2:=Y_BOT_MAIN_MAP
    x1:=0, y1:=y2-200
    While (y1 >= 32)
    {
        ImageSearch, x, y, x1, y1, x2, y2, %image_file%
        If (ErrorLevel = 0)
        {
            MouseMove, x + Round(image_x/2), y + Round(image_y/2)
            SendInput +{Click, Right}
        }
        OutputDebug, % x ", " y " - " x1 ", " y1 " - " x2 ", " y2 " - "A_CoordModeMouse ", ErrorLevel: " ErrorLevel  
        y1 -= 200
        y2 -= 200
    }
    ;==================================================================
    OutputDebug, % "**** direction - Top Left Corner"
    ; Scroll map to top left corner to reveal unexplored areas
    scroll_to_unexplored_area("TopLeft")
    MouseGetPos, x, y
    x1 := 0, y1 := Y_TOP_MAIN_MAP
    x2 := Round(A_ScreenWidth/3), y2 := Round(A_ScreenHeight/3)
    While (x1 <= x2)
    {
        ImageSearch, x, y, x1, y1, x2, y2, %image_file%
        If (ErrorLevel = 0)
        {
            MouseMove, x + Round(image_x/2), y + Round(image_y/2)
            SendInput +{Click, Right}
        }
        OutputDebug, % x ", " y " - " x1 ", " y1 " - " x2 ", " y2 " - "A_CoordModeMouse ", ErrorLevel: " ErrorLevel  
        x1 += 200
    }
    x1:=0
    While (y1 <= y2)
    {
        ImageSearch, x, y, x1, y1, x2, y2, %image_file%
        If (ErrorLevel = 0)
        {
            MouseMove, x + Round(image_x/2), y + Round(image_y/2)
            SendInput +{Click, Right}
        }
        OutputDebug, % x ", " y " - " x1 ", " y1 " - " x2 ", " y2 " - "A_CoordModeMouse ", ErrorLevel: " ErrorLevel  
        y1 += 200
    }
    
PCP_EXIT:
    SendInput {Click, Right}    ; start patrol
	SendInput {F4}		        ; Turn score back on 
    SendInput {F3}              ; resume game
    Return
}   ; end perimeter_current_pos

scroll_to_unexplored_area(p_direction)
{
    image_x := image_y := 300
    image_file=*2 Pango 100 - Unexplored - Main Map - %image_x%X%image_y% Square.png
    MouseGetPos, x1, y1
    save_x := x1
    save_y := y1
    If (p_direction = "Up")
    {
        x1 := Round(A_ScreenWidth/2), y1 := 0, x2 := x1, y2 := 10
        x3 := 0, y3 := Y_TOP_MAIN_MAP, x4 := A_ScreenWidth, y4 := Y3 + image_y
        scroll_interval = 200
    }
    Else If (p_direction = "Down")
    {
        x1 := Round(A_ScreenWidth/2), y1 := A_ScreenHeight, x2 := x1, y2 := A_ScreenHeight - 10
        x3 := 0, y3 := Y_BOT_MAIN_MAP - image_y - 5, x4 := A_ScreenWidth, y4 := Y_BOT_MAIN_MAP
        scroll_interval = 600
    }
    Else If (p_direction = "Right")
    {
        x1 := A_ScreenWidth, y1 := Round(A_ScreenHeight/2), x2 := A_ScreenWidth - 10, y2 := y1
        x3 := A_ScreenWidth - image_x - 5, y3 := Y_TOP_MAIN_MAP, x4 := A_ScreenWidth, y4 := Y_BOT_MAIN_MAP
        scroll_interval = 200
    }
    Else If (p_direction = "Left")
    {
        x1 := 0, y1 := Round(A_ScreenHeight/2), x2 := 10, y2 := y1
        x3 := 0, y3 := Y_TOP_MAIN_MAP, x4 := image_x + 5, y4 := Y_BOT_MAIN_MAP
        scroll_interval = 200
    }
    Else If (p_direction = "TopLeft")
    {
        x1 := 0, y1 := 0, x2 := 10, y2 := y1
        x3 := 0, y3 := Y_TOP_MAIN_MAP, x4 := image_x + 5, y4 := Y_BOT_MAIN_MAP
        scroll_interval = 200
    }
    Else
        Return
        
    ; OutputDebug, % x1 ", " y1 " - " x2 ", " y2
    ; OutputDebug, % x3 ", " y3 " - " x4 ", " y4 
    countx := 0
    ErrorLevel := 9999
    While (ErrorLevel <> 0) and (countx < 5)
    {
        MouseMove x1, y1    ; scroll screen in p_direction
        Sleep 200
        MouseMove x2, y2    ; stop scroll
        ;
        ; search for unexplored area
        MouseMove 5,5   ; move mouse so it won't interfere with imagesearch
        ImageSearch, x, y, x3, y3, x4, y4, %image_file%
        OutputDebug, % x "," y " | " x3 "," y3 "-" x4 "," y4 " | ErrorLevel: " ErrorLevel " - countx: " countx
        countx++
    }
    MouseMove, save_x, save_y
    Return
}
