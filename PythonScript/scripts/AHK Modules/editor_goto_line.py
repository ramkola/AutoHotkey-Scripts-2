import time

# retrieve line_num from clipboard
notepad.new()
editor.paste()
clip_board = editor.getText()
editor.setSavePoint()           # avoid save file on exit prompt
notepad.close()

pos = clip_board.find('\x07')
line_num = clip_board[0:pos]
filename = clip_board[pos+1:]

if line_num.isdigit():
    line_num = int(line_num)
    notepad.activateFile(filename)
    time.sleep(1)
    editor.gotoLine(line_num)
    editor.home()

# copy return result to clipboard
result = editor.lineFromPosition(editor.getCurrentPos())
editor.copyText(result)