@echo off
setlocal enabledelayedexpansion

echo =======================================================
echo          Building 7nd.motion Release Assets
echo =======================================================
echo.

set CMAKE_EXE="D:\Program Files\VisualStudio2026\Product\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
if not exist %CMAKE_EXE% (
    set CMAKE_EXE="D:\Windows\Visual studio 2022\Product\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
)
if not exist %CMAKE_EXE% (
    set CMAKE_EXE="D:\Windows\vs 2022\product\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
)
if not exist %CMAKE_EXE% (
    set CMAKE_EXE=cmake
)

echo [1/3] Configuring and building Release targets...
%CMAKE_EXE% -B build -S . -DCMAKE_BUILD_TYPE=Release
if %errorlevel% neq 0 (
    echo [ERROR] CMake configure failed.
    exit /b 1
)

%CMAKE_EXE% --build build --config Release
if %errorlevel% neq 0 (
    echo [ERROR] Build failed.
    exit /b 1
)

echo.
echo [2/3] Packaging release distribution to dist/...
if not exist dist mkdir dist

copy /y "build\Release\7nd.motion.exe" "dist\7nd.motion_portable.exe" >nul
copy /y "build\Release\7nd.motion-Installer.exe" "dist\7nd.motion-Installer.exe" >nul
copy /y "version.json" "dist\version.json" >nul

echo.
echo =======================================================
echo          Release Build Completed Successfully!
echo =======================================================
echo.
echo Assets ready in dist/ folder:
echo   - dist\7nd.motion_portable.exe
echo   - dist\7nd.motion-Installer.exe
echo   - dist\version.json
echo.
echo You can upload these directly to GitHub Releases.
echo Note: 7nd.motion-Installer.exe reads version.json dynamically,
echo       so you rarely even need to re-upload the installer!
echo.
pause
