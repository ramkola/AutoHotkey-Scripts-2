import os.path

# this procedure is case sensitive
notepad.new()
editor.paste()
filename = editor.getText()
editor.setSavePoint()           # avoid save file on exit prompt
notepad.close()

if os.path.isfile(filename):
    notepad.activateFile(filename)
    if notepad.getCurrentFilename() != filename:
        notepad.open(filename)

cur_filename = notepad.getCurrentFilename()
result = (cur_filename == filename)
editor.copyText(str(result))

# console.write('cur_filename: ' + str(cur_filename) + '\n')
# console.write('result = ' + str(result) + '\n')
