#!/bin/bash
# Derived from GNU nano autogen.sh
set -ex

project_root="$(dirname "${BASH_SOURCE[0]}")"

pushd "$project_root" || exit 1

gnulib_url="https://github.com/coreutils/gnulib.git"
gnulib_hash="440616a878c0f7419d307909ae7b2ce3147cf3cd"

# add rewinddir modules for `browser` feature
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
	stdarg
	strcase
	strcasestr-simple
	strnlen
	sys_wait
	vsnprintf-posix
	wchar
	wctype-h
	wcwidth
"

# Make sure the local gnulib git repo is up-to-date.
if [ ! -d "gnulib" ]; then
	git clone --depth=2222 ${gnulib_url}
fi
cd gnulib >/dev/null || exit 1
curr_hash=$(git log -1 --format=%H)
if [ "${gnulib_hash}" != "${curr_hash}" ]; then
	echo "Pulling..."
	git pull
	git checkout --force ${gnulib_hash}
fi
cd .. >/dev/null || exit 1

rm -rf lib
echo "Gnulib-tool..."
./gnulib/gnulib-tool --import ${modules}
echo

echo "Autoreconf..."
autoreconf --install --symlink --force
echo "Done."

popd || exit 1
