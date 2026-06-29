#!/bin/bash
set -ex

pkg_name_static="mingw-w64-pdcursesmod-static"

cd wincon

PDC_TARGET=_w64
# shellcheck disable=SC2154
if [[ "${target_platform}" == "win-arm64" ]]; then
    PDC_TARGET=_a64
elif [[ "${target_platform}" == "win-32" ]]; then
    PDC_TARGET=_w32
fi

if [[ "${PKG_NAME}" == "$pkg_name_static" ]]; then
    make -f Makefile WIDE=Y UTF8=Y ${PDC_TARGET}=Y
else
    make -f Makefile WIDE=Y UTF8=Y DLL=Y ${PDC_TARGET}=Y
fi

# install header files
install -m 0644 curses.h panel.h term.h "$LIBRARY_PREFIX/include/pdcurses/"
# needs defines matching the make step, see https://github.com/Bill-Gray/PDCursesMod/issues/133
echo '#define PDC_WIDE 1'           >> pdcurses.h
echo '#define PDC_FORCE_UTF8 1'     >> pdcurses.h
echo '#include "pdcurses/curses.h"' >> pdcurses.h
install -m 0644 pdcurses.h "$LIBRARY_PREFIX/include/pdcurses.h"

if [[ ! "${PKG_NAME}" == "$pkg_name_static" ]]; then
    # install dll
    mkdir -p "$LIBRARY_PREFIX/bin"
    cp pdcurses.dll "$LIBRARY_PREFIX/bin/"
fi

# install lib
mkdir -p "$LIBRARY_PREFIX/lib"
cp pdcurses.a "$LIBRARY_PREFIX/lib/pdcurses.a"
# duplicate lib as curses.a for compatibility
cp "$LIBRARY_PREFIX/lib/pdcurses.a" "$LIBRARY_PREFIX/lib/curses.a"
