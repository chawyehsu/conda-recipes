#!/bin/bash
set -ex

cd wincon

PDC_TARGET=_w64
# shellcheck disable=SC2154
if [[ "${target_platform}" == "win-arm64" ]]; then
    PDC_TARGET=_a64
fi

make -f Makefile WIDE=Y DLL=Y UTF8=Y ${PDC_TARGET}=Y

# install header files
mkdir -p "$LIBRARY_PREFIX/include"
for f in curses.h panel.h term.h; do
    cp "$SRC_DIR/$f" "$LIBRARY_PREFIX/include/"
done

# install dll
mkdir -p "$LIBRARY_PREFIX/bin"
cp pdcurses.dll "$LIBRARY_PREFIX/bin/"

# install lib
mkdir -p "$LIBRARY_PREFIX/lib"
cp pdcurses.a "$LIBRARY_PREFIX/lib/pdcurses.a"
# duplicate lib as curses.a for compatibility
cp "$LIBRARY_PREFIX/lib/pdcurses.a" "$LIBRARY_PREFIX/lib/curses.a"
