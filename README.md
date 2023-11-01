# fetch-dlls

Utility for find and copying DLLs to the executable path of binaries.

Its main purpose is to fetch DLLs from MinGW (should also work with Cygwin) in order to allow the execution of binaries - built in these environments - in any Windows environment. This solution avoids the need to set up your PATH variable, which can be quite polluting to your shell environment.

Based on the following Andrew Ward's blog post: https://blog.rubenwardy.com/2018/05/07/mingw-copy-dlls/

## Installation

You can download `fetch-dlls.sh`, rename it and make it executable (`chmod +x`), or use the install script (`install.sh`):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/arthursn/fetch-dlls/master/install.sh)"
```

This will install sync-remote in `$HOME/.local/bin`.

For installing in a custom dir, just set the `INSTALL_DIR` variable:

```sh
INSTALL_DIR=/PATH/TO/INSTALL/DIR sh -c "$(curl -fsSL https://raw.githubusercontent.com/arthursn/fetch-dlls/master/install.sh)"
```

## Usage

Run the command in your MinGW environment:

```sh
fetch-dlls [binary_file.exe]

# Also works for compiled libraries
fetch-dlls [library_file.dll]
```

The output will be something like this:

```
Found libgcc_s_seh-1.dll in /mingw64/bin
Unable to find KERNEL32.dll
Unable to find msvcrt.dll
Found libwinpthread-1.dll in /mingw64/bin
Unable to find KERNEL32.dll
Unable to find msvcrt.dll
Found libgomp-1.dll in /mingw64/bin
Found libgcc_s_seh-1.dll in /mingw64/bin
```

By default, the DLLs will only be searched in the `$MINGW_PACKAGE_PREFIX/bin` directory, i.e., `/mingw64/bin`, `/ucrt64/bin`, etc., depending on your MinGW active environment.

If you'd like to add custom search paths, simply set the `SEARCH_PATHS` variable accordingly. For example:

```sh
# Multiple paths should be semicolon (;) separated
SEARCH_PATHS="$HOME/Miniconda3;/ucrt64/bin" fetch-dlls binary_file.exe
```

Some DLLs will not be found, as they are Windows native.
