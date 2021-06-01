#!/bin/sh
#$-l rt_AF=4
#$-cwd
#$-l h_rt=0:10:00

source /etc/profile.d/modules.sh

OUTPUT_PREFIX=${JOB_NAME}.${JOB_ID}

# number of processes/node (GPUs)
NPPN=8
# total MPI processes
NMPIPROCS=$(($NHOSTS * $NPPN))
# number of processes/socket
NPPS=$(($NPPN / 2))

module load openmpi/4.0.5
mpirun -np $NMPIPROCS --map-by ppr:${NPPS}:socket -tag-output hostname
module purge

source ../mpi_anode.sh
source ../mpi-cpu_anode.sh
source ../nccl_anode.sh
