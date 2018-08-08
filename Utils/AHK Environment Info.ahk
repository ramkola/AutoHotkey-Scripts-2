ahk_info := ""
ahk_info .= A_AhkPath 
ahk_info .= "`r`n" 
ahk_info .= A_AhkVersion 
ahk_info .= " - " 
ahk_info .= (A_IsUnicode = 1) ? "Unicode" : "ANSI"
ahk_info .= " - " 
ahk_info .= (A_PtrSize = 8) ? " 64 bit EXE" : " 32 bit EXE"
ahk_info .= " - " 
ahk_info .= (A_IsAdmin = 1) ? " Admin" : " Not Admin"
ahk_info .= "`r`n" 
ahk_info .= A_OSType
ahk_info .= " - " 
ahk_info .= A_OSVersion
ahk_info .= " - " 
ahk_info .= (A_Is64bitOS = 1) ? " 64 bit OS" : " 32 bit OS"
ahk_info .= "`r`n" 
ahk_info .= A_ScreenWidth " x " A_ScreenHeight " DPI: " A_ScreenDPI 
ahk_info .= "`r`n" 
ahk_info .= "`r`n" 
ahk_info .= "PYTHON INTERPRETER INFO: "
ahk_info .= "Python 2.7.15 (v2.7.15:ca079a3ea3, Apr 30 2018, 16:22:17) [MSC v.1500 32 bit (Intel)]" 

Clipboard := ahk_info
MsgBox, % ahk_info
