#!/bin/sh

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

    wget https://raw.githubusercontent.com/arthursn/fetch-dlls/master/fetch-dlls.sh -O "$target"

    [ $? -eq 0 ] && chmod +x "$target"

    [ $? -eq 0 ] && echo "Installation successful!" || echo "Installation failed!"
}

install "$INSTALL_DIR"
