#!/usr/bin/env nextflow

// Usage: nextflow run pipeline.nf --list files.txt

// Get list of files specified in parameter 'list'; split into two
params.list = "files_all.txt" // Default, which can be overridden
file_list = Channel.from(file(params.list).readLines())
file_list.into { files_md5; files_merge }

// Output: default local dir, allow for specification of path
params.folder = "./"
myDir = file(params.folder)
myDir.mkdirs()

// Calculate MD5 of each file individually, write to output
process parallel_md5sum {

  input:
  path data_file from files_md5
 
  output:
  file('md5sum') into md5sum_files
 
  """
  md5sum $data_file > md5sum
  sleep 5
  """
}

// Produce the total count over all MD5 Checksum files
process cnt_chars {

    input:
    val myval from md5sum_files

    output:
    env cnt_char into cnt_char_channel

    shell:
    """
    cnt_char="\$(wc -c $myval | cut -d' ' -f1)"
    sleep 5
    """
}

// This is just like Groovy/Java code. It is possible to add statements:
//println cnt_char_channel.toInteger().sum().view()

// Sum all lenghts produced in the previous step into one number, save
process save_cnt {

    input:
    val cnt from cnt_char_channel.toInteger().sum()

    output:
    file('count.all.bin.txt') into count_file

    """
    echo $cnt > count.all.bin.txt
    """
}

// Merge all files into one
process merge {
    input:
    path file_path from files_merge

    output:
    file('all.bin') into merge_file

    """
    cat $file_path > all.bin
    """
}

// Produce output files (can be any channel)
count_file.subscribe { it.copyTo(myDir) }
merge_file.subscribe { it.copyTo(myDir) }
