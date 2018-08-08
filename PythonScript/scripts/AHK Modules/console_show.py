save_current_filename = notepad.getCurrentFilename()
notepad.new()
editor.paste()
clip_board = editor.getText()
editor.setSavePoint()           # avoid save file on exit prompt
notepad.close()
notepad.activateFile(save_current_filename)

# console.write("clip_board: " + clip_board + "\n")

console.show()
if clip_board == "1":
    console.clear()

editor.copyText("True")