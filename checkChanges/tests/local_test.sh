#/bin/bash

ts=$(date +%s)
checkChangesPath=$(realpath "$(pwd)/..")
rootdir="test_$ts"
src_rootdir="$(pwd)/$rootdir/s"
dst_rootdir="$(pwd)/$rootdir/d"
num_steps=7

function echo_step() {
	#echo_step num_step step_msg
	echo "Step $1/$num_steps $2"
	echo "Press [ENTER] to start"
	read
}

function echo_info() {
	#echo_info msg
	echo "[TEST_INFO] $1"
}


#----- STEP 0 -----
mkdir -p "$src_rootdir"
mkdir -p "$dst_rootdir"
echo_info "Src and dst folder created"
echo_info "Run mon_dir.sh to view realtime changes in src & dst"
echo_info "./mon_dir.sh $src_rootdir $dst_rootdir"
echo ""

#----- STEP 1 -----
echo_step 1 "Creating test folders & files"

mkdir -p "$src_rootdir/1"
mkdir -p "$src_rootdir/2"
echo "a" > "$src_rootdir/1/a.txt"
echo "b" > "$src_rootdir/1/b.txt"
echo "a" > "$src_rootdir/2/a.txt"
echo "b" > "$src_rootdir/2/b.txt"

mkdir -p "$dst_rootdir/1"
echo "a" > "$dst_rootdir/1/a.txt"
#----- STEP 1 -----


#----- STEP 2 -----
echo_step 2 "Launching check changes"
bash $checkChangesPath/checkChanges -s "$src_rootdir" -d "$dst_rootdir" -v --color &
pid=$!
sleep 2
#----- STEP 2 -----


#----- STEP 3 -----
echo_step 3 "Updating files 1/a.txt, 1/b.txt, 2/a.txt, 2/b.txt"
echo "1" >> "$src_rootdir/1/a.txt"
echo "1" >> "$src_rootdir/1/b.txt"
echo "2" >> "$src_rootdir/2/a.txt"
echo "2" >> "$src_rootdir/2/b.txt"
sleep 2
#----- STEP 3 -----


#----- STEP 4 -----
echo_step 4 "Creating files 1/c.txt, 1/d.txt, 2/c.txt"
echo "c" >> "$src_rootdir/1/c.txt"
echo "d" >> "$src_rootdir/1/d.txt"
echo "c" >> "$src_rootdir/2/c.txt"
sleep 2
#----- STEP 4 -----


#----- STEP 5 -----
echo_step 5 "Removing files 1/a.txt, 1/b.txt, 2/a.txt, 2/b.txt"
rm "$src_rootdir/1/a.txt"
rm "$src_rootdir/1/b.txt"
rm "$src_rootdir/2/a.txt"
rm "$src_rootdir/2/b.txt"
sleep 2
#----- STEP 5 -----


#----- STEP 6 -----
echo_step 6 "Removing folders 1 & 2"
rm -r "$src_rootdir/1"
rm -r "$src_rootdir/2"
sleep 2
#----- STEP 6 -----


#----- STEP 7 -----
echo_step 7 "Creating folder 3 and files 3/a.txt, 3/b.txt"
mkdir -p "$src_rootdir/3"
echo "a" > "$src_rootdir/3/a.txt"
echo "b" > "$src_rootdir/3/b.txt"
sleep 5
#----- STEP 7 -----


echo "Press [ENTER] to end"
read
kill $pid
rm -r $rootdir
