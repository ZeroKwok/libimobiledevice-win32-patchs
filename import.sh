#!/bin/sh

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

if yes_or_no "这可能导致 patchs 中未提交的修改丢失! 是/否?"; then
    find . -type d -path "./*/patchs" -print0 | xargs -0i ./patchs/patch.sh "{}" ./patchs import
fi