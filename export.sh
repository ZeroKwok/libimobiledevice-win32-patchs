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

if yes_or_no "如果你已经修改了构建树中的内容, 这操作将可能导致修改的内容丢失! 是/否?"; then
    find ./patchs -type d ! -name patchs -prune -print0 | xargs -0i ./patchs/patch.sh "{}" ./patchs export
fi