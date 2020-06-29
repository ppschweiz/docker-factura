#!/bin/sh

while :
do
	echo "Starting round..."

	./run-facturer.sh

	DOW=$(date +%u)
	HOUR=$(date +%H)

	if [ "$DOW" -eq 1 ]
	then
		if [ "$HOUR" -gt 19 ]
		then
			./run-stats.sh
		fi
	fi

	for i in $(seq 1 24);
	do
		for i in $(seq 1 30);
		do
			sleep 10
		done
		date
	done
done
