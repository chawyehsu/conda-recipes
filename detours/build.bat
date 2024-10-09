@rem Build instructions: https://github.com/microsoft/Detours/wiki/FAQ
cd src

nmake
if %ERRORLEVEL% neq 0 exit 1

@rem install the lib manually
if not exist %LIBRARY_INC% mkdir %LIBRARY_INC%
copy ..\include\detours.h %LIBRARY_INC%
copy ..\include\detver.h %LIBRARY_INC%
@rem assuming the build environment is x64
if not exist %LIBRARY_LIB% mkdir %LIBRARY_LIB%
copy ..\lib.X64\detours.lib %LIBRARY_LIB%

if %ERRORLEVEL% neq 0 exit 1
