@rem Build instructions: https://github.com/microsoft/Detours/wiki/FAQ
cd src

set TARGET=X64
if %TARGET_PLATFORM% == win-32 (
    set DETOURS_TARGET_PROCESSOR=X86
    set TARGET=X86
)
if %TARGET_PLATFORM% == win-arm64 (
    set DETOURS_TARGET_PROCESSOR=ARM64
    set TARGET=ARM64
)

@rem build the library
nmake
if %ERRORLEVEL% neq 0 exit 1

@rem install the library
if not exist %LIBRARY_INC% mkdir %LIBRARY_INC%
copy ..\include\detours.h %LIBRARY_INC%
copy ..\include\detver.h %LIBRARY_INC%
if not exist %LIBRARY_LIB% mkdir %LIBRARY_LIB%
copy ..\lib.%TARGET%\detours.lib %LIBRARY_LIB%

if %ERRORLEVEL% neq 0 exit 1
