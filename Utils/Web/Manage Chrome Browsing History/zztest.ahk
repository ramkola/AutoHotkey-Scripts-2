#Include C:\Users\Mark\Desktop\Misc\AutoHotkey Scripts
#Include lib\Class_SQLiteDB.ahk

SetWorkingDir %A_ScriptDir%

Gui, Add, ListView, xp+10 yp+18 w760 h300 vResultsLV ;+LV0x00010000
Gui, Show

source = C:\Users\Mark\AppData\Local\Google\Chrome\User Data\Default\History
dest = History.db
FileDelete, %dest%
FileCopy, %source%, %dest%, 1
If ErroLevel
{
    MsgBox, % "ErrorLevel: " ErrorLevel " - Line#" A_LineNumber " (" A_ScriptName " - " A_ThisFunc ")"
    exit_func()
}
osqlite := new SQLiteDB
If !osqlite.OpenDB(dest) {
   MsgBox, 16, SQLite Error, % "Msg:`t" . osqlite.ErrorMsg . "`nCode:`t" . osqlite.ErrorCode
   ExitApp
}

result_view := ""
If !osqlite.GetTable("SELECT id, url, title FROM urls;", result_view)
   MsgBox, 16, SQLite Error: GetTable, % "Msg:`t" . osqlite.ErrorMsg . "`nCode:`t" . osqlite.ErrorCode
show_table(result_view)
Return

show_table(Table) {
   Global
   Local ColCount, RowCount, Row
   GuiControl, -ReDraw, ResultsLV
   LV_Delete()
   ColCount := LV_GetCount("Column")
   Loop, %ColCount%
      LV_DeleteCol(1)
   If (Table.HasNames) {
      Loop, % Table.ColumnCount
         LV_InsertCol(A_Index,"", Table.ColumnNames[A_Index])
      If (Table.HasRows) {
         Loop, % Table.RowCount {
            RowCount := LV_Add("", "")
            Table.Next(Row)
            Loop, % Table.ColumnCount
               LV_Modify(RowCount, "Col" . A_Index, Row[A_Index])
         }
      }
      Loop, % Table.ColumnCount
         LV_ModifyCol(A_Index, "AutoHdr")
   }
   GuiControl, +ReDraw, ResultsLV
}
ExitApp

exit_func()
{
    ExitApp
}
GuiEscape:
GuiClose:
   ExitApp