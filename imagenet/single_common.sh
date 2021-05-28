WORKDIR=`pwd`
SIGFILE=${WORKDIR}/../../programs/pytorch_21.04-py3.sif
ARCHIVE=${WORKDIR}/../data/imagenet.tar

PARALLEL_PROGRAM=/workspace/examples/resnet50v1.5/multiproc.py
PROGRAM=/workspace/examples/resnet50v1.5/main.py
DATADIR=${SGE_LOCALDIR}/imagenet
BIND_PATH=/groups

hostname

t0=$(date +%s)
tar xf $ARCHIVE -C $SGE_LOCALDIR
t1=$(date +%s)
echo "Time for stage-in: $((t1 - t0))"

