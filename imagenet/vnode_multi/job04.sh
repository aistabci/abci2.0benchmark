#!/bin/sh
#$-l rt_F=4
#$-cwd
#$-l h_rt=24:00:00

# number of processes/node (GPUs)
NPPN=4
# batch size
BATCH_SIZE=96

source ../multi_run.sh
