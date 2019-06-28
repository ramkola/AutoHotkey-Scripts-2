def_hotkey_rec := 
(Join LTrim Comments
    {
          "hot_key": ""          ; the whole key as input in the file
        , "firing_key": ""       ; activation key without modifiers or prefix (ie: the 'c' in  ^!+c::)    
        , "prefix_key": ""       ; the first key defined in a combination (the 'p' in p & Numpad0::)
        , "key3": ""             ; special combo key cases reserved.
        , "translated": ""       ; converts ^!p to Ctrl+Alt+p   
        , "win_key": False  
        , "alt_key": False  
        , "control_key": False  
        , "shift_key": False    
        , "left_key": False      ; <+s = LShift & s
        , "right_key": False     ; >!z = RAlt & z
        , "alt_gr": False        ; <^>! = special key on some keyboards
        , "tilde": False    
        , "wildcard": False
        , "dollar_sign": False
        , "ampersand": False
        , "comment": ""
        , "scope": hotkey_rec["scope"]
    }
)

    
def_procedure_call := 
(Join LTrim 
    {
          "library": ""
        , "procedure_call": ""
        , "name": ""
        , "param_string": ""
        , "param_list": []
        , "comment": ""
        , "multiline": ""
        , "separate": ""
    }
)
 
Class mouse_hook{
	; User methods
	hook(){
		If !this.hHook												; WH_MOUSE_LL := 14									  hMod := 0	 dwThreadId := 0
            this.hHook := DllCall("User32.dll\SetWindowsHookEx", "Int", 14, "Ptr", this.regCallBack := RegisterCallback(this.low_level_mouse_proc,"",4, &this), "Uint", 0, "Uint", 0, "Ptr")
		Return
	}
	unHook(){
		If this.hHook
			DllCall("User32.dll\UnhookWindowsHookEx", "Uint", this.hHook)
		Return this.hHook:=""
	}
	; Internal methods.
	__new(callbackFunc){
		(this.callbackFunc:= IsObject(callbackFunc)  ? callbackFunc : IsFunc(callbackFunc) ? Func(callbackFunc) : "")
		If !this.callbackFunc
			Throw Exception("invalid callbackFunc")
	}
	low_level_mouse_proc(args*) {  
		; (nCode, wParam, lParam)
		Critical
		this := Object(A_EventInfo)
        nCode := NumGet(args-A_PtrSize,"Int")
        wParam := NumGet(args+0,0,"Ptr")
        lParam := NumGet(args+0,A_PtrSize,"UPtr") 
		
        x := NumGet(lParam+0,0,"Int")
        y := NumGet(lParam+0,4,"Int")
        flags := NumGet(lParam+0,12,"UInt")
		this.callbackFunc.Call(flags,x,y)
            
		Return DllCall("User32.dll\CallNextHookEx","Uint",0, "Int", nCode,"Uptr", wParam,"Ptr",lParam)
	}
	__Delete(){  
		this.unHook()
		If this.regCallBack
			DllCall("GlobalFree", "Ptr", this.regCallBack)
		Return 
	}
}