def main():
    from Npp import notepad
    from os.path import isfile
    
    filename = param1
    result = False
    if isfile(filename):
        notepad.activateFile(filename)
        if notepad.getCurrentFilename() != filename:
            notepad.open(filename)
    
    cur_filename = notepad.getCurrentFilename()
    result = (cur_filename == filename)
    return str(result)

return_code = main()