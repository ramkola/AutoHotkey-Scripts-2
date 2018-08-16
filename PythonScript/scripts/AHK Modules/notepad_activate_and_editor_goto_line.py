def notepad_activate_and_editor_goto_line():
    from Npp import notepad, editor, console
    from os.path import isfile
    from time import sleep
  
    line_num = param1
    filename = param2

    if not isfile(filename) or not line_num.isdigit():
        console.write('Bad Params.\n')
        console.write('line_num: ' + str(line_num) + '\n')
        console.write('filename: ' + filename + '\n')
        return str(False)

    notepad.activateFile(filename)
    if notepad.getCurrentFilename() != filename:
        notepad.open(filename)
    
    sleep(.05)
    line_num = int(line_num)
    editor.gotoLine(line_num)
    editor.setFirstVisibleLine(line_num)
    sleep(.01)
    editor.home()
    editor.lineEndExtend()

    result = (filename == notepad.getCurrentFilename())
    return str(result)

return_code = notepad_activate_and_editor_goto_line()    