#!/bin/bash
# Derived from GNU nano autogen.sh
set -ex

# modules diff: added rewinddir modules for `browser` feature
modules="
	canonicalize-lgpl
	futimens
	getdelim
	getline
	getopt-gnu
	glob
	isblank
	iswblank
	lstat
	mkstemps
	nl_langinfo
	regex
	rewinddir
	sigaction
	snprintf-posix
	stdarg-h
	strcase
	strcasestr-simple
	strnlen
	sys_wait
	vsnprintf-posix
	wchar-h
	wctype-h
	wcwidth
"

# Make sure the local gnulib git repo is up-to-date.
if [ ! -d "gnulib" ]; then
    echo "gnulib not found, exiting..."
	exit 1
fi
cd gnulib >/dev/null || exit 1
curr_hash=$(git log -1 --format=%H)
echo "Current gnulib hash: ${curr_hash}"
cd .. >/dev/null || exit 1

rm -rf lib
echo "Gnulib-tool..."
# shellcheck disable=SC2086
./gnulib/gnulib-tool --import ${modules}
echo

echo "Autoreconf..."
autoreconf --install --symlink --force
echo "Done."
