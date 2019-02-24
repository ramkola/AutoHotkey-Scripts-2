cl_toggle := GetKeyState("CapsLock", "T")
if (cl_toggle = 0)
    MsgBox, 48,, % "Capslock logical state: OFF", 3
else if (cl_toggle = 1)
    MsgBox, 48,, % "Capslock logical state: ON", 3
else
    MsgBox, 48,, % "Capslock logical state: UNKNOWN - cl_toggle:" cl_toggle, 3

cl_toggle := GetKeyState("CapsLock", "P")
if (cl_toggle = 0)
    MsgBox, 48,, % "Capslock physical state: OFF", 3
else if (cl_toggle = 1)
    MsgBox, 48,, % "Capslock physical state: ON", 3
else
    MsgBox, 48,, % "Capslock physical state: UNKNOWN - cl_toggle:" cl_toggle, 3