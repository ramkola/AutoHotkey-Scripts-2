explore_unexplored_map(p_scout_type := "Scout")
{
    Keywait Control
    Keywait Alt
    Keywait Shift
    saved_search_coords := []
    quad := []
    quad[1] := [ 845, 810, 1063,  917, "TL"]  ; top left
    quad[2] := [1063, 810, 1280,  917, "TR"]  ; top right
    quad[3] := [ 845, 917, 1063, 1024, "BL"]  ; bottom left
    quad[4] := [1063, 917, 1280, 1024, "BR"]  ; bottom right
    ; BlockInput, On
    If (p_scout_type = "Patrol")
        SendInput z        ; patrol
    SendInput ]            ; no attack stance
    SetMouseDelay 100
    For q_index, xy_coord in quad
    {
        x1 := xy_coord[1]
        y1 := xy_coord[2]
        x2 := xy_coord[3]
        y2 := xy_coord[4]
        quad_name := xy_coord[5]
        ImageSearch, x, y, %x1%, %y1%, %x2%, %y2%,*2 Pango 100 - Mini Map Unexplored Square.png
        If (ErrorLevel = 0)
        {
            saved_search_coords.push([x,y])
            SendInput +{Click, %x%, %y%}                    ; focus visible screen to unexplored area from minimap
            MouseMove, A_ScreenWidth/2, A_ScreenHeight/2    ; focus on unexplored visible screen area on game map
            SendInput +{Click, Right}                       ; send scout to middle of unexplored area on game map
        }
        OutputDebug, % Format("Quad: {} x{:4}, y{:4} ({:4},{:4},{:4},{:4})", quad_name, x, y, x1, y1, x2, y2)
        ; ttip(    "x , y : " x  ", " y 
        ; .    "`r`nx1, y1: " x1 ", " y1 
        ; .    "`r`nx2, y2: " x2 ", " y2 
        ; .    "`r`n - ErrorLevel: " ErrorLevel, 10000)
    }
    MouseMove, A_ScreenWidth/2, A_ScreenHeight/2    ; focus on visible screen area on game map
    Click, Right            ; Start scouting
    SendInput {BackSpace}   ; go back to previous view before this function was called
    BlockInput, Off
    
    OutputDebug, % "save_searched_coords: "
    for i, j in save_searched_coords
    {
        OutputDebug, % Format("{:02}) ", i) j 
    }

    Return
}

/*
template(p_scout_type := "Scout")
{
    Keywait Control
    Keywait Alt
    Keywait Shift
    BlockInput, On
    If (p_scout_type = "Patrol")
        SendInput z        ; patrol
    SendInput ]            ; no attack stance
    SetMouseDelay 50



    BlockInput, Off
    Return
}
*/
land_zigzag(p_scout_type := "Scout")
{
    Keywait Control
    Keywait Alt
    Keywait Shift
    BlockInput, On
    If (p_scout_type = "Patrol")
        SendInput z        ; patrol
    SendInput ]            ; no attack stance
    SetMouseDelay 50
    Click, Left  ,  872,  914
    SendInput {Shift Down}
    Click, Right ,  151,  162
    Click, Left  ,  962,  958
    Click, Right ,  787,  728
    Click, Left  , 1119,  852
    Click, Right , 1277,  406
    Click, Left  , 1212,  893
    Click, Right , 1158,  603
    Click, Left  , 1019,  983
    Click, Right ,  895,  771
    Click, Left  , 1053, 1008
    Click, Right , 1212,  790
    Click, Left  , 1250,  912
    Click, Right , 1220,  736
    Click, Left  , 1031,  836
    Click, Right ,  635,  307
    Click, Left  , 1054,  892
    Click, Right ,  966,  678
    Click, Left  ,  980,  874
    Click, Right ,  782,  621
    Click, Left  , 1005,  932
    Click, Right ,  788,  631
    Click, Left  , 1133,  909
    SendInput {Shift Up}
    Click, Right , 1061,  686
    BlockInput, Off
    Return
}

perimeter(p_scout_type := "Scout")
{
    Keywait Control
    Keywait Alt
    Keywait Shift
    BlockInput, On
    If (p_scout_type = "Patrol")
        SendInput z        ; patrol
    SendInput ]            ; no attack stance
    SetMouseDelay 50
    Click, 879, 916 Left    
    SendInput, {LShift Down}
    Click, 100, 109 Right   
    Click, 1064, 827 Left       
    Click, 1255, 54 Right
    Click, 1239, 918 Left
    Click, 1253, 769 Right
    Click, 1067, 1002 Left
    Click, 1036, 756 Right
    Click, 961, 952 Left
    Click, 778, 746 Right
    Click, 1120, 849 Left
    Click, 1137, 697 Right
    Click, 1186, 885 Left
    Click, 1170, 747 Right
    Click, 1004, 961 Left
    SendInput, {LShift Up}
    Click, Right    ; Start scouting
    BlockInput, Off
    Return
} 

visible_screen(p_scout_type := "Scout", p_keep_shift_down := False)
{
    Keywait Control
    Keywait Alt
    Keywait Shift
    BlockInput, On
    If (p_scout_type = "Patrol")
        SendInput z        ; patrol
    SendInput ]            ; no attack stance
    SendInput {Shift Down}
    Click, Right , 1229,   72
    Click, Right , 1258,  792
    Click, Right ,  867,  798
    Click, Right ,  805,   44
    Click, Right ,  484,   42
    Click, Right ,  462,  797
    Click, Right ,  166,  792
    Click, Right ,  245,   38
    Click, Right ,    4,   43
    Click, Right ,  115,  799
    If p_keep_shift_down
    {
        SendInput {Shift Up}
        Click, Right ,  365,  316
    }
    BlockInput, Off
    Return
}