singularity exec --bind $BIND_PATH --nv $SIGFILE \
        python $PARALLEL_PROGRAM --nproc_per_node $NGPUS \
        $PROGRAM --arch resnet50 \
        --batch-size $BATCH_SIZE \
        --training-only \
        --no-checkpoints \
        --print-freq 1 \
        --raport-file ${JOB_NAME}.${JOB_ID}.result.amp.json \
        --epochs 1 \
        --prof 100 \
	--amp \
	--static-loss-scale 256 \
        $DATADIR > ${JOB_NAME}.${JOB_ID}.amp.out
