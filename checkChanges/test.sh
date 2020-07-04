#/bin/bash

ts=$(date +%s)
rootdir="test_$ts"

mkdir -p "$rootdir/1/2/s/a/b/c"
echo "a" > "$rootdir/1/2/s/a/b/c/a.txt"
echo "b" > "$rootdir/1/2/s/a/b/c/b.txt"
mkdir "$rootdir/d"

bash checkChanges -s "$rootdir/1/2/s" -d "$rootdir/d" -v --color &

sleep 2
echo "a" >> "$rootdir/1/2/s/a/b/c/a.txt"
echo "b" >> "$rootdir/1/2/s/a/b/c/b.txt"
echo "c" > "$rootdir/1/2/s/a/b/c/c.txt"

sleep 2
rm "$rootdir/1/2/s/a/b/c/a.txt"
rm "$rootdir/1/2/s/a/b/c/b.txt"

sleep 2
rm -r "$rootdir/1/2/s/a/b/"

sleep 2
rm -r "$rootdir/1"
