#!/bin/bash
set -ex

pkg_name_static="mingw-w64-pdcursesmod-static"

PDC_TARGET=_w64
# shellcheck disable=SC2154
if [[ "${target_platform}" == "win-arm64" ]]; then
  PDC_TARGET=_a64
elif [[ "${target_platform}" == "win-32" ]]; then
  PDC_TARGET=_w32
fi

# install header files
mkdir -p "$LIBRARY_PREFIX/include/pdcurses"
install -m 0644 curses.h panel.h term.h "$LIBRARY_PREFIX/include/pdcurses/"
# needs defines matching the make step, see https://github.com/Bill-Gray/PDCursesMod/issues/133
cat > pdcurses.h <<'EOF'
#define PDC_FORCE_UTF8 1
#include "pdcurses/curses.h"
EOF
install -m 0644 pdcurses.h "$LIBRARY_PREFIX/include/pdcurses.h"
# install `curses.h` as well for compatibility
install -m 0644 pdcurses.h "$LIBRARY_PREFIX/include/curses.h"

cd wincon
if [[ "${PKG_NAME}" == "$pkg_name_static" ]]; then
  make -f Makefile WIDE=Y UTF8=Y ${PDC_TARGET}=Y LIBNAME=pdcurses
else
  make -f Makefile WIDE=Y UTF8=Y DLL=Y ${PDC_TARGET}=Y LIBNAME=pdcurses
fi

if [[ ! "${PKG_NAME}" == "$pkg_name_static" ]]; then
  # install dll
  mkdir -p "$LIBRARY_PREFIX/bin"
  install pdcurses.dll "$LIBRARY_PREFIX/bin/libpdcurses.dll"
fi

# install lib
mkdir -p "$LIBRARY_PREFIX/lib"
install pdcurses.a "$LIBRARY_PREFIX/lib/libpdcurses.a"
cd ..
