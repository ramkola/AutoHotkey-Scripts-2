; MyScripts dir
source1 = "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\*.*"
xplorer1 = "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\"
dest1  = "C:\Users\Mark\Documents\GitHub\AutoHotkey"
Run %ComSpec% /C xcopy %source1% %dest1% /S /Y
    
; lib dir
source2 = "C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\lib\*.*"
dest2  = "C:\Users\Mark\Documents\GitHub\AutoHotkey\lib"
Run %ComSpec% /C xcopy %source2% %dest2% /S /Y

; Python Scripts
source1 = "C:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\PythonScript\scripts\AHK Modules\*.*"
dest1  = "C:\Users\Mark\Documents\GitHub\AutoHotkey\PythonScript\scripts\AHK Modules\"
Run %ComSpec% /C xcopy %source1% %dest1% /S /Y

Run, C:\Users\Mark\AppData\Local\GitHubDesktop\GitHubDesktop.exe
Run, "C:\Program Files (x86)\zabkat\xplorer2_lite\xplorer2_lite.exe" /M %dest1% %xplorer1%

Sleep 1000
WinActivate, ahk_class ATL:ExplorerFrame ahk_exe xplorer2_lite.exe

ExitApp
