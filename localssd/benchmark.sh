#!/bin/sh

#sequential read
$PROGRAM -name=seqread -loops=5 -size=1G -direct=1 -rw=read -bs=4096K -filename=$TEST_FILE > 00-seqread.txt
rm $TEST_FILE

#sequential write
$PROGRAM -name=seqwrite -loops=5 -size=1G -direct=1 -rw=write -bs=4096K -filename=$TEST_FILE > 01-seqwrite.txt
rm $TEST_FILE

# randowm read
$PROGRAM -name=randread -loops=5 -size=1G -direct=1 -numjobs=64 -group_reporting -rw=randread -bs=4K -filename=$TEST_FILE > 02-randread.txt
rm $TEST_FILE

# random write
$PROGRAM -name=randwrite -loops=5 -size=1G -direct=1 -numjobs=64 -group_reporting -rw=randwrite -bs=4K -filename=$TEST_FILE > 03-randwrite.txt
rm $TEST_FILE

