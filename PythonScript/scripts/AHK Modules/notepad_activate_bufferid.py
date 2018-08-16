def main():
    from Npp import notepad

    bufferID = param1
    result = False
    if bufferID.isdigit():
        bufferID = int(bufferID)
        notepad.activateBufferID(bufferID)

    activated_bufferID = notepad.getCurrentBufferID()
    result = (activated_bufferID == bufferID)
    return str(result)

return_code = main()
