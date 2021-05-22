#!/bin/sh
#$-l rt_F=2
#$-cwd
#$-l h_rt=0:10:00

source /etc/profile.d/modules.sh

# number of processes/node (GPUs)
NPPN=4
# total MPI processes
NMPIPROCS=$(($NHOSTS * $NPPN))
# number of processes/socket
NPPS=$(($NPPN / 2))

module load gcc/7.4.0
module load openmpi/4.0.5
mpirun -np $NMPIPROCS --map-by ppr:${NPPS}:socket -tag-output hostname
module purge

source ../mpi_vnode.sh "${JOB_NAME}.${JOB_ID}" $NMPIPROCS $NPPN $NPPS
source ../mpi-cpu_vnode.sh "${JOB_NAME}.${JOB_ID}" $NMPIPROCS $NPPN $NPPS
source ../nccl_vnode.sh "${JOB_NAME}.${JOB_ID}" $NMPIPROCS $NPPN $NPPS
