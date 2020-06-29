#set -x
#w

verifyqueries() {
    SQLDIALECT=${SQLDIALECT:-$DTYPE}
    DSQGEN=$TCPROOT/tools/dsqgen
    STREAMNUMBER=${STREAMNUMBER:-4}
    [ -x $DSQGEN ] || logfail "Cannot find $DSQGEN"
    QUERYTEMPLATES=$TCPROOT/query_templates
    SQLQUERIES=$TCPROOT/work/${DTYPE}queries
    SCALE=${SCALE:-1}
    mkdir -p $SQLQUERIES
    QUALIFYDIR=qualification
}

producequeries() {
    local -r DIR=$1
    local -r SIZE=$2
    local -r STREAMS=$3
    cd $TCPROOT/tools
    ./dsqgen -VERBOSE Y -DIRECTORY $DIR -INPUT $DIR/templates.lst -OUTPUT_DIR $SQLQUERIES -DIALECT $SQLDIALECT -SCALE $SCALE -STREAMS $STREAMS
    [ $? -eq 0 ] || logfail "$DSQGEN failed"
    cd $STARTPWD
}

producestreams() {
    verifyqueries
    producequeries $QUERYTEMPLATES $SCALE $STREAMNUMBER
}

convertquery() {
    local -r F=$1
    local -r Q=`basename $F .par`
    local -r FTEMP=`crtemp`
    local -r TDIR=$2
    local -r QNAME=query$Q.tpl
    local -r TFILE=$QUERYTEMPLATES/$QNAME
    local -r TOUTPUT=$TDIR/$QNAME

    # read proprties

    [ -f $TFILE ] || logfail "Cannot find $TFILE"
    awk -f proc/removedefine.awk $TFILE >$FTEMP
    [ $? -eq 0 ] || logfail "awk failed"

    while IFS='=' read -r k v; do
       if [ -n "$k" ]; then 
         log "$TFILE replace $k => $v"
         sed "s/\[$k\]/$v/g" $FTEMP >$TOUTPUT
         [ $? -eq 0 ] || logfail "sed failed"
         cp $TOUTPUT $FTEMP
       fi
    done < $F
     
    echo $TDIR 
    echo $QNAME >>$TDIR/templates.lst
}

producequalification() {
    verifyqueries
    local -r TDIR=`mktemp -d`
    mkdir -p $TDIR
    cp $QUERYTEMPLATES/$SQLDIALECT.tpl $TDIR
    [ $? -eq 0 ] || logfail "cp $QUERYTEMPLATES/$SQLDIALECT.tpl $TDIR failed"
    for f in $QUALIFYDIR/*.par; do
      convertquery $f $TDIR
    done
    producequeries $TDIR 1 1
    echo $TDIR
}