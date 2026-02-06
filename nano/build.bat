:: Delegate to the unix build script

:: Convert Windows-style paths to Unix-style paths
FOR /F "delims=" %%i IN ('cygpath.exe -u "%PREFIX%"') DO set "PREFIX=%%i"

bash "%RECIPE_DIR%\build.sh"
if errorlevel 1 exit 1
