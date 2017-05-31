#!/usr/bin/env bash

infile=${1}
outfile=${2}

if [ ! -e "$infile" ]
then
	echo "Usage ./videorotator.sh infile outfile"
	exit 1
fi

mencoder -vf rotate=1 -o $outfile -oac pcm -ovc lavc $infile

