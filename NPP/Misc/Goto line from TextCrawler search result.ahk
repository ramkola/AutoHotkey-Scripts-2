#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\npp.ahk
#NoTrayIcon
SetTitleMatchMode 3
textcrawler_wintitle = TextCrawler 3 ahk_class WindowsForms10.Window.8.app.0.378734a ahk_exe TextCrawler.exe
textcrawler_classnn = WindowsForms10.RichEdit20W.app.0.378734a1
npp_wintitle = ahk_class Notepad++ ahk_exe notepad++.exe

ControlGet, richedit_line_num, CurrentLine,, %textcrawler_classnn%, %textcrawler_wintitle%
ControlGet, line_text, Line, %richedit_line_num%, %textcrawler_classnn%, %textcrawler_wintitle%
If RegExMatch(line_text, "i)^\s+\d+\s+.*$")
{
    ; caret is on a line starting with a line#
    goto_line_num := RegExReplace(line_text, "i)^\s+(\d+)\s+.*$", "$1")
    ; search backwards, 1 line at a time, to find the line containing the filename
    While Not RegExMatch(goto_filename, "i)^\s?[a-z]:\\.*\.*$")
    {
        richedit_line_num -= 1
        ControlGet, goto_filename, Line, %richedit_line_num%, %textcrawler_classnn%, %textcrawler_wintitle%
    }
}   
Else If RegExMatch(line_text, "i)^\s?[a-z]:\\.*\.*$")
{
    ; caret is on a line starting with filename
    goto_filename := line_text
    ControlGet, line_text, Line, % richedit_line_num + 1, %textcrawler_classnn%, %textcrawler_wintitle%
    goto_line_num := RegExReplace(line_text, "i)^\s+(\d+)\s+.*$", "$1")
}
Else
{
    MsgBox, 48,, % "Caret is not on a known type of line in TextCrawler`r`nFilename: " goto_filename " - Line# " goto_line_num
    Goto TEXTCRAWLER_EXIT
}

goto_filename := Trim(StrReplace(goto_filename, "`r", ""))
If npp_open_file(goto_filename)
    nppexec_goto_line(goto_line_num)
Else
   
 MsgBox, 48,, % "Something went wrong opening filename: " goto_filename

TEXTCRAWLER_EXIT:
ExitApp 