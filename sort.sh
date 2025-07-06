#!/bin/bash

# this is a utility script that is not called automatically, to sort all the text files

for file in files/*.txt
do
    if [ "$file" != "example.txt" ]
    then
        echo "Sorting $file"
        sort "$file" > temp.txt && mv temp.txt "$file"
    fi
done
