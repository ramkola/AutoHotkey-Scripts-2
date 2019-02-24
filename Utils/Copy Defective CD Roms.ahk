#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\utils.ahk
#Include lib\strings.ahk
#Include lib\processes.ahk
#MaxMem 763 ; allow variable to hold 1 cd of bytes
g_TRAY_RELOAD_ON_LEFTCLICK := True      ; set only 1 to true to enable, see lib\utils.ahk
SetWorkingDir %A_ScriptDir%
OnExit, EXITNOW
Loop, Files, D:\*.*, F
{
    in_fullpath := A_LoopFileLongPath
    ; OutputDebug, % A_LoopFileSize
    ; OutputDebug, % A_LoopFileSizeKB
    ; OutputDebug, % A_LoopFileSizeMB
}
infile := FileOpen(in_fullpath, "r")
if !IsObject(infile)
{
    MsgBox % "Can't open: " in_fullpath
    return
}

SplitPath, in_fullpath, out_filename, out_dir, out_ext, out_name_no_ext, out_drive
out_fullpath := "C:\Users\Mark\Videos\" out_name_no_ext " (defective cd copy)." out_ext
outfile := FileOpen(out_fullpath, "w")
if !IsObject(outfile)
{
    MsgBox % "Can't create: " out_fullpath
    return
}

OutputDebug, % "info - starting defective cd copy of: " 
OutputDebug, % in_fullpath " to "
OutputDebug, % out_fullpath 

rw_num_bytes := 1000000 ; 800000000 ; 800,000,000 more than a whole CD
outvar := ""
total_bytes_read := 0
While not infile.AtEOF
{
    if infile.Length < total_bytes_read
    {
        OutputDebug, % "infile error reading past end of infle"
        break
    }
    bytes_read := infile.RawRead(invar, rw_num_bytes)
    outvar := outvar . invar
    total_bytes_read += bytes_read
    OutputDebug, % "info - bytes read: " 1000s_sep(infile.pos)

    ; skip over read errors
    if (bytes_read = 0 and Not infile.AtEOF)
    {
        OutputDebug, % "Read Error at current pos: " 1000s_sep(infile.pos)
        dbgp_breakpoint := True
        infile.seek(100000, 1)   ; one hundred thousand
        OutputDebug, % "Read Error. Skipping to pos: " 1000s_sep(infile.pos)
        continue
    }

    outfile.RawWrite(invar, bytes_read)
    OutputDebug, % "info - bytes written: " 1000s_sep(bytes_read)
    Sleep 10
}

EXITNOW:
infile.Close()
outfile.Close()
OutputDebug, % "total_bytes_read: " 1000s_sep(total_bytes_read)
OutputDebug, % "Defective CD Copy Done."
MsgBox, % "Defective CD Copy Done."
Drive, Eject, "D:"

WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
ExitApp