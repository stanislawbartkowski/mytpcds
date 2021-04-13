INDIR=/mnt/usb/repo/tpcdata/data1
OUTDIR=/var/db2warehouse/scratch/loadarea

mkdir -p $OUTDIR -m 777

outtable() {
    local -r tbl=`basename $1`
    echo "$OUTDIR/$tbl"
}

remove() {
   for f in $INDIR/*.dat
   do
     local D=`outtable $f`
     echo "rm -rf $D"
     rm -f $D
   done
}

createpipe() {
   for f in $INDIR/*.dat
   do
     local D=`outtable $f`
     echo "mkfifo -m 666 $D"
     mkfifo $D -m 666
   done

}

catpipe() {
   for f in $INDIR/*.dat
   do
     local D=`outtable $f`
     echo "$f =>  $D"
     cat $f >>$D
   done
}

remove
createpipe
catpipe
