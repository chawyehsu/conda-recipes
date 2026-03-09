# GNU nano for Windows

[![Conda Downloads](https://img.shields.io/conda/dn/chawyehsu/nano.svg)](https://anaconda.org/chawyehsu/nano) [![Conda Version](https://img.shields.io/conda/vn/chawyehsu/nano.svg)](https://anaconda.org/chawyehsu/nano)

This is the Windows port of the GNU nano text editor, based on the conda-forge build system.

## Project Overview

This project provides a complete build environment for the GNU nano editor, specifically optimized and patched for Windows platform compatibility. It includes multiple patches to ensure nano runs correctly on Windows.

## Version Information

- **nano version**: 8.7.1
- **Build system**: conda-forge/rattler-build
- **Target platforms**: Windows x86_64 and Unix

## Main Features

- Windows platform compatibility
- UTF-8 encoding support
- Mouse support
- Syntax highlighting
- RC file lookup compatibility
- Position history compatibility
- Spell check and formatter support

## Windows Compatibility Patches

- 0001-win32-include-windows-header.patch
- 0002-win32-drop-bracketed-paste-mode-escape-sequences.patch
- 0003-win32-system-wide-rcfile-compat.patch
- 0004-win32-fix-file-parentdir-access.patch
- 0005-win32-replace-slashes-and-invalid-filename-chars.patch
- 0006-win32-homedir-tempdir-compat.patch
- 0007-win32-file-io-to-binary-mode.patch
- 0008-win32-utf8-support-and-detect-wide-char-width.patch
- 0009-win32-windows-conhost-read-stdin-data.patch
- 0010-win32-remove-halfdelay-for-unicode.patch
- 0011-win32-keycode-pdcursesmod-compat.patch
- 0012-win32-colortype-pdcursesmod-compat.patch
- 0013-win32-window-resize-handling-and-screen-redraw.patch
- 0014-win32-formatter-and-spell-check-support.patch
- 0015-win32-poshistory-item-windows-path-compat.patch # v8.5+
- 0016-win32-pdcursesmod-ctrlv-passthrough.patch

## Build Requirements

- GCC/MinGW-w64 toolchain
- PDCursesmod library
- MSYS2 tools on Windows
- ncurses library on cross-compilation
- autoconf/automake on cross-compilation
- gettext-tools on cross-compilation

## Build Methods

### Building

```bash
pixi run build build --recipe-dir nano --target-platform win-64
```

## Installation and Usage

### Install with conda/pixi

```bash
conda install -c chawyehsu -c conda-forge nano
# or
pixi global install nano -c chawyehsu -c conda-forge
```

### Manual Installation

1. Download the built binary files
2. Place `nano.exe` in a PATH directory

## License

This project and patches follow the GPL-3.0-or-later license. The recipe and build scripts are licensed under the BSD-3-Clause license.

## Related Links

- [GNU nano Official Website](https://www.nano-editor.org)
- [Source Repository](https://cgit.git.savannah.gnu.org/cgit/nano.git/)
- [Conda Package Page](https://anaconda.org/chawyehsu/nano)

### Prior work

- [nano-win](https://github.com/lhmouse/nano-win)
- [nano-for-windows](https://github.com/okibcn/nano-for-windows)

## Maintainers

- chawyehsu

## Version History

- **v8.7.1**: Current version
- **v8.5+**: Added position history compatibility patches
