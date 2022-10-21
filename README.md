# cwl_nextflow_examples
This repo demonstrates how a simple bash pipeline can be written using
pipeline definition languages CWL and Nextflow, and how they can be run
locally to validate them.

## Setup
This code is written and tested in Ubuntu 20.04 LTS.

System prerequisites CWL:
```
sudo apt install cwltool
sudo apt install docker.io
```
This installs the CWL reference runner, which allows for easy execution
of CWL pipelines on localhost. CWL is meant to be portable ("bring the
computation to the data"), many of the advantages are in this portability.

CWL code is executed in parallel where possible by most execution engines.
This reference runner does not parallelize execution, but it is still a
perfect tool for validating CWL pipelines.

Docker is required for Nextflow as well as CWL. It is encouraged to use
Docker containers for any executable part of a pipeline. This is one
prerequisite for making it truly portable.

System prerequisites Nextflow:
```
curl -s https://get.nextflow.io | bash 
sudo mv nextflow /usr/bin/nextflow
sudo chmod a+rx /usr/bin/nextflow
```

Nextflow also requires Java to be installed. The examples in this repo
are written with OpenJDK 13 JRE installed: 
```
sudo apt install openjdk-13-jre-headless
```

Then you can clone this repo and enter its main directory:
```
git clone https://github.com/AlexanderSenf/cwl_nextflow_examples.git
cd cwl_nextflow_examples/
```

The main data and Bash pipeline are in the main directory; CWL code is
in the /cwl directory, Nextflow code is in the /nextflow directory.

There are many more pipeline definition languages (e.g. Snakemake, WDL, ..)
but I would recommend either CWL or Nextflow.

## Basic Bash pipeline

This a a very simple pipeline, it is intended to cover the basics of
the mechanims for handling several indvidual steps over multiple input
files, both individually and over all files combined.

Example input files are already in this repo; this script generates
10 new *.bin files: `data.sh`
1 - Create 10 files with random characters

This is the demo pipeline: `pipeline.sh`
1 - Calculate MD5 sum of each file into an MD5 file
2 - Count characters across all MD5 files
3 - Combine all original files into one file

The pipeline uses loops to perform actions on individual
files and to combine statistics across all files. 

## CWL (Common Workflow Language)

CWL pipelines have two concepts: Tasks and Workflows. Each are written
as separate structured text files. Tasks usually encapsulate one
command, workflows or a sequence of tasks (and other workflows).

CWL is incredibly flexible in what an individual task can contain:
anyhting that can be run on a command line. It is possible, for
example, to call `bash pipeline.sh`, which would wrap the entire
existing pipeline script as a single task.

Depending on the content of the script, if there is a Docker image
that can run the pipeline, this could immediately make the pipeline
portable and executable by execution systems, such as the AWS
Gemonics CLI.

However, that would lose out on most of the advantages of pipeline
definition languages: modularity, code re-use, parallel execution,
scalability.

On the other extreme, it is possible to specify every individual
step as a separate CWL Task, as building blocks. And then build
the pipeline using these building blocks. There are even graphical
tools available that allow for building a CWL pipeline in a GUI.

This example shows the latter approach, by first deconstructing
the elements of the pipeline into individual tasks. It is common
to place tasks in their own files, to enhance re-usability. There
are several existing repsoitories that contain pre-defined
building blocks, which make it easy to write new pipelines without
having to repeat common tasks. However, it is also possible to
place all code for a pipeline in a single file.

The MD5 calculation step is easy: it merely calls the command to
calculate the checksum.

The step counting the characters in all MD5 files produced in
the previous step is comprised of several Linux commands; so for
maximum separation of tasks, this line is separated into two tasks:
(1) to produce the file with the count of the input file, and (2)
to separate the number from the filename and treat it as a value.

[etc.. this shows the principle]

A look at CWL from a Python programmer's point of view is also 
[here](https://github.com/AlexanderSenf/pipelines_intro).

## Nextflow

Nextflow pipelines have the same concepts and define individual
tasks/processes that combine to form the pipeline. Processes can be
defined in separate files for increased re-usability of the code; but
it is also common to place al code required for a pipeline in a single
file; the example provided here used a single file.

Nextflow pipelines work on Channels. A channel is a place that holds
data (values, paths, files, etc.). Processes take data from channels as
input and place output in new channels. The order in which a pipeline
is executed is determoned by the dependencies of the channels. A
process will be executed as soon (and as long) as there is data in the
input channel.

Comparing the shell script with the Nextflow script shows that Nextflow
has no explicit notion of execution on multipe inputs; each process just
defines work on data point. If there are multiple values in the input
channel, they are automatically run in parallel on all input data, as
far as dependencies allow for it.

The example pipeline runs entirely in Linux; but is is recommended to
run all commands in Docker containers, to make the pipeline truly
portable. This is as easy as specifying `-with-docker [docker image]`
as part of the run command. It can also be set as default when running
a pipeline, and each process can specify its own Docker image.