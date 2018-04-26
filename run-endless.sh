#!/bin/bash

while :
do
	echo "Starting round..."

	./run-facturer.sh

        for i in `seq 1 24`;
        do
        	for i in `seq 1 30`;
        	do
			sleep 10
        	done
		date
        done    
done

