from ctypes import *
import win32api
import win32con
import win32gui
import os
import sys

script_dir = 'C:\\Users\\Mark\\AppData\\Roaming\\Notepad++\\plugins\\Config\\PythonScript\\scripts\\AHK Modules'
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

class receiver:
    
    countx = 1

    def __init__(self):
        message_map = {
            win32con.WM_COPYDATA: self.OnCopyData,
            win32con.WM_DESTROY: self.OnDestroy
        }
        wc = win32gui.WNDCLASS()
        wc.lpfnWndProc = message_map
        wc.lpszClassName = ahk.RECEIVER_CLASS_NAME
        hinst = wc.hInstance = win32api.GetModuleHandle(None)
        try:
            classAtom = win32gui.RegisterClass(wc)
        except Exception as err:
            self.error_handler(err, False)
            hwnd = FindWindow(ahk.RECEIVER_CLASS_NAME, ahk.RECEIVER_MODULE_NAME)
            self.OnDestroy(self, self.hwnd, 0, 0)
            win32gui.UnregisterClass(ahk.RECEIVER_CLASS_NAME, win32api.GetModuleHandle(None))
            classAtom = win32gui.RegisterClass(wc)

        self.hwnd = win32gui.CreateWindow (
            classAtom,                  # LPCTSTR   lpClassName
            ahk.RECEIVER_MODULE_NAME,   # LPCTSTR   lpWindowName
            win32con.WS_VISIBLE,        # DWORD     dwStyle
            # 0,                          # DWORD     dwStyle
            -1282,                      # int       x
            0,                          # int       y
            250,                        # int       nWidth
            20,                         # int       nHeight
            0,                          # HWND      hWndParent
            0,                          # HMENU     hMenu
            hinst,                      # HINSTANCE hInstance
            None                        # LPVOID    lpParam
        )

        try:
            os.remove(ahk.PYTHON_AHK_MESSAGE_FILE)
        except WindowsError as err:
            if err.errno == 2:
                pass
            else:
                raise err

        with open(ahk.PYTHON_AHK_MESSAGE_FILE, 'w') as out_file:
                out_file.write(hex(self.hwnd) + chr(7) + str(os.getpid()))        

    # def __del__(self):
         # console.write("*** ps_ahk_receiver object deleted ***" + '\n')
 
    def OnDestroy(self, hwnd, msg, wparam, lparam): 
        try:
            os.remove(ahk.PYTHON_AHK_MESSAGE_FILE)
        except WindowsError as err:
            if err.errno == 2:
                pass
            else:
                raise err
        # try:
            # win32api.CloseHandle(hwnd)
        # except Exception as err:
            # self.error_handler(err, False)

        # win32gui.DestroyWindow(hwnd)
        # try:
            # win32gui.UnregisterClass(ahk.RECEIVER_CLASS_NAME, win32api.GetModuleHandle(None))
        # except Exception as err:
            # self.error_handler(err, False)
        # win32gui.PostQuitMessage(0) 

    def OnCopyData(self, hwnd, msg, wparam, lparam):       
        pCDS = cast(lparam, PCOPYDATASTRUCT)
        message_text = wstring_at(pCDS.contents.lpData)
        result = self.message_handler(message_text)
        return result

    def message_handler(self, p_message):
        # p_message - string containing arguments delimited by a  chr(7) 'x\07'. 
        #       python_moduleparamparam....  
        # 
        # DOCUMENTATION NEEDED HERE
        #All PythonScripts should set a variable
        # called 'return_code' which will be stored in local_vars dict and sent back in 
        # send_message_from_python_to_autohotkey.
        # The key "return_code" is set by the python_module that is being executed
        # This just acknowledges that this message was handled - not whether 'python_module'
        # executed successfully or not.
        unicode_message = p_message.encode()
        params = unicode_message.split('\x07')  
        python_module = params[0] + ".py"
        module_compare_name = python_module.lower()
        # execfile global_vars (script_args) parameter is used for passing arguments to python_module
        script_args = dict()    
        if module_compare_name == 'notepad_activate_and_editor_goto_line.py':
           # param1 = Line number (str) Goes to this line if the line# exists otherwise goes to BOF/EOF    
           # param2 = Filename (str) Fullpath to the file that will be activated in Notepad++ 
           script_args = {'param1':params[1], 'param2':params[2]} 
        elif module_compare_name == 'notepad_activate_bufferid.py':
           # param1 = bufferID (str) 
           script_args = {'param1':params[1]} 
        elif module_compare_name == 'notepad_activate_file.py':
           # param1 = Filename (str) Fullpath to the file that will be activated in Notepad++ 
           script_args = {'param1':params[1]} 
        else:
            # All other Autohotkey scripts that don't need to pass arguments
            # to PythonScript module pass through here. 
            pass 
        # execute the PythonScript module and send back the result / return code.
        result = False
        local_vars = dict()     
        execfile(python_module, script_args, local_vars)
        result = local_vars["return_code"]
        # This sends the return code / string message back to Autohotkey
        self.send_message_from_python_to_autohotkey(result)
        return 1

    def send_message_from_python_to_autohotkey(self, p_message):
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
        
        hwnd = FindWindow(ahk.AHK_RECEIVER_CLASS_NAME, ahk.AHK_RECEIVER_MODULE_NAME)
        cds = COPYDATASTRUCT()
        cds.dwData = 0
        cds.cbData = ctypes.sizeof(ctypes.create_unicode_buffer(p_message))
        cds.lpData = ctypes.c_wchar_p(p_message)
        SendMessage(hwnd, win32con.WM_COPYDATA, 0, ctypes.byref(cds))

    def error_handler(self, p_err, p_abort):
        # error_number, error_message = p_err.args
        # console.write(error_message + '\n')
        # console.write(error_number)
        # console.write('\n')
        if p_abort:
            self.OnDestroy(self,self.hwnd,0,0)
        else:
            return


######################################################################################################

name_error = False
try:
    type(ps_ahk_receiver)
except NameError:
    name_error = True

if not name_error:
    del ps_ahk_receiver

ps_ahk_receiver = receiver()
win32gui.PumpMessages()

