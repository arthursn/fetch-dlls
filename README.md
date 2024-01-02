# fetch-dlls

Utility for find and copying DLLs to the executable path of binaries.

Its main purpose is to fetch DLLs from MinGW (should also work with Cygwin) in order to allow the execution of binaries - built in these environments - in any Windows environment. This solution avoids the need to set up your PATH variable, which can be quite polluting to your shell environment.

Based on the following Andrew Ward's blog post: https://blog.rubenwardy.com/2018/05/07/mingw-copy-dlls/

## Installation

You can download `fetch-dlls.sh`, rename it and make it executable (`chmod +x`), or use the install script (`install.sh`):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/arthursn/fetch-dlls/master/install.sh)"
```

This will install sync-remote in `$HOME/.local/bin`.

For installing in a custom dir, just set the `INSTALL_DIR` variable:

```bash
INSTALL_DIR=/PATH/TO/INSTALL/DIR bash -c "$(curl -fsSL https://raw.githubusercontent.com/arthursn/fetch-dlls/master/install.sh)"
```

## Usage

Run the command in your MinGW environment:

```bash
fetch-dlls [binary_file.exe]

# DLLs and multiple files as input are also accepted
fetch-dlls [binary_files.exe library_files.dll ...]
```

The output will be something like this:

```
Fetching DLLs for 'binary_file.exe'
libgcc_s_seh-1.dll found in /ucrt64/bin
libwinpthread-1.dll found in /ucrt64/bin
libstdc++-6.dll found in /ucrt64/bin
13 DLLs could not be found:
  api-ms-win-crt-convert-l1-1-0.dll
  api-ms-win-crt-environment-l1-1-0.dll
  api-ms-win-crt-filesystem-l1-1-0.dll
  api-ms-win-crt-heap-l1-1-0.dll
  api-ms-win-crt-locale-l1-1-0.dll
  api-ms-win-crt-math-l1-1-0.dll
  api-ms-win-crt-private-l1-1-0.dll
  api-ms-win-crt-runtime-l1-1-0.dll
  api-ms-win-crt-stdio-l1-1-0.dll
  api-ms-win-crt-string-l1-1-0.dll
  api-ms-win-crt-time-l1-1-0.dll
  api-ms-win-crt-utility-l1-1-0.dll
  KERNEL32.dll
3 DLLs found for 'binary_file.exe'
```

By default, the DLLs will only be searched in the `$MINGW_PACKAGE_PREFIX/bin` directory (i.e., `/mingw64/bin`, `/ucrt64/bin`, etc., depending on your MinGW active environment).

If you'd like to add custom search paths, simply set the `SEARCH_PATHS` variable accordingly. For example:

```bash
# Multiple paths should be semicolon (;) separated
SEARCH_PATHS="$HOME/Miniconda3;/ucrt64/bin" fetch-dlls binary_file.exe
```

Some DLLs will not be found, as they are Windows native. This should not be a problem for the execution of your program.
