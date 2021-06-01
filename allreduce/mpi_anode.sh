OUTPUT="${OUTPUT_PREFIX}.mpi"

module load cuda/11.2/11.2.2
module load openmpi/4.0.5
module load gdrcopy/2.1

export UCX_HOME=/apps/rhel8/ucx/1.9.0/gcc8.3.1_cuda11.2.2_gdrcopy2.1
export LD_LIBRARY_PATH=${UCX_HOME}/lib:${LD_LIBRARY_PATH}

WORKDIR=`pwd`
OMBDIR=${WORKDIR}/../../programs/omb-5.7-anode/libexec/osu-micro-benchmarks
PROG=${OMBDIR}/mpi/collective/osu_allreduce
PROG_OPTION="-m 33554432 -d cuda -f -r gpu"

mpirun -np $NMPIPROCS --map-by ppr:${NPPS}:socket \
       --mca pml ucx --mca osc ucx \
       -x PATH \
       -x LD_LIBRARY_PATH \
       -x UCX_WARN_UNUSED_ENV_VARS=n \
       ${PROG} ${PROG_OPTION} > $OUTPUT

module purge
