;   Paths
AHK_MY_ROOT_DIR = C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts

;   Send Commands
SEND_COPYWORD = {Control Down}{Left}{Control Up}{Control Down}{Shift Down}{Right}{Shift Up}c{Control Up}{Right}
SEND_WORD_NAME_VALUE = `"{Control Down}v){Control Up}:{Space}`"{Space}.{Space}`"|`"{Space}.{Space}{Control Down}v{Control Up}{Space}.{Space}"|"
SEND_GREATER_THAN = {Space}.{Space}`">`"{Space}.{Space}
SEND_LESS_THAN = {Space}.{Space}`"<`"{Space}.{Space}
SEND_PIPE = {Space}.{Space}`"`|`"{Space}.{Space}
SEND_CRLF = "``r``n"
SEND_DOUBLESPACE = "``n``n"

;  SetTitleMatchMode
STM_STARTS = 1
STM_CONTAINS = 2
STM_EXACT = 3
STM_REGEX = RegEx
STM_SLOW = Slow
STM_FAST = Fast

;  MsgBox
MB_OK = 0
MB_OK_CANCEL = 1
MB_ABORT_RETRY_IGNORE = 2
MB_YES_NO_CANCEL = 3
MB_YES_NO = 4
MB_RETRY_CANCEL = 5
MB_CANCEL_TRY_CONT = 6
;
MB_ICON_ERROR = 16
MB_ICON_QUESTION = 32
MB_ICON_EXCLAMATION = 48
MB_ICON_INFO = 64
;
MB_DEFAULT_BUTTON_2 = 256
MB_DEFAULT_BUTTON_3 = 512
MB_DEFAULT_BUTTON_4 = 768
;
MB_SYSTEM_MODAL = 4096
MB_TASK_MODAL = 8192
MB_TOPMOST = 262144
;
MB_HELP_BUTTON = 16384
MB_RIGHT_JUSTIFIED = 524288
MB_RIGHT_TO_LEFT = 1048576