setlocal EnableDelayedExpansion

@rem no-op for conda-launchers metapackage
if %PKG_NAME% == conda-launchers (exit 0)

@rem rename patched source file to be used for building
move /Y launcher.c.orig launcher.c

if %PKG_NAME% == conda-launchers_win-32 (
    set ZIG_TARGET=x86-windows-gnu
    set EXE_TARGET=32
)

if %PKG_NAME% == conda-launchers_win-64 (
    set ZIG_TARGET=x86_64-windows-gnu
    set EXE_TARGET=64
)

if %PKG_NAME% == conda-launchers_win-arm64 (
    set ZIG_TARGET=aarch64-windows-gnu
    set EXE_TARGET=arm64
)

@rem build cli launcher
zig build -Doptimize=ReleaseSmall -Dtarget=%ZIG_TARGET% -Dgui=false --prefix-exe-dir "%PREFIX%\Scripts"
if %ERRORLEVEL% neq 0 exit 1

@rem build gui launcher
zig build -Doptimize=ReleaseSmall -Dtarget=%ZIG_TARGET% -Dgui=true --prefix-exe-dir "%PREFIX%\Scripts"
if %ERRORLEVEL% neq 0 exit 1

@rem install launcher scripts
cd "%PREFIX%\Scripts"
(
echo print^("cli-%EXE_TARGET%.exe successfully launched the accompanying Python script"^)
)> "cli-%EXE_TARGET%-script.py"

if %ERRORLEVEL% neq 0 exit 1

(
echo import tkinter as tk
echo root = tk.Tk^(^)
echo text = tk.Label^(root, text ="Hello and Bye!"^)
echo text.pack^(^)
echo root.geometry^("150x100"^)
echo root.after^(1000, lambda: root.destroy^(^)^)
echo root.mainloop^(^)
)> "gui-%EXE_TARGET%-script.pyw"

if %ERRORLEVEL% neq 0 exit 1
