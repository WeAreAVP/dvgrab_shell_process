#!/bin/bash
# script to capture dv files from tape into a directory with logging
# written by Dave Rice, AudioVisual Preservation Solutions for City of Vancouver Archives, 2011-04-13
# declare directory for packages of dv files to be written to
output_dir=~/Desktop
while true; do
	# prompt user for tape name
	echo -n "Enter Tape Identifier (or enter 'quit' to quit): "
	read tape_id
	if [ -n "$tape_id" ]; then
		exit 0
	fi
	if [ "$tape_id" == "quit" ]; then
		exit 0
	fi
	mkdir -v -p "${output_dir}/${tape_id}"
	pushd "${output_dir}/${tape_id}"
	dvgrab -rewind -showstatus -srt -timecode "${tape_id}" 2>&1 | tee -a dvgrab.log
	# rename all files that contain colons to contain underscores
	echo finished capturing tape...
	# not sure if dvcont eject will work on the deck, but in case it does
	dvcont eject
	echo renaming files...
	for file in *:*; do
		newname=`echo "$dvfile" | sed 's/:/_/g'`
		mv -v "$dvfile" "$newname"
	done
	echo running dvanalyzer…
	for file in *.dv; do
		xml=`echo "$file" | sed 's/.dv/.xml/'`
		dvanalyzer --XML "$file" > "$xml"
	done
	popd
done