; Missing keywords for: Menu, Gui, Class, Process, Com, Object ....

get_command_list()
{
word_list =
(
#ClipboardTimeout
#CommentFlag
#Delimiter
#DerefChar
#ErrorStdOut
#EscapeChar
#HotkeyInterval
#HotkeyModifierTimeout
#Hotstring
#If
#IfTimeout
#IfWinActive
#IfWinExist
#IfWinNotActive
#IfWinNotExist
#Include
#IncludeAgain
#InputLevel
#InstallKeybdHook
#InstallMouseHook
#KeyHistory
#LTrim
#MaxHotkeysPerInterval
#MaxMem
#MaxThreads
#MaxThreadsBuffer
#MaxThreadsPerHotkey
#MenuMaskKey
#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance
#UseHook
#Warn
#WinActivateForce
Abs
ACos
Asc
ASin
ATan
AutoTrim
BlockInput
Break
Catch
Ceil
Chr
Click
ClipWait
ComObjActive
ComObjArray
ComObjConnect
ComObjCreate
ComObject
ComObjEnwrap
ComObjError
ComObjFlags
ComObjGet
ComObjMissing
ComObjParameter
ComObjQuery
ComObjType
ComObjUnwrap
ComObjValue
Continue
Control
ControlClick
ControlFocus
ControlGet
ControlGetFocus
ControlGetPos
ControlGetText
ControlMove
ControlSend
ControlSendRaw
ControlSetText
CoordModeSets
Cos
Critical
DetectHiddenText
DetectHiddenWindows
DllCall
Drive
DriveGet
DriveSpaceFree
Edit
Else
EnvAdd
EnvDiv
EnvGet
EnvMult
EnvSet
EnvSub
EnvUpdate
Exception
Exit
ExitApp
Exp
FileAppend
FileCopy
FileCopyDir
FileCreateDir
FileCreateShortcut
FileDelete
FileEncoding
FileExist
FileGetAttrib
FileGetShortcut
FileGetSize
FileGetTime
FileGetVersion
FileInstall
FileMove
FileMoveDir
FileOpen
FileRead
FileReadLine
FileRecycle
FileRecycleEmpty
FileRemoveDir
FileSelectFile
FileSelectFolder
FileSetAttrib
FileSetTime
Finally
Floor
For
Format
FormatTime
Func
GetKeyName
GetKeySC
GetKeyState
GetKeyVK
Gosub
Goto
GroupActivate
GroupAdd
GroupClose
GroupDeactivate
Gui
GuiControl
GuiControlGet
Hotkey
Hotstring
If
IfEqual
IfExist
IfGreater
IfGreaterOrEqual
IfInString
IfLess
IfLessOrEqual
IfMsgBox
IfNotEqual
IfNotExist
IfNotInString
IfWinActive
IfWinExist
IfWinNotActive
IfWinNotExist
IL_Add
IL_Create
IL_Destroy
ImageSearch
IniDelete
IniRead
IniWrite
Input
InputBox
InStr
InStr
InStr
IsByRef
IsFunc
IsLabel
IsObject
KeyHistory
KeyWait
ListHotkeys
ListLines
ListVars
Ln
LoadPicture
Log
Loop
LTrim
LV_Add
LV_Delete
LV_DeleteCol
LV_GetCount
LV_GetNext
LV_GetText
LV_Insert
LV_InsertCol
LV_Modify
LV_ModifyCol
LV_SetImageList
Max
Menu
MenuGetHandle
MenuGetName
Min
Mod
MouseClick
MouseClickDrag
MouseGetPos
MouseMove
MsgBox
Not
NumGet
NumPut
ObjAddRef
ObjBindMethod
ObjClone
ObjCount
ObjDelete
ObjGetAddress
ObjGetBase
ObjGetCapacity
ObjHasKey
ObjInsert
ObjInsertAt
ObjLength
ObjMaxIndex
ObjMinIndex
ObjNewEnum
ObjPop
ObjPush
ObjRawGet
ObjRawSet
ObjRelease
ObjRemove
ObjRemoveAt
ObjSetBase
ObjSetCapacity
OnClipboardChange
OnExit
OnMessage
Ord
OutputDebug
Pause
Parse
PixelGetColor
PixelSearch
PostMessage
Process
Progress
Random
RegDelete
RegExMatch
RegExReplace
RegisterCallback
RegRead
RegWrite
Reload
Return
Round
RTrim
Run
RunAs
RunWait
SB_SetIcon
SB_SetParts
SB_SetText
Send
SendEvent
SendInput
SendLevel
SendMessage
SendMode
SendPlay
SendRaw
SetBatchLines
SetCapsLockState
SetControlDelay
SetDefaultMouseSpeed
SetEnv
SetFormat
SetKeyDelay
SetMouseDelay
SetNumLockState
SetRegView
SetScrollLockState
SetStoreCapsLockMode
SetTimer
SetTitleMatchMode
SetWinDelay
SetWorkingDir
Shutdown
Sin
Sleep
Sort
SoundBeep
SoundGet
SoundGetWaveVolume
SoundPlay
SoundSet
SoundSetWaveVolume
SplashImage
SplashTextOff
SplashTextOn
SplitPath
Sqrt
StatusBarGetText
StatusBarWait
StrGet
StringCaseSense
StringGetPos
StringLeft
StringLen
StringLower
StringMid
StringReplace
StringRight
StringSplit
StringTrimLeft
StringTrimRight
StringUpper
StrLen
StrPut
StrReplace
StrSplit
SubStr
Suspend
SysGet
Tan
Thread
Throw
ToolTip
Transform
TrayTip
Trim
Try
TV_Add
TV_Delete
TV_Get
TV_GetChild
TV_GetCount
TV_GetNext
TV_GetParent
TV_GetPrev
TV_GetSelection
TV_GetText
TV_Modify
TV_SetImageList
Until
UrlDownloadToFile
VarSetCapacity
While
WinActivate
WinActivateBottom
WinActive
WinClose
WinExist
WinGet
WinGetActiveStats
WinGetActiveTitle
WinGetClass
WinGetPos
WinGetText
WinGetTitle
WinHide
WinKill
WinMaximize
WinMenuSelectItem
WinMinimize
WinMinimizeAll
WinMinimizeAllUndo
WinMove
WinRestore
WinSet
WinSetTitle
WinShow
WinWait
WinWaitActive
WinWaitClose
WinWaitNotActive
)
word_list .= "`n" ; needed so that first word from the following list doesn't append to the last word of this list. 
Return %word_list%
}

get_builtin_vars_list()
{
word_list =
(
A_AhkPath
A_AhkVersion
A_AppData
A_AppDataCommon
A_Args
A_AutoTrim
A_BatchLines
A_CaretX
A_CaretY
A_ComputerName
A_ComSpec
A_ControlDelay
A_CoordModeCaret
A_CoordModeMenu
A_CoordModeMouse
A_CoordModePixel
A_CoordModeToolTip
A_Cursor
A_DD
A_DDD
A_DDDD
A_DefaultGui
A_DefaultListView
A_DefaultMouseSpeed
A_DefaultTreeView
A_Desktop
A_DesktopCommon
A_DetectHiddenText
A_DetectHiddenWindows
A_EndChar
A_EventInfo
A_ExitReason
A_FileEncoding
A_FormatFloat
A_FormatInteger
A_Gui
A_GuiControl
A_GuiEvent
A_GuiHeight
A_GuiWidth
A_GuiX
A_GuiY
A_Hour
A_IconFile
A_IconHidden
A_IconNumber
A_IconTip
A_Index
A_IPAddress1
A_IPAddress2
A_IPAddress3
A_IPAddress4
A_Is64bitOS
A_IsAdmin
A_IsCompiled
A_IsCritical
A_IsPaused
A_IsSuspended
A_IsUnicode
A_KeyDelay
A_KeyDelayPlay
A_KeyDuration
A_KeyDurationPlay
A_Language
A_LastError
A_LineFile
A_LineNumber
A_ListLines
A_LoopField
A_LoopFileName
A_LoopReadLine
A_LoopRegName
A_MDay
A_Min
A_MM
A_MMM
A_MMMM
A_Mon
A_MouseDelay
A_MouseDelayPlay
A_MSec
A_MyDocuments
A_Now
A_NowUTC
A_NumBatchLines
A_OSType
A_OSVersion
A_PriorHotkey
A_PriorKey
A_ProgramFiles
A_Programs
A_ProgramsCommon
A_PtrSize
A_RegView
A_ScreenDPI
A_ScreenHeight
A_ScreenWidth
A_ScriptDir
A_ScriptFullPath
A_ScriptHwnd
A_ScriptName
A_Sec
A_SendLevel
A_SendMode
A_Space
A_StartMenu
A_StartMenuCommon
A_Startup
A_StartupCommon
A_StoreCapsLockMode
A_StringCaseSense
A_Tab
A_Temp
A_ThisFunc
A_ThisHotkey
A_ThisLabel
A_ThisMenu
A_ThisMenuItem
A_ThisMenuItemPos
A_TickCount
A_TimeIdle
A_TimeIdleKeyboard
A_TimeIdleMouse
A_TimeIdlePhysical
A_TimeSincePriorHotkey
A_TimeSinceThisHotkey
A_TitleMatchMode
A_TitleMatchModeSpeed
A_UserName
A_WDay
A_WinDelay
A_WinDir
A_WorkingDir
A_YDay
A_Year
A_YWeek
A_YYYY
)
word_list .= "`n" ; needed so that first word from the following list doesn't append to the last word of this list. 
Return %word_list%
}

get_keyboard_list()
{
word_list =
(
Alt
AppsKey
BackSpace
Break
Bs
Browser_Back
Browser_Favorites
Browser_Forward
Browser_Home
Browser_Refresh
Browser_Search
Browser_Stop
CapsLock
Control
Ctrl
CtrlBreak
Del
Delete
Down
End
Enter
Esc
Escape
F1
F10
F11
F12
F13
F14
F15
F16
F17
F18
F19
F2
F20
F21
F22
F23
F24
F3
F4
F5
F6
F7
F8
F9
Help
Home
Ins
Insert
LAlt
Launch_App1
Launch_App2
Launch_Mail
Launch_Media
LButton
LControl
Left
LShift
LWin
MButton
Media_Next
Media_Play_Pause
Media_Prev
Media_Stop
NumLock
Numpad0
Numpad1
Numpad2
Numpad3
Numpad4
Numpad5
Numpad6
Numpad7
Numpad8
Numpad9
NumpadAdd
NumpadClear
NumpadDel
NumpadDiv
NumpadDot
NumpadDown
NumpadEnd
NumpadEnter
NumpadHome
NumpadIns
NumpadLeft
NumpadMult
NumpadPgDn
NumpadPgUp
NumpadRight
NumpadSub
NumpadUp
Pause
PgDn
PgUp
PrintScreen
RAlt
RButton
RControl
Right
RShift
RWin
ScrollLock
Shift
Sleep
Space
Tab
Up
Volume_Down
Volume_Mute
Volume_Up
WheelDown
WheelLeft
WheelRight
WheelUp
XButton1
XButton2
)
word_list .= "`n" ; needed so that first word from the following list doesn't append to the last word of this list. 
Return %word_list%
}

get_misc_list()
{
word_list =
(
ahk_
False
On
Off
True
)
; word_list .= "`n" ; not needed if this is the last list. ; needed so that first word from the following list doesn't append to the last word of this list. 
Return %word_list%
}