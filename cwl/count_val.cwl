#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

baseCommand: [cut, -d, " ", -f1]
stdout: $(inputs.filename.basename).val

inputs:
  filename:
    type: File
    inputBinding:
      position: 1
  
outputs:
  value:
    type: int
    outputBinding:
      glob: $(inputs.filename.basename).val
      loadContents: true
      outputEval: $(parseInt(self[0].contents))
