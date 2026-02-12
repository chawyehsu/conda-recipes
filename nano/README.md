# GNU nano for Windows

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

## Windows Compatibility Patches

This project includes the following Windows platform compatibility patches:

### Core Compatibility

- **0000-include-windows-header.patch**: Include Windows headers
- **0001-drop-bracketed-paste-mode-escape-sequences.patch**: Remove bracketed paste mode escape sequences
- **0002-system-wide-rcfile-compat.patch**: System-wide configuration file compatibility
- **0003-fix-file-parentdir-access.patch**: Fix file parent directory access

### File System Compatibility

- **0004-replace-slashes-and-invalid-filename-chars.patch**: Replace slashes and invalid filename characters
- **0012-poshistory-item-windows-path-compat.patch**: Position history item Windows path compatibility

### System Integration

- **0005-homedir-tempdir-compat.patch**: Home directory and temporary directory compatibility
- **0006-file-io-to-binary-mode.patch**: File I/O to binary mode
- **0008-windows-conhost-read-stdin-data.patch**: Windows console host read stdin data

### Unicode and Display

- **0007-utf8-support-and-wide-char-width-detection-fix.patch**: UTF-8 support and wide character width detection fix
- **0009-remove-halfdelay-for-unicode.patch**: Remove halfdelay for Unicode

### Terminal Compatibility

- **0010-meta-keycode-pdcurses-compat.patch**: Meta keycode PDCurses compatibility
- **0011-colortype-pdcursesmod-compat.patch**: Color type PDCursesmod compatibility

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
