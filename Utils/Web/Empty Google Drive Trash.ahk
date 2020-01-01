wt = Trash - Google Drive - Google Chrome
WinActivate, %wt%
WinWaitActive, %wt%
Loop
{
    If Not WinActive(wt)
        Break
        
    Click, Left  ,  303,  197
    Sleep 500
    Click, Left  ,  350,  243
    Sleep 500
    Click, Left  ,  698,  612
    Sleep 10000
}

ExitApp

^+p::Pause
^+x::ExitApp
