#!/bin/sh
#$-l rt_F=32
#$-cwd
#$-l h_rt=06:00:00

# number of processes/node (GPUs)
NPPN=4
# batch size
BATCH_SIZE=96

source ../multi_run.sh
