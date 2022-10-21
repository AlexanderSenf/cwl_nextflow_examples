#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

baseCommand: echo

stdout: all_vals.txt

inputs:
  counts:
    type: int[]
    inputBinding:
      position: 1
  
outputs:
  file:
    type: stdout
