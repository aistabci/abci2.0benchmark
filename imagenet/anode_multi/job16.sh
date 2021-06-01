#!/bin/sh
#$-l rt_AF=16
#$-cwd
#$-l h_rt=02:00:00

# number of processes/node (GPUs)
NPPN=8
# batch size
BATCH_SIZE=256

source ../multi_run.sh
