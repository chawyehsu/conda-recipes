setlocal EnableDelayedExpansion

copy launcher.c.orig launcher.c /Y

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

@rem build cli launcher
zig build -Doptimize=ReleaseSmall -Dtarget=%TARGET% -Dgui=false --prefix-exe-dir %SCRIPTS%
@rem build gui launcher
zig build -Doptimize=ReleaseSmall -Dtarget=%TARGET% -Dgui=true --prefix-exe-dir %SCRIPTS%

IF %ERRORLEVEL% NEQ 0 exit 1

@REM @rem install launcher scripts
cd %SCRIPTS%
for %%f in (cli gui) do (
    echo print^("%%f-%EXE_TARGET%.exe successfully launched the accompanying Python script"^)> "%%f-%EXE_TARGET%-script.py"
)

IF %ERRORLEVEL% NEQ 0 exit 1
