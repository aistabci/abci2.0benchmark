OUTPUT="${1}.nccl"
NMPIPROCS=$2
NPPN=$3
NPPS=$4

module load openmpi/4.0.5
module load cuda/11.2/11.2.2
module load nccl/2.8/2.8.4-1

WORKDIR=`pwd`
OMBDIR=${WORKDIR}/../../programs/nccl-tests-anode/build
PROG=${OMBDIR}/all_reduce_perf
PROG_OPTION="-t 1 -g 1 -b 4 -e 32M -f 2 -n 100"

mpirun -np $NMPIPROCS --map-by ppr:${NPPS}:socket \
       --mca pml ucx --mca osc ucx \
       -x PATH \
       -x LD_LIBRARY_PATH \
       -x UCX_WARN_UNUSED_ENV_VARS=n \
       -x NCCL_IB_CUDA_SUPPORT=1 \
       ${PROG} ${PROG_OPTION} > $OUTPUT

module purge
