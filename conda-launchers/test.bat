@echo off
setlocal EnableDelayedExpansion

set TARGET=x86_64-windows-gnu
set EXE_TARGET=64
if %TARGET_PLATFORM% == win-32 (
    set TARGET=x86-windows-gnu
    set EXE_TARGET=32
)
if %TARGET_PLATFORM% == win-arm64 (
    set TARGET=aarch64-windows-gnu
    set EXE_TARGET=arm64
)

if not exist "%SCRIPTS%\cli-%EXE_TARGET%.exe" exit 1
if not exist "%SCRIPTS%\cli-%EXE_TARGET%-script.py" exit 1
CALL "%SCRIPTS%\cli-%EXE_TARGET%.exe"
python "%SCRIPTS%\cli-%EXE_TARGET%-script.py"
if not exist "%SCRIPTS%\gui-%EXE_TARGET%.exe" exit 1
if not exist "%SCRIPTS%\gui-%EXE_TARGET%-script.py" exit 1
