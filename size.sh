#!/bin/bash

# browse the files inside a snapshot by size, the same way gdu shows a normal directory
# usage: ./size.sh [snapshot]   (defaults to latest)

set -o pipefail

SNAPSHOT=${1:-latest}
CUR_PATH=$(pwd)
JSON=$(mktemp /tmp/restic_gdu_XXXXXX.json)

cleanup() {
    rm -f "$JSON"
    exit 1
}

trap cleanup ERR
trap cleanup SIGINT

# restic prints one json object per line: first the snapshot, then a node for every file and dir.
# rebuild the tree from the paths and print it as the ncdu-style json that gdu imports with -f
restic --repo "$CUR_PATH/repo" ls --json "$SNAPSHOT" | python3 -c '
import json, re, sys, time
from datetime import datetime

def new_dir(name):
    return {"name": name, "size": 0, "mtime": 0, "dir": True, "children": {}}

def child(parent, name):
    return parent["children"].setdefault(name, new_dir(name))

def mtime(node):
    # python cannot parse the nanoseconds restic prints, so cut them down to microseconds
    stamp = re.sub(r"(\.\d{6})\d+", r"\1", node.get("mtime", ""))
    try:
        return int(datetime.fromisoformat(stamp).timestamp())
    except ValueError:
        return 0

root = new_dir(sys.argv[1])
for line in sys.stdin:
    node = json.loads(line)
    if node.get("struct_type") != "node":
        continue
    parts = [p for p in node["path"].split("/") if p]
    if not parts:
        continue
    cur = root
    for p in parts[:-1]:
        cur = child(cur, p)
    leaf = child(cur, parts[-1])
    leaf["dir"] = node.get("type") == "dir"
    leaf["size"] = node.get("size", 0)
    leaf["mtime"] = mtime(node)

def dump(node):
    if not node["dir"]:
        # restic only knows the real size, so the apparent and the disk size are the same
        return json.dumps({"name": node["name"], "asize": node["size"], "dsize": node["size"], "mtime": node["mtime"]})
    items = [json.dumps({"name": node["name"], "mtime": node["mtime"]})]
    items += [dump(c) for c in node["children"].values()]
    return "[" + ",\n".join(items) + "]"

sys.setrecursionlimit(10000)
header = {"progname": "restic", "progver": "1", "timestamp": int(time.time())}
print("[1,2," + json.dumps(header) + ",")
print(dump(root) + "]")
' "restic:$SNAPSHOT" > "$JSON"

gdu -f "$JSON"

rm -f "$JSON"
