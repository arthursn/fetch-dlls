#!/bin/bash

# Script for copying MinGW DLLs based on the following blog post:
# https://blog.rubenwardy.com/2018/05/07/mingw-copy-dlls/

[ $# -ne 1 ] && echo "Usage: fetch-dlls [path/to/binary/file]" && exit 1

[ -z ${SEARCH_PATHS+x} ] && SEARCH_PATHS="$MINGW_PREFIX/bin"

function find_and_copy_dlls() {
    IFS=';'
    for d in $SEARCH_PATHS; do
        file="$d/$1"
        if [ -f $file ]; then
            cp $file $dest_dir
            echo "Found $1 in $d"
            copy_dlls_for_obj $file
            return 0
        fi
    done

    return 1
}

function copy_dlls_for_obj() {
    dlls=$(objdump -p $1 | grep 'DLL Name:' | sed -e "s/\t*DLL Name: //g")
    while read -r filename; do
        find_and_copy_dlls $filename || echo "Unable to find $filename"
    done <<<"$dlls"
}

dest_dir=$(dirname $1)
copy_dlls_for_obj $1
