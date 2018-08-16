def main():
    from Npp import notepad, editor, console
    message_text = ''
    open_npp_file_info = notepad.getFiles()
    for tab_info in open_npp_file_info:
        filename = tab_info[0]
        bufferID = str(tab_info[1])
        index    = str(tab_info[2])
        view     = str(tab_info[3])
        message_text = message_text + filename + chr(7) + bufferID + chr(7) + index + chr(7) + view + "\r\n"

    return (message_text)

return_code = main()