#!/bin/bash

source "$(pwd)/../thread_controller.sh"
num_threads=3

thc_init $num_threads
for i in $(seq 1 15); do
	t=$(( ( $RANDOM % 10 )  + 1 ))
        echo "$(date +%H:%M:%S.%N): Running sleep for $t seconds. Call $i/15"

        sleep $t &
        thc_store_pid $!

        thc_wait_for_any
done
echo "$(date +%H:%M:%S.%N): All running"
thc_wait_for_all
echo "$(date +%H:%M:%S.%N): All ended"

