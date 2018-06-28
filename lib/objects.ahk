 def_hotkey_rec := {"hot_key": ""    ; the whole key as input in the file
    , "firing_key": ""           ; activation key without modifiers or prefix (ie: the 'c' in  ^!+c::)    
    , "prefix_key": ""           ; the first key defined in a combination (the 'p' in p & Numpad0::)
    , "key3": ""                 ; special combo key cases reserved.
    , "translated": ""           ; converts ^!p to Ctrl+Alt+p   
    , "win_key": False
    , "alt_key": False
    , "control_key": False
    , "shift_key": False
    , "left_key": False          ; <+s = LShift & s
    , "right_key": False         ; >!z = RAlt & z
    , "alt_gr": False            ; <^>! = special key on some keyboards
    , "tilde": False 
    , "wildcard": False
    , "dollar_sign": False
    , "ampersand": False
    , "comment": ""
    , "scope": hotkey_rec["scope"]}