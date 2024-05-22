#!/bin/sh

RootDir=$(cd $(dirname $0); pwd)
RepoName=$(basename `pwd`)
RepoCommitId=$(git log -1 --pretty=format:"%h" master)
RepoCommitDate=$(git log -1 --pretty=format:"%cd" --date=format:'%Y-%m-%d %H:%M:%S' master)
RepoCommitMsg=$(git log -1 --pretty=format:"%s" master)

printf "# $RepoName\n  - $RepoCommitId($RepoCommitDate)\n  - $RepoCommitMsg\n" >> $RootDir/patch-status.txt