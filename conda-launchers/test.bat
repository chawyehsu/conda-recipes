setlocal EnableDelayedExpansion

set EXE_TARGET=64
if %TARGET_PLATFORM% == win-32 (
    set EXE_TARGET=32
)
if %TARGET_PLATFORM% == win-arm64 (
    set EXE_TARGET=arm64
)

if not exist "%SCRIPTS%\cli-%EXE_TARGET%.exe" exit 1
if not exist "%SCRIPTS%\cli-%EXE_TARGET%-script.py" exit 1
CALL "%SCRIPTS%\cli-%EXE_TARGET%.exe"
if not exist "%SCRIPTS%\gui-%EXE_TARGET%.exe" exit 1
if not exist "%SCRIPTS%\gui-%EXE_TARGET%-script.py" exit 1
