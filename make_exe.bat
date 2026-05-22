@echo off
echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP%\run_jupyter.vbs"
echo WshShell.Run """C:\Python314\Scripts\jupyter.exe"" lab --notebook-dir=""D:\data_project""", 0, False >> "%TEMP%\run_jupyter.vbs"
echo Set WshShell = Nothing >> "%TEMP%\run_jupyter.vbs"
wscript "%TEMP%\run_jupyter.vbs"
