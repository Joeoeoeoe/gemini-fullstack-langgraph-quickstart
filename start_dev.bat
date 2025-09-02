:: 文件名: start_dev.bat

@echo off
SETLOCAL

:: 获取当前脚本所在的目录，也就是项目根目录
SET "PROJECT_ROOT=%~dp0"
SET "BACKEND_DIR=%PROJECT_ROOT%backend"
SET "VENV_ACTIVATE_SCRIPT=%BACKEND_DIR%\.venv\Scripts\activate.bat"

:: 检查虚拟环境是否存在
IF NOT EXIST "%VENV_ACTIVATE_SCRIPT%" (
    ECHO ERROR: Backend virtual environment not found at "%BACKEND_DIR%\.venv".
    ECHO Please create it and install dependencies first:
    ECHO   cd "%BACKEND_DIR%"
    ECHO   python -m venv .venv
    ECHO   .\.venv\Scripts\activate.bat
    ECHO   pip install .
    EXIT /B 1
)

echo Starting backend development server...
:: 启动后端服务
:: 在新的cmd窗口中，先切换到backend目录，然后激活虚拟环境，最后运行langgraph dev
start "Backend Server" cmd /k "cd /d "%BACKEND_DIR%" && call "%VENV_ACTIVATE_SCRIPT%" && set HTTP_PROXY=http://127.0.0.1:49744&& set HTTPS_PROXY=http://127.0.0.1:49744&& set ALL_PROXY=http://127.0.0.1:49744&& set NO_PROXY=localhost,127.0.0.1&& langgraph dev"

echo Starting frontend development server...
:: 启动前端服务
start "Frontend Server" cmd /k "cd /d "%PROJECT_ROOT%frontend" && npm run dev"
timeout /t 2 /nobreak >nul REM 等待5秒，确保服务器启动
start "" "http://localhost:5173/app/"

echo.
echo Backend server should be running in a new window with its virtual environment activated.
echo Frontend server should be running in another new window.
echo Open your browser to http://localhost:5173/app/ once both are ready.
echo.

ENDLOCAL
EXIT /B 0
