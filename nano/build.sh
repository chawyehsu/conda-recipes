#!/bin/bash
set -ex

# shellcheck disable=SC2154
if [[ "${target_platform}" =~ win-* ]]; then
    # `PDC_FORCE_UTF8` is required to force PDC to be utf8 mode
    export CFLAGS="$CFLAGS -DPDC_FORCE_UTF8"
    export LDFLAGS="$LDFLAGS -L$LIBRARY_PREFIX/lib -static"
    export NCURSESW_CFLAGS="-I$LIBRARY_PREFIX/include -DNCURSES_STATIC"
    export NCURSESW_LIBS="-l:pdcurses.a -lwinmm"

    export HOST=x86_64-w64-mingw32
    if [[ "${build_platform}" == 'win-64' ]]; then
        export BUILD=x86_64-w64-mingw32
    fi

    # there's a compiling failure relevant to the `browser`
    # feature I couldn't workaround with, so disable it.
    ./configure \
        --prefix="${PREFIX}" \
        --build="${BUILD}" \
        --host="${HOST}" \
        --disable-dependency-tracking \
        --enable-utf8 \
        --disable-{nls,speller,browser} \
        --sysconfdir="C:\\ProgramData"
else
    ./configure \
        --prefix="${PREFIX}" \
        --disable-dependency-tracking \
        --build="${BUILD}" \
        --host="${HOST}"
fi

make -j "${CPU_COUNT}"
make check
make install

# shellcheck disable=SC2154
if [[ "${target_platform}" =~ win-* ]]; then
    # remove the rnano symlink
    rm "${PREFIX}/bin/rnano"
fi
