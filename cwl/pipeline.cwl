#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

#####

requirements:
  ScatterFeatureRequirement: {}

#####

inputs:

  FILENAME: File[]

#####

outputs: []


#####

steps:

    md5_step:
      run: md5sum.cwl
      scatter: [filename]
      scatterMethod: dotproduct
      in:
        filename: FILENAME
      out: [file]
      
    cnt_file_step:
      run: char_count.cwl
      scatter: [filename]
      scatterMethod: dotproduct
      in:
        filename: md5_step/file
      out: [file]

    cnt_val_step:
      run: count_val.cwl
      scatter: [filename]
      scatterMethod: dotproduct
      in:
        filename: cnt_file_step/file
      out: [value]


