OutputDebug, DBGVIEWCLEAR

#SingleInstance Force
#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\pango_level.ahk
#Include lib\utils.ahk
SetTitleMatchMode 2

ade_wintitle = ahk_exe DigitalEditions.exe
If Not WinExist(ade_wintitle)
{
    MsgBox, 48,, % "Start Adobe Digital Editions program and go to first page of book to be copied."
    Return
}

; create directory to save ebook
WinActivate, %ade_wintitle%
WinGetActiveTitle, book_name
book_name := StrReplace(book_name, "Adobe Digital Editions - ", "")
dir_name := "C:\Users\Mark\Documents\eBooks\" book_name
FileCreateDir, %dir_name%

; make sure ADE is in full screen
result = 0
While Not result
    result := pango_level(100)
If result = -999
    Return
ImageSearch, x, y, 0, 0, 500, 50,*2 C:\Users\Mark\Desktop\Misc\Resources\Images\Adobe Digital Editions\library - pango 100.png
If ErrorLevel
    SendInput ^+f   ; full screen

; copy ebook
WinActivate, %ade_wintitle%
num_pages = 0
While Not (num_pages > 0) Or Not RegexMatch(num_pages,"\d+")
    InputBox, num_pages, %book_name%, `r`n`r`nEnter number of pages to copy

max_digits := StrLen(num_pages)
countx = 1
While (countx <= num_pages)
{
    WinActivate, %ade_wintitle%
    filename := dir_name Format("Page-{:0" max_digits "}", countx)
    save_page(filname)
    countx++
}


EBOOK_EXIT: 
result = 0
While Not result
    result := pango_level(70)
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe
WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
ExitApp

save_page(p_filename)
{
    irfanview_wintitle = ahk_class IrfanView ahk_exe i_view64.exe
    file_save_dlg = Save Picture As ... ahk_class #32770 ahk_exe i_view64.exe
    Clipboard := ""
    SendInput {PrintScreen}
    If Not WinExist(irfanview_wintitle)
        Run, C:\Program Files\IrfanView\i_view64.exe
    While Not WinActive(irfanview_wintitle)
    {
        WinActivate, %irfanview_wintitle%
        Sleep 1
        msgbox
    }
    SendInput !ep   ; edit/paste 
    SendInput !fs   ; file/save
    WinGetActiveTitle, wt
    MsgBox, % "wt: " wt
    WinWaitActive, %file_save_dlg%, 2
    ControlSend, Edit1, %p_filename%, %irfanview_wintitle%
    Sleep 100
    SendInput {Enter}
    Return
}

^+x::ExitApp
