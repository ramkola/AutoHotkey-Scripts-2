notepad.new()
editor.paste()
bufferID = editor.getText()
editor.setSavePoint()           # avoid save file on exit prompt
notepad.close()

if bufferID.isdigit():
    bufferID = int(bufferID)
    notepad.activateBufferID(bufferID)

result = notepad.getCurrentFilename()
editor.copyText(result)

