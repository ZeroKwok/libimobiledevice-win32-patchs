#!/bin/sh
# patch.sh ./idevicerestore/patchs ./patchs import
# patch.sh ./patchs/idevicerestore ./patchs export
# find . -type d -path "./*/patchs" -print0 | xargs -0i ./patch.sh "{}" ./patchs import

if test $# -lt 2 ; then
    exit 1
fi

if test $# -gt 2 && test $3 = 'import'; then
    ModuleName=`dirname $1` 
    ModuleName=`basename "$ModuleName"`
    ModulePatchDIr=$1
    PatchDir=$2
    PatchDir=$PatchDir/$ModuleName

    #echo ModulePatchDIr=$ModulePatchDIr
    #echo ModuleName=$ModuleName
    #echo PatchDir=$PatchDir

    echo rsync -av --delete $ModulePatchDIr/ $PatchDir
    $ModulePatchDIr/patch-cli.sh patch && rsync -av --delete $ModulePatchDIr/ $PatchDir
else
    ModuleName=`basename $1` 
    ModulePatchDIr=$ModuleName/patchs
    PatchDir=$2
    PatchDir=$PatchDir/$ModuleName

    #echo ModulePatchDIr=$ModulePatchDIr
    #echo ModuleName=$ModuleName
    #echo PatchDir=$PatchDir
    
    cp -v $2/patch-cli.in  $PatchDir/patch-cli.sh

    echo rsync -av $PatchDir/ $ModulePatchDIr
    rsync -av $PatchDir/ $ModulePatchDIr && $ModulePatchDIr/patch-cli.sh apply
fi
