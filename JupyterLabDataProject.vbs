Option Explicit

' ============================================================
'  JupyterLab Launcher  (D:\data_project)
'  - jupyter.exe 경로 자동 탐색 (지정 경로 → py 런처 → PATH)
'  - 작업 폴더가 없으면 자동 생성
'  - 실패 시 사용자에게 원인을 알려줌
' ============================================================

Dim WshShell, FSO
Set WshShell = CreateObject("WScript.Shell")
Set FSO       = CreateObject("Scripting.FileSystemObject")

' --- 설정 ---------------------------------------------------
Dim notebookDir : notebookDir = "D:\data_project"
Dim candidates  : candidates  = Array( _
    "C:\Python314\Scripts\jupyter.exe", _
    WshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\Programs\Python\Python314\Scripts\jupyter.exe"), _
    WshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\Programs\Python\Python313\Scripts\jupyter.exe"), _
    WshShell.ExpandEnvironmentStrings("%LOCALAPPDATA%\Programs\Python\Python312\Scripts\jupyter.exe") _
)

' --- 1) jupyter.exe 찾기 ------------------------------------
Dim jupyterPath, p
jupyterPath = ""
For Each p In candidates
    If FSO.FileExists(p) Then
        jupyterPath = p
        Exit For
    End If
Next

' 위에서 못 찾았으면 PATH 에서 검색 (where jupyter)
If jupyterPath = "" Then
    Dim exec, line
    Set exec = WshShell.Exec("cmd /c where jupyter")
    Do While Not exec.StdOut.AtEndOfStream
        line = Trim(exec.StdOut.ReadLine())
        If LCase(Right(line, 4)) = ".exe" And FSO.FileExists(line) Then
            jupyterPath = line
            Exit Do
        End If
    Loop
End If

If jupyterPath = "" Then
    MsgBox "jupyter.exe 를 찾을 수 없습니다." & vbCrLf & vbCrLf & _
           "다음 명령으로 JupyterLab을 먼저 설치해 주세요:" & vbCrLf & _
           "    pip install jupyterlab", _
           vbCritical, "JupyterLab Launcher"
    WScript.Quit 1
End If

' --- 2) 작업 폴더 확인/생성 ---------------------------------
If Not FSO.FolderExists(notebookDir) Then
    On Error Resume Next
    FSO.CreateFolder notebookDir
    If Err.Number <> 0 Then
        MsgBox "작업 폴더를 만들 수 없습니다: " & notebookDir & vbCrLf & _
               Err.Description, vbCritical, "JupyterLab Launcher"
        WScript.Quit 2
    End If
    On Error Goto 0
End If

' --- 3) JupyterLab 실행 -------------------------------------
Dim cmd
cmd = """" & jupyterPath & """ lab --notebook-dir=""" & notebookDir & """"

' 두 번째 인자 0 = 창 숨김, False = 종료 대기 안 함
WshShell.Run cmd, 0, False

Set FSO      = Nothing
Set WshShell = Nothing
