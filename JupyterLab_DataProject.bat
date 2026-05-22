@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

REM ============================================================
REM  JupyterLab Launcher  (D:\data_project)
REM  - jupyter.exe 경로 자동 탐색
REM  - 작업 폴더 자동 생성
REM  - 콘솔에 실행 로그가 그대로 표시되어 오류 확인 가능
REM ============================================================

set "NOTEBOOK_DIR=D:\data_project"
set "JUPYTER_EXE="

REM --- 1) 일반적인 설치 경로 확인 ----------------------------
for %%P in (
    "C:\Python314\Scripts\jupyter.exe"
    "%LOCALAPPDATA%\Programs\Python\Python314\Scripts\jupyter.exe"
    "%LOCALAPPDATA%\Programs\Python\Python313\Scripts\jupyter.exe"
    "%LOCALAPPDATA%\Programs\Python\Python312\Scripts\jupyter.exe"
) do (
    if exist %%P (
        set "JUPYTER_EXE=%%~P"
        goto :found
    )
)

REM --- 2) PATH 에서 검색 -------------------------------------
for /f "delims=" %%I in ('where jupyter 2^>nul') do (
    if not defined JUPYTER_EXE set "JUPYTER_EXE=%%I"
)

:found
if not defined JUPYTER_EXE (
    echo.
    echo [ERROR] jupyter.exe 를 찾을 수 없습니다.
    echo         다음 명령으로 JupyterLab 을 먼저 설치하세요:
    echo             pip install jupyterlab
    echo.
    pause
    exit /b 1
)

echo [INFO] Jupyter:        "!JUPYTER_EXE!"
echo [INFO] Notebook dir:   "%NOTEBOOK_DIR%"

REM --- 3) 작업 폴더 확인/생성 --------------------------------
if not exist "%NOTEBOOK_DIR%" (
    echo [INFO] 폴더가 없어 새로 만듭니다: %NOTEBOOK_DIR%
    mkdir "%NOTEBOOK_DIR%" 2>nul
    if errorlevel 1 (
        echo [ERROR] 폴더 생성 실패: %NOTEBOOK_DIR%
        pause
        exit /b 2
    )
)

REM --- 4) JupyterLab 실행 ------------------------------------
echo.
echo [INFO] JupyterLab 을 시작합니다. 종료하려면 이 창에서 Ctrl+C 두 번.
echo --------------------------------------------------------------
"!JUPYTER_EXE!" lab --notebook-dir="%NOTEBOOK_DIR%"
echo --------------------------------------------------------------

echo.
echo [INFO] JupyterLab 이 종료되었습니다. 아무 키나 누르면 창이 닫힙니다.
pause >nul
endlocal
