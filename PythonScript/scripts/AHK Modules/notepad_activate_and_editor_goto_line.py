import os.path
import time
x = notepad.getCurrentFilename()
if x == r'C:\Users\Mark\AppData\Roaming\Notepad++\plugins\Config\PythonScript\scripts\AHK Modules\notepad_activate_and_editor_goto_line.py':
    debug_state = True
else:
    debug_state = False

# this procedure is case sensitive
notepad.new()
editor.paste()
clip_board = editor.getText()
editor.setSavePoint()           # avoid save file on exit prompt
notepad.close()

# if debug_state:
    # clip_board = '120\x07C:\\Users\\Mark\\Desktop\\Misc\\AutoHotkey Scripts\\lib\\npp.ahk'

editor.copyText(False)
pos = clip_board.find('\x07')
line_num = clip_board[0:pos]        
filename = clip_board[pos+1:]

if debug_state:
    console.show()
    console.clear()
    time.sleep(.3)
    console.write('clip_board: ' + clip_board + '\n')
    console.write('line_num: '   + line_num   + '\n')
    console.write('filename: '   + filename   + '\n')

if os.path.isfile(filename):
    notepad.activateFile(filename)
    time.sleep(.1)
    if notepad.getCurrentFilename() == filename:
        if debug_state:
            console.write('File was already open.\n')
    else:
        notepad.open(filename)
        if debug_state:
            console.write('File was closed, had to open it.\n')

    if line_num.isdigit():
        line_num = int(line_num)
        editor.gotoLine(line_num)
        editor.home()
        editor.lineEndExtend()

cur_filename = notepad.getCurrentFilename()
result = (cur_filename == filename)
editor.copyText(result)

if debug_state:
    console.write('cur_filename: ' + str(cur_filename) + '\n')
    console.write('result = ' + str(result) + '\n')