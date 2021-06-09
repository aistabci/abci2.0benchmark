#!/bin/sh
#$-l rt_F=1
#$-t 1-10
#$-cwd
#$-l h_rt=0:10:00

source /etc/profile.d/modules.sh
module load cuda/11.2/11.2.2

WORKDIR=`pwd`
PROGDIR=${WORKDIR}/../../programs/cuda-samples-vnode/1_Utilities
PROG=${PROGDIR}/p2pBandwidthLatencyTest/p2pBandwidthLatencyTest

hostname
echo
$PROG
