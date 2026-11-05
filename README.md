I use borg to store my backups since the deduplication and encryption is very helpful

The files I want to backup are specifed in files/, as simple text files, that can also contain comments as # or //, and empty lines

I left an example in there

**WARNING:** backup.sh will cd into the home directory. This is personal preference, and means the paths in files/* will be relative to ~

# Scripts:

`init.sh` - init borg repository

`backup.sh <name>` - make an archive with a specific name

`restore.sh [snapshot] [target]` - restore a snapshot (defaults to `latest`) into the target directory (defaults to `$HOME`). Relative targets are resolved from the directory where you run the script. For example: `sudo ./restore.sh latest /mnt/restore`. With sudo, `$HOME` may be `/root`, so pass a target explicitly to restore elsewhere.

`size.sh <name>` - browse the files in a snapshot by size with gdu (defaults to the latest snapshot)
