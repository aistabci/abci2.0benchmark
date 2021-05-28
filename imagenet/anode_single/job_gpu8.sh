#!/bin/sh
#$-l rt_AF=1
#$-cwd
#$-l h_rt=00:30:00

source /etc/profile.d/modules.sh
module load singularitypro/3.7
source ../single_common.sh

NGPUS=8
BATCH_SIZE=256

source ../single_run.sh
source ../single_run_amp.sh
