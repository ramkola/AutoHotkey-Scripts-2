;-----------------------------
; PythonScript directories 
;-----------------------------
:R*:pssx::C:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\PythonScript\scripts\
:R*:psox::C:\Users\Mark\Desktop\Misc\PythonScript
;-----------------------------
; PythonScript programming
;-----------------------------
:*:mainx::if __name__ == "__main__":{Enter}{Tab}
:*:docx::print(.__doc__){Left 9}
:*:psx::PythonScript
:*:edx::editor.(){Left 2}
:*:cox::console.(){Left 2} 
:*:cowx::console.write('' p '\n'){Left 9}
:*:nox::notepad.(){Left 2}
:*:clearx::console.clear(){Enter}
:*:cwdx::import os;os.getcwd(){Enter}
:*:ccb::notepad.clearCallbacks(){Enter}
:*:cb32::import win32clipboard;win32clipboard.OpenClipboard();win32clipboard.CloseClipboard(){Enter}
