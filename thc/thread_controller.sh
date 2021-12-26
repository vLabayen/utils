#!/bin/bash

# ThC - Thread Controller
# A set of functions to handle multithreading
# Usage:
#	1) init the controller
#		$ thc_init <num_threads>
#	2) Run anything you want in the background and store the pid
#		$ ./my_script &
#		$ thc_store_pid $!
#	3) Ensure that there are available slots before returning to step 2)
#		$ thc_wait_for_any
#		or
#		$ thc_wait_for_all
#
# Usage examples in <gitrepo/tests>
# version: 1.1



# Init pids array and empty index
function thc_init() {
	thc_num_threads=$1
	unset $thc_pids

	if [ -z "$2" ]; then thc_sleep_time=2
	else thc_sleep_time=$2; fi

	for thc_i in $(seq 1 $(($thc_num_threads - 1))); do thc_pids[$thc_i]=0; done
	thc_empty_index=0
}

# Store the given pid
function thc_store_pid() {
	thc_pids[$thc_empty_index]=$1
}

# Wait until any pid is found as 0 or a non 0 pid's process does not exists
function thc_wait_for_any() {
	# Loop until return
	#	If a pid is 0, return 0
	#	Check for all the pids if the process still exists
	#		return 0 when any does not exists
	#	sleep between pids array looping

	while true; do
		for thc_index in ${!thc_pids[*]}; do
			thc_PID=${thc_pids[$thc_index]}

			if [ $thc_PID -eq 0 ]; then
				thc_empty_index=$thc_index
				return 0
			fi

			if ! ps -p $thc_PID > /dev/null 2>&1; then
				thc_pids[$thc_index]=0
				thc_empty_index=$thc_index
				return 0
			fi
		done
		sleep $thc_sleep_time
	done
}

# Wait for all non 0 pid's process to end
function thc_wait_for_all() {
	# Loop until return
	# 	exit_flag = true
	#	Loop through all the pids
	#		Update the pis with a 0 if the process does not exists anymore
	#		if the pid is not 0, exit_flag = false
	#	if exit_flag, return 0
	#	sleep

	while true; do
		thc_break_while=1
		for thc_index in ${!thc_pids[*]}; do
			thc_PID=${thc_pids[$thc_index]}
			if [ $thc_PID -ne 0 ]; then
				if ! ps -p $thc_PID > /dev/null 2>&1; then
					thc_pids[$thc_index]=0
				fi
			fi

			if [ $thc_PID -ne 0 ]; then
				thc_break_while=0
			fi
		done

		if [ $thc_break_while -eq 1 ]; then
			thc_index=0
			return 0
		fi

		sleep $thc_sleep_time
	done
}
