/*
C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts\MyScripts\SciTE\new 1.ahk * SciTE4AutoHotkey [5 of 5]
ahk_class SciTEWindow ahk_exe SciTE.exe

ClassNN:	SciTeTabCtrl1
Text:	Tab
	x: 8	y: 75	w: 1280	h: 24
Client:	x: 0	y: 24	w: 1280	h: 24
*/
#Include new 2.ahk
OutputDebug, DBGVIEWCLEAR
ControlGetPos,x,y,w,h,SciTeTabCtrl1,A
OutputDebug, % "x, y, w, h: " x ", " y ", " w ", " h
WinActivate, ahk_class dbgviewClass ahk_exe Dbgview.exe