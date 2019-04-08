; exit_app()
; {
    ; ExitApp
; }

map_list := ["Random","Random Land Map","Arabia","Archipelago","Arena","Baltic","Black Forest"
	, "Coastal","Continental","Ghost Lake","Gold Rush","Highland","Islands","Mediterranean"
	, "Mongolia","Oasis","Rivers","Salt Marsh","Scandinavia","Team Islands","Yucatan"]
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

