#!/bin/bash

while true; do
	text=()

	text+=("Now : $(date)")
	text+=("")

	text+=("Src folder:")
	files=$(find $1 -type f)
	for f in $files; do text+=("$f"); done

	text+=("")

	text+=("Dst folder:")
	files=$(find $2 -type f)
	for f in $files; do text+=("$f"); done

	clear
	for i in ${!text[@]}; do echo ${text[$i]}; done
	sleep 0.2
done
