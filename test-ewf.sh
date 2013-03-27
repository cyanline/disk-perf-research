# written by Steven Branigan
# copyright (c) 2012, CyanLine LLC
# Funded by NIJ Grant 2010-DN-BX-K254
#
# Purpose: To collect timing needed to acquire data from a disk with different
# parameters when using ewfacquire
#
#heavily parameter driven
#
SIZE=10000000000
#SIZE=1000000000
#DIGEST or sha1 or sha256
DIGEST=md5
#sectors could be 16,32,64,128,256,512,1024,2048,4096,8192,16384,32768
SECTORS=64
#file format: ewf,smart,ftk,encase2,encase3,encase4,encase5,encase6,linen5,linen
6,ewfx
FORMAT=encase6
# error granularity
ERR_G=64
# error retry
ERR_RETRY=2
# segment size max of 7.9 EiB for encase6, 1.9 GiB, default is 1.4GiB
SEG_SZ=1.4GiB
# compression: none, fast, best
CMP=fast
# bytes per sector: could be 512 or 4096
SEC_BYTES=512
# output file name
FILE=/a/test
LOG_FILE="run_data_log.txt"
#

#
if [ -z "$1" ]
then
  echo "Usage: enter source"
  exit
fi
if [ -e "$LOG_FILE" ]
then
  echo "Log file $LOG_FILE still exists. Please clear and restart."
  exit
fi
#
# check that a log directory is available
if [ ! -d "log" ]
then
        echo "creating a log directory..."
        mkdir log
        if [ $? -eq 0 ]
        then
                echo "Created..."
        else
                echo "Could not create log directory."
                echo "exiting..."
            exit
        fi
else
        echo "Log directory already exists"
        echo -n "Continue? [y/N]"
        read ans
        if [ $ans -ne "y" -a $ans -ne "Y" ]
        then
                echo "Exiting..."
                exit
        fi
fi
#
echo "SIZE,time,CMP,FORMAT,SECTORS,SEC_BYTES,DIGEST,SEG_SZ" > $LOG_FILE
#
for CMP in none fast best
do
  for FORMAT in smart encase6 linen5 linen6
  do
    for SECTORS in 16 64 512 4096 32768
    do
      for SEC_BYTES in 512 4096
      do
        for DIGEST in md5 sha1 sha256
        do
          for SEG_SZ in 1.4GiB 1.9GiB
          do
              test=`ls $FILE* | wc -l`
              if [ $test -gt 0 ]
              then
                rm $FILE*
              fi
              start=`date +%s`
ewfacquire $1 -t $FILE -f $FORMAT -C fdas -D "FDAS image" -E 1 -e a -N note -m f
ixed -M physical -c $CMP -o 0 -B $SIZE -S $SEG_SZ -b $SECTORS -P $SEC_BYTES -g $
ERR_G -r $ERR_RETRY -u -w -q -l $FILE-log.txt > run-log.txt
              end=`date +%s`
              OUTFILE="log/$CMP-$FORMAT-$SECTORS-$SEC_BYTES-$DIGEST-$SEG_SZ-run-
log.txt"
              mv run-log.txt $OUTFILE
              ls -l /a >> $OUTFILE
              du -sh /a/* >> $OUTFILE
              time=`expr $end - $start`
              echo "$SIZE,$time,$CMP,$FORMAT,$SECTORS,$SEC_BYTES,$DIGEST,$SEG_SZ
" >> $LOG_FILE
          done # SEG_SZ
        done # DIGEST
      done #SEC_BYTES
    done #SECTORS
  done #FORMAT
done #CMP
