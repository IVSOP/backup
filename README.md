I use borg to store my backups since the deduplication and encryption is very helpful

The files I want to backup are specifed in files/, as simple text files, that can also contain comments as # or //, and empty lines

I left an example in there

**WARNING:** scripts will cd into the home directory. This is personal preference, and means the paths in files/* will be relative to ~

# Scripts:

`init.sh` - init borg repository

`backup.sh <name>` - make an archive with a specific name

`restore.sh <name>` - restore the backup (extract files)
