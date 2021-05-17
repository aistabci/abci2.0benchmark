#!/bin/sh
#$-l rt_AF=2
#$-cwd
#$-l h_rt=0:10:00

source /etc/profile.d/modules.sh
module load cuda/11.2/11.2.2
module load openmpi/4.0.5
module load gdrcopy/2.1

export UCX_HOME=/apps/rhel8/ucx/1.9.0/gcc8.3.1_cuda11.2.2_gdrcopy2.1
export LD_LIBRARY_PATH=${UCX_HOME}/lib:${LD_LIBRARY_PATH}

WORKDIR=`pwd`
OMBDIR=${WORKDIR}/../omb-5.7-anode/libexec/osu-micro-benchmarks
PROG_LATENCY=${OMBDIR}/mpi/pt2pt/osu_latency
PROG_BANDWIDTH=${OMBDIR}/mpi/pt2pt/osu_bw
PROG_OPTION="-m 8388608 -d cuda"

# number of processes/node (GPUs)
NPPN=1
# total MPI processes
NMPIPROCS=$(($NHOSTS * $NPPN))

mpirun -np $NMPIPROCS --map-by ppr:${NPPN}:node -tag-output hostname

mpirun -np $NMPIPROCS --map-by ppr:${NPPN}:node \
       --mca btl_openib_want_cuda_gdr 1 \
       -x PATH \
       -x LD_LIBRARY_PATH \
       ${PROG_LATENCY} ${PROG_OPTION} D D > ${JOB_NAME}.latency

mpirun -np $NMPIPROCS --map-by ppr:${NPPN}:node \
       --mca btl_openib_want_cuda_gdr 1 \
       -x PATH \
       -x LD_LIBRARY_PATH \
       ${PROG_BANDWIDTH} ${PROG_OPTION} D D > ${JOB_NAME}.bandwidth

