#!/bin/sh
#$-l rt_AF=1
#$-cwd
#$-l h_rt=00:30:00

source /etc/profile.d/modules.sh
module load singularitypro/3.7

WORKDIR=`pwd`
SIGFILE=${WORKDIR}/../pytorch_21.04-py3.sif
ARCHIVE=${WORKDIR}/../data/imagenet.tar

PARALLEL_PROGRAM=/workspace/examples/resnet50v1.5/multiproc.py
PROGRAM=/workspace/examples/resnet50v1.5/main.py
DATADIR=${SGE_LOCALDIR}/imagenet
BIND_PATH=/groups,/local1
NGPUS=4
BATCH_SIZE=256

hostname

t0=$(date +%s)
tar xf $ARCHIVE -C $SGE_LOCALDIR
t1=$(date +%s)
echo "Time for stage-in: $((t1 - t0))"; echo; echo

singularity exec --bind $BIND_PATH --nv $SIGFILE \
        python $PARALLEL_PROGRAM --nproc_per_node $NGPUS \
        $PROGRAM --arch resnet50 \
        --batch-size $BATCH_SIZE \
        --training-only \
        --no-checkpoints \
        --print-freq 1 \
        --raport-file benchmark_result.json \
        --epochs 1 \
        --prof 100 \
        $DATADIR

