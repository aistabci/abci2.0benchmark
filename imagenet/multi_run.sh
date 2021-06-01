source /etc/profile.d/modules.sh
module load singularitypro/3.7
module load openmpi/4.0.5

WORKDIR=`pwd`
SIGFILE_TRAIN=${WORKDIR}/../../programs/pytorch+horovod.sif
SIGFILE_PARSE=${WORKDIR}/../../programs/tensorflow_21.04-tf2-py3.sif
ARCHIVE=${WORKDIR}/../data/imagenet.tar

# Print hostname
mpirun -np $NHOSTS --map-by ppr:1:node -tag-output hostname

# Copy ImageNet dataset to local SSD
t0=$(date +%s)
mpirun -np $NHOSTS --map-by ppr:1:node tar xf $ARCHIVE -C $SGE_LOCALDIR
t1=$(date +%s)
echo "Time for stage-in: $((t1 - t0))"

# Run benchmark
PROG_TRAIN=/workspace/horovod/examples/pytorch/pytorch_imagenet_resnet50.py
PROG_PARSE=${WORKDIR}/../multi_parse_log.py
DATADIR=${SGE_LOCALDIR}/imagenet
LOGDIR=${SGE_LOCALDIR}/logs
LOGDIR_CP=${JOB_NAME}.${JOB_ID}
BIND_PATH=/groups

# total MPI processes
NMPIPROCS=$(($NHOSTS * $NPPN))
# number of processes/socket
NPPS=$(($NPPN / 2))

mpirun -np $NMPIPROCS --map-by ppr:${NPPS}:socket \
       -mca pml ob1 -mca btl self,tcp -mca btl_tcp_if_include bond0 \
       -x PATH \
       -x LD_LIBRARY_PATH \
       -x NCCL_NET_GDR_LEVEL=2 \
       singularity exec --bind $BIND_PATH --nv $SIGFILE_TRAIN \
       python $PROG_TRAIN --train-dir ${DATADIR}/train \
                          --val-dir ${DATADIR}/val \
                          --log-dir ${LOGDIR} \
                          --checkpoint-format ${SGE_LOCALDIR}/ckpt-{epoch}.tar \
                          --batch-size $BATCH_SIZE \
                          --val-batch-size $BATCH_SIZE \
                          --epochs 90

# Parse log and print training time
cp -r $LOGDIR $LOGDIR_CP
singularity exec --bind $BIND_PATH --nv $SIGFILE_PARSE \
python $PROG_PARSE $LOGDIR_CP
