#!/bin/sh
#$-l rt_AF=1
#$-cwd
#$-l h_rt=00:20:00

source /etc/profile.d/modules.sh

export WORKDIR=`pwd`
export PROGRAM=${WORKDIR}/fio-3.26/bin/fio
export TEST_FILE=${SGE_LOCALDIR}/testfile

hostname

bash ../benchmark.sh
