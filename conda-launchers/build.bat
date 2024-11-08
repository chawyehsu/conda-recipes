setlocal EnableDelayedExpansion

@rem rename patched source file to be used for building
move /Y launcher.c.orig launcher.c

set ZIG_TARGET=x86_64-windows-gnu
set EXE_TARGET=64
if %TARGET_PLATFORM% == win-32 (
    set ZIG_TARGET=x86-windows-gnu
    set EXE_TARGET=32
)
if %TARGET_PLATFORM% == win-arm64 (
    set ZIG_TARGET=aarch64-windows-gnu
    set EXE_TARGET=arm64
)

@rem build cli launcher
zig build -Doptimize=ReleaseSmall -Dtarget=%ZIG_TARGET% -Dgui=false --prefix-exe-dir %SCRIPTS%
@rem build gui launcher
zig build -Doptimize=ReleaseSmall -Dtarget=%ZIG_TARGET% -Dgui=true --prefix-exe-dir %SCRIPTS%

if %ERRORLEVEL% neq 0 exit 1

@rem install launcher scripts
cd %SCRIPTS%
for %%f in (cli gui) do (
    echo print^("%%f-%EXE_TARGET%.exe successfully launched the accompanying Python script"^)> "%%f-%EXE_TARGET%-script.py"
)

if %ERRORLEVEL% neq 0 exit 1
