#!/bin/bash

if [ "$#" -lt 1 ]
then
    echo "Usage: ./backup.sh <archive name>"
    exit 1
fi

cleanup() {
    rm -f /tmp/temp_backup.txt
    exit 1
}

trap cleanup ERR
trap cleanup SIGINT

ARCHIVE_NAME=$1


# function to ignore empty lines and comments and expand wildcards. I have no idea how this works
function get_filenames() {
    local FILENAME=$1
    # use grep to take out commented lines and empty lines (cursed)
    # do a loop to expand wildcards if there are any, using xargs
    # since xargs outputs many results per line, use awk to print one result per line (there has to be an easier way wtf)
    # grep -Ev '^(#|//|$).*' $FILENAME | while read -r line; do if [[ "$line" == *'*'* ]]; then echo $line | xargs -I{} bash -c "echo {}" | awk '{for(i=1;i<=NF;i++) print $i}'; else echo "$line"; fi; done
    grep -Ev '^(#|//|$).*' "$FILENAME" | while read -r line; do
        if [[ "$line" == *'*'* ]]; then
            echo "$line" | xargs -I{} bash -c "echo {}" | awk '{for(i=1;i<=NF;i++) print $i}'
        else
            echo "$line"
        fi
    done # | sed 's:/*$::' # remove trailing slashes
}


# iterate through all .txt files except example.txt and concat the contents into temp.txt (bash removes newlines in $(...), wtf)
rm -f /tmp/temp_backup.txt
for file in files/*.txt
do
    echo "Found $file"
    if [ "$file" != "files/example.txt" ]
    then
        get_filenames "$file" >> /tmp/temp_backup.txt
    fi
done

SCRIPT_PATH=$(pwd)
cd $HOME

# borg expects all paths to be passed in, it won't recurse into folders when using --paths-from-stdin
# some other option might solve this but I really don't care
# TODO: instead of cat /tmp/temp_backup.txt, need to recurse into ALL paths if the string is a folder

restic --repo repo/ --files-from /tmp/temp_backup.txt --verbose backup

cd $SCRIPT_PATH
rm -f /tmp/temp_backup.txt
