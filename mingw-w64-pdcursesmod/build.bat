cd wincon

set "PDC_TARGET=_w64"
if "%TARGET_PLATFORM%"=="win-arm64" (
    set "PDC_TARGET=_a64"
)

set "CFLAGS=%CFLAGS% -v"

make -f Makefile WIDE=Y DLL=Y UTF8=Y %PDC_TARGET%=Y
if errorlevel 1 exit 1

@rem install header files
mkdir "%LIBRARY_PREFIX%\include\"
for %%f in (
    curses.h
    panel.h
    term.h
) do copy "%SRC_DIR%\%%f" "%LIBRARY_PREFIX%\include\"

@rem install dll
mkdir "%LIBRARY_PREFIX%\bin\"
copy pdcurses.dll "%LIBRARY_PREFIX%\bin\"

@rem install lib
mkdir "%LIBRARY_PREFIX%\lib\"
copy pdcurses.a "%LIBRARY_PREFIX%\lib\pdcurses.a"
@rem duplicate lib as curses.lib for compatibility
copy pdcurses.a "%LIBRARY_PREFIX%\lib\curses.a"
