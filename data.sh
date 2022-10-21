#! /bin/bash

# Create 10 random files with extension ".bin"
# (Saving requirement for input files)
echo "Creating input files"
for n in {1..10}; do
    dd if=/dev/urandom of=file$( printf %03d "$n" ).bin bs=1 count=$(( RANDOM + 1024 ))
done
