#!/bin/sh
#$-l rt_AF=2
#$-cwd
#$-l h_rt=0:10:00

source /etc/profile.d/modules.sh

# number of processes/node (GPUs)
NPPN=1
# total MPI processes
NMPIPROCS=$(($NHOSTS * $NPPN))

module load openmpi/4.0.5
mpirun -np $NMPIPROCS --map-by ppr:${NPPN}:node -tag-output hostname
module purge

source ./pt2pt_1gpu.sh "${JOB_NAME}.${JOB_ID}" $NMPIPROCS $NPPN
source ./pt2pt_1prc.sh "${JOB_NAME}.${JOB_ID}" $NMPIPROCS $NPPN
