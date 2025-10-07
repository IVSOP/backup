#!/bin/bash

CUR_PATH=$(pwd)
cd $HOME

restic --repo $CUR_PATH/repo restore latest
#--target .

cd $CUR_PATH

