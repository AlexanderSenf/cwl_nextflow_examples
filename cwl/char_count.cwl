#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

baseCommand: wc
stdout: $(inputs.filename.basename).cnt

inputs:
  filename:
    type: File
    inputBinding:
      position: 1
      prefix: -c

outputs:
  file:
    type: stdout
