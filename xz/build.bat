setlocal EnableDelayedExpansion

cmake %CMAKE_ARGS% ^
    -G Ninja ^
    -B build ^
    -D BUILD_SHARED_LIBS=YES ^
    -D CMAKE_BUILD_TYPE=Release ^
    -D CMAKE_MT=mt ^
    -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -S %SRC_DIR%

IF %ERRORLEVEL% NEQ 0 exit 1

cmake --build build -j %CPU_COUNT% --target install

IF %ERRORLEVEL% NEQ 0 exit 1
