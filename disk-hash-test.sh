# disk_test.sh (v2.0) written by Steven Branigan
# Copyright (c) 2011, CyanLine LLC
# funded by NIJ Grant 2010-DN-BX-K254
#
# This test script is used to generate timing data for data acquisitions
# with varying block sizes
# For testing, we assume source is /dev/sdb, output is /dev/null
DISK="/dev/sdb"
OUTPUT="/dev/null"
# we set the size of the amount of data to be 10GB
#size=10000000000
size=10000000000 # 10 GB
if [ -z $1 ]
then
  echo "Err:Must supply output filename.\n exiting"
  exit
fi
#
if [ -e $1 ]
then
  echo "Err:File already exists.\n exiting"
  exit
fi
#
ti=`date`
echo -n "$ti: Starting run " > $1
#
for i in 131072 65536 32768 4096 2048 1024 512 256 128 64 32 16 8 
do
  echo "testing with block size of $i" >> $1
  count=`expr $size / $i`
  actual_size=`expr $i \* $count` # to handle cases where the bs 
					    # is not a multiple of the size
  start_time=`date +%s` # get start time
  for hash in md5sum sha1sum sum
  do
    dd if=$DISK bs=$i count=$count | $hash  >>$1 2>&1
    end_time=`date +%s` # get end time
    total_time=`expr $end_time - $start_time` # calculate time needed
    total_minutes=`expr $total_time / 60` # for human readable time
    total_seconds=`expr $total_time - \( $total_minutes \* 60 \)`
    printf "Completed copy of %d bytes in %d seconds (%02d:%02d)\n" $actual_size $total_time $total_minutes $total_seconds  >> $1
    throughput=`expr $actual_size / $total_time`
    printf "TY=%s,DS=%d,BS=%d,TS=%d,TP=%d\n" $hash $actual_size $i $total_time $throughput  >> $1 # data line
    echo "---" >> $1
done
