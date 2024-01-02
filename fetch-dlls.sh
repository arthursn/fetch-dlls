#!/bin/bash

# Script for copying MinGW DLLs based on the following blog post:
# https://blog.rubenwardy.com/2018/05/07/mingw-copy-dlls/

[ $# -lt 1 ] && echo "Usage: fetch-dlls [path/to/binary/files]" && exit 1

[ -z ${SEARCH_PATHS+x} ] && SEARCH_PATHS="$MINGW_PREFIX/bin"

function find_and_copy_dlls() {
    IFS=';'
    for d in $SEARCH_PATHS; do
        local file="$d/$1"

        [[ ${checked[@]} =~ "$file" ]] && continue
        checked+=("$file")

        if [ -f $file ]; then
            cp $file $dest_dir
            if [[ ${found[@]} =~ "$1" ]]; then
                echo "$1 also found in $d (overwriting previous copy)"
            else
                echo "$1 found in $d"
                found+=($1)
            fi
            copy_dlls_for_obj $file

            return
        fi
    done

    [[ ${found[@]} =~ "$1" ]] || not_found+=("$1")
}

function copy_dlls_for_obj() {
    dlls=$(objdump -p $1 | grep 'DLL Name:' | sed -e "s/\t*DLL Name: //g")
    while read -r filename; do
        find_and_copy_dlls $filename
    done <<<"$dlls"
}

for file in $@; do
    echo ""
    echo "Fetching DLLs for '$file'"

    dest_dir=$(dirname $file)
    checked=()
    found=()
    not_found=()

    copy_dlls_for_obj $file

    IFS=$'\n'
    not_found=($(for v in ${not_found[@]}; do echo "$v"; done | sort -u))

    if [ ${#not_found[@]} -gt 0 ]; then
        echo "${#not_found[@]} DLLs could not be found:"
        for v in ${not_found[@]}; do
            echo "  $v"
        done
    fi

    echo "${#found[@]} DLLs found for '$file'"
done
