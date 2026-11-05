#!/bin/bash

CUR_PATH=$(pwd)
SNAPSHOT=${1:-latest}
TARGET=${2:-"$HOME"}

exec restic --repo "$CUR_PATH/repo" restore "$SNAPSHOT" --target "$TARGET"

