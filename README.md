<!-- **WARNING:** Some scripts use zsh, not bash, so I have a sane syntax to `ls` all the files excluding example.txt -->

I use borg to store my backups since the deduplication and encription is very helpful

The files I want to backup are specifed in files/, as simple text files, that can also contain comments as # or //, and empty lines

I left an example in there


# Scripts:

`init.sh` - init borg repository

`backup.sh <name>` - make an archive with a specific name
