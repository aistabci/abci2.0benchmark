#!/bin/sh
#$-l rt_F=8
#$-cwd
#$-l h_rt=12:00:00

# number of processes/node (GPUs)
NPPN=4
# batch size
BATCH_SIZE=96

source ../multi_run.sh
