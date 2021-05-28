singularity exec --bind $BIND_PATH --nv $SIGFILE \
        python $PARALLEL_PROGRAM --nproc_per_node $NGPUS \
        $PROGRAM --arch resnet50 \
        --batch-size $BATCH_SIZE \
        --training-only \
        --no-checkpoints \
        --print-freq 1 \
        --raport-file ${JOB_NAME}.${JOB_ID}.result.json \
        --epochs 1 \
        --prof 100 \
        $DATADIR > ${JOB_NAME}.${JOB_ID}.out
