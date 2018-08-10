from ctypes import *
import win32api
import win32con
import win32gui
import os
import sys

# import win32process
# import win32ui
# import struct
# import array
# import time

script_dir = os.path.dirname(notepad.getCurrentFilename())
os.chdir(script_dir)
sys.path.append(script_dir)
import ahk_constants as ahk


class ACOPYDATASTRUCT(Structure):
    _fields_ = [
        ('dwData', c_ulong),
        ('cbData', c_ulong),
        ('lpData', c_void_p)
    ]
PCOPYDATASTRUCT = POINTER(ACOPYDATASTRUCT)

class Listener:

    def __init__(self):
        message_map = {
            win32con.WM_COPYDATA: self.OnCopyData
        }
        wc = win32gui.WNDCLASS()
        wc.lpfnWndProc = message_map
        wc.lpszClassName = 'PythonAhkReceiver'
        hinst = wc.hInstance = win32api.GetModuleHandle(None)
        classAtom = win32gui.RegisterClass(wc)
        self.hwnd = win32gui.CreateWindow (
            classAtom,                  # LPCTSTR   lpClassName
            ahk.RECEIVER_MODULE_NAME,   # LPCTSTR   lpWindowName
            win32con.WS_VISIBLE,        # DWORD     dwStyle
            # 0,                          # DWORD     dwStyle
            -800,                       # int       x
            400,                        # int       y
            200,                        # int       nWidth
            200,                        # int       nHeight
            0,                          # HWND      hWndParent
            0,                          # HMENU     hMenu
            hinst,                      # HINSTANCE hInstance
            None                        # LPVOID    lpParam
        )

        try:
            os.remove(ahk.PYTHON_AHK_MESSAGE_FILE)
        except:
            pass
        with open(ahk.PYTHON_AHK_MESSAGE_FILE, 'w') as out_file:
                out_file.write(hex(self.hwnd))        

        editor.copyText(hex(self.hwnd))
        console.write('hwnd dec: ' + str(self.hwnd) + ' hex: ' + hex(self.hwnd) + "\n")
        # console.write('hinst: ' + str(hinst) + '\n')
        # console.write('classAtom: ' + str(classAtom) + '\n')

    def OnCopyData(self, hwnd, msg, wparam, lparam):
        # print 'hwnd  : ' + str(hwnd) + ' hex: ' + hex(hwnd)
        # print 'WM#   : ' + str(msg)
        # print 'wparam: ' + str(wparam)
        # print 'lparam: ' + str(lparam)
        # win32gui.PostQuitMessage(0)
        pCDS = cast(lparam, PCOPYDATASTRUCT)
        message_text = wstring_at(pCDS.contents.lpData)
        result = self.message_handler(message_text)
        return result

    def message_handler(self, p_message):
        console.write(p_message + '\n')
        return 99991


console.show()
console.clear()
l = Listener()
win32gui.PumpMessages()