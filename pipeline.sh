#! /bin/bash

# Calculate md5 of all files with extension ".bin"
# (Individual action on each file)
echo "Calculating md5 of input files"
for i in *.bin; do
    md5sum "$i" > "$i.md5"
    sleep 5
done

# Count total characters (e.g., for QC purposes)
# (Action across all files)
echo "Calculating number of characters in input files"
for i in *.md5; do
    let cnt="cnt+$(wc -c $i | cut -d' ' -f1)"
    sleep 5
done
echo $cnt > count.all.bin.txt

# Collate into one file 
# (Combining multiple files into one)
echo "Collate all input files"
cat *.bin > all.bin
