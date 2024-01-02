#!/bin/bash

[ -z ${INSTALL_DIR+x} ] && INSTALL_DIR="$HOME/.local/bin"

install() {
    install_dir="$1"
    echo "Installing fetch-dlls in '$install_dir'"

    if [ ! -d "$install_dir" ]; then
        echo "Creating installation directory '$install_dir'"
        mkdir -p "$install_dir"
    fi

    target="$install_dir/fetch-dlls"
    if [ -f "$target" ]; then
        while true; do
            read -p "fetch-dlls found in '$install_dir'. Do you wish to override the current installation? (y/n) " yn
            case $yn in
            [Yy]*)
                break
                ;;
            [Nn]*) exit ;;
            *) echo "Please answer yes or no." ;;
            esac
        done
    fi

    if command -v curl >/dev/null 2>&1; then
        curl https://raw.githubusercontent.com/arthursn/fetch-dlls/master/fetch-dlls.sh >"$target"
    elif command -v wget >/dev/null 2>&1; then
        wget https://raw.githubusercontent.com/arthursn/fetch-dlls/master/fetch-dlls.sh -O "$target"
    else
        echo "ERROR: curl or wget are necessary for running this script"
        exit 1
    fi

    [ $? -eq 0 ] && chmod +x "$target"

    [ $? -eq 0 ] && echo "Installation successful!" || echo "ERROR: Installation failed!"
}

install "$INSTALL_DIR"
