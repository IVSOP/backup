#!/bin/bash

if [ "$#" -lt 1 ]
then
    echo "Usage: ./backup.sh <archive name>"
    exit 1
fi

ARCHIVE_NAME=$1

CUR_PATH=$(pwd)
cd $HOME

borg extract borg::$ARCHIVE_NAME

cd $CUR_PATH
