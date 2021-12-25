INDIR=/mnt/ausb1/repo/tpcdata/data100
OUTDIR=/var/db2ce/backup/scratch

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

catpipetable() {
   local -r f=$INDIR/$1.dat
   local D=`outtable $f`
   echo "$f =>  $D"
   cat $f >>$D
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
#catpipetable customer
#catpipetable store_sales
catpipe
