#!/bin/sh
#$-l rt_AF=1
#$-cwd
#$-l h_rt=12:00:00

# number of processes/node (GPUs)
NPPN=8
# batch size
BATCH_SIZE=256

source ../multi_run.sh
