#!/bin/sh
#$-l rt_AF=4
#$-cwd
#$-l h_rt=04:00:00

# number of processes/node (GPUs)
NPPN=8
# batch size
BATCH_SIZE=256

source ../multi_run.sh
