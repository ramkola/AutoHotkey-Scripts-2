import win32con
import ctypes
import ctypes.wintypes

FindWindow = ctypes.windll.user32.FindWindowA
SendMessage = ctypes.windll.user32.SendMessageA

class COPYDATASTRUCT(ctypes.Structure):
    _fields_ = [
        ('dwData', ctypes.wintypes.LPARAM),
        ('cbData', ctypes.wintypes.DWORD),
        ('lpData', ctypes.c_wchar_p) 
    ]


message_text = "test"

hwnd = FindWindow('AutoHotkeyGUI','Receive WM_COPYDATA from PythonScript')
print(hwnd)
 
cds = COPYDATASTRUCT()
cds.dwData = 0
cds.cbData = ctypes.sizeof(ctypes.create_unicode_buffer(message_text))
cds.lpData = ctypes.c_wchar_p(message_text)

SendMessage(hwnd, win32con.WM_COPYDATA, 0, ctypes.byref(cds))