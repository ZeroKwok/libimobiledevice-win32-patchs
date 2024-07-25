#!/bin/sh
# batch.sh ./idevicerestore/patchs ./patchs patch
# batch.sh ./patchs/idevicerestore ./patchs apply
# find . -type d -path "./*/patchs" -print0 | xargs -0i ./batch.sh "{}" ./patchs patch

if test $# -lt 2 ; then
    exit 1
fi

if test $# -gt 2 && test $3 = 'patch'; then
    ModuleName=`dirname $1` 
    ModuleName=`basename "$ModuleName"`
    ModulePatchDir=$1
    PatchDir=$2
    PatchDir=$PatchDir/$ModuleName

    #echo ModulePatchDir=$ModulePatchDir
    #echo ModuleName=$ModuleName
    #echo PatchDir=$PatchDir

    echo rsync -av --delete $ModulePatchDir/ $PatchDir
    $ModulePatchDir/patch-cli.sh patch && rsync -av --delete $ModulePatchDir/ $PatchDir
else # apply
    ModuleName=`basename $1` 
    ModulePatchDir=$ModuleName/patchs
    PatchDir=$2
    PatchDir=$PatchDir/$ModuleName

    #echo ModulePatchDir=$ModulePatchDir
    #echo ModuleName=$ModuleName
    #echo PatchDir=$PatchDir
    
    if ! test -r "$PatchDir/patch-cli.sh":; then
        cp -v $2/patch-cli.in  $PatchDir/patch-cli.sh
    fi

    echo ''
    echo rsync -av $PatchDir/ $ModulePatchDir
    rsync -av $PatchDir/ $ModulePatchDir && $ModulePatchDir/patch-cli.sh apply
fi
