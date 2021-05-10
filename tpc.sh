#set -x
#w

STARTPWD=$PWD

IFEXIST=
[ -z "$ENV" ] && { echo "Variable ENV not defined"; exit 1; }
source ./$ENV.rc

declare -g TMPSTORE=`mktemp`

[ -z "$DTYPE" ] && { echo "Variable DTYPE not defined"; exit 1; }
[ -z "$TEMPDIR" ] && { echo "Variable TEMPDIR not defined"; exit 1; }

mkdir -p $TEMPDIR
source proc/commonproc.sh
source db/jdbcproc.sh
source db/${DPROC:-$DTYPE}proc.sh
source proc/queries.sh

# ---------------------

removetables() {
  log "Dropping tables ...."
  local -r tmpfile=`crtemp`
  cat $TCPDS | grep "create\ *table" |
  while read t1 t1 tablename; do
    local droptable="DROP TABLE $IFEXIST $tablename $PURGE ;"
    log "$droptable"
    echo "$droptable" >>$tmpfile
  done
  rundroptable $tmpfile >>$LOGFILE
  # do not return report error code
}

droptables() {
  removetables
  local -r TMP=`crtemp`
  log "Now creating tables ...."

  if [ -n "$REMOVEPRIMARY" ]; then
    sed "s/ time /varchar(20)/g" $TCPDS | sed "s/not null//g" | sed "/primary key/d" | sed -z  "s/,[ ,\n]*);/\n);/g" >$TMP
  else
    cp $TCPDS $TMP
  fi

  runcreatetable $TMP >>$LOGFILE
  [ $? -eq 0 ] || logfail "Cannot create"
}

loadsinglefile() {
  log "Load $1 using $2"
  local -r before=`date  +"%s"`

  if [ -n "$REMOVELASTPIPE" ]; then 
    local -r TMP=`crtemp`
    cat $2 | sed 's/|$//' >$TMP
    loadfile $1 $TMP >>$LOGFILE
  else
    loadfile $1 $2 >>$LOGFILE
  fi
  local -r RES=$?
  local -r after=`date  +"%s"`
  local -r t=$(expr $after - $before)
  log "Time : $t sec"
  [ $RES -eq 124 ] && logfail "Timeout while loading"
  [ $RES -eq 0 ] || logfail "Failed while loading"
}

verifydat() {
  if ! ls $TCPDATA/*.dat >/dev/null 2>&1; then logfail "No flat files in $TCPDATA/*.dat"; fi
}

loaddatatest() {
  verifydat
  loadsinglefile $TESTDATA $TCPDATA/$TESTDATA.dat
}

# --------------

loaddata() {
   verifydat
   log "Data loading ..."
   local -r before=`getsec`
   for f in $TCPDATA/*.dat
   do
     tbl=`basename $f .dat`
     loadsinglefile $tbl $f
   done
   local -r timeelapsed=`calculatesec $before`
   echo $LOADTIMEFILE
   echo "LOAD TIME IN SEC: $timeelapsed" >$LOADTIMEFILE
}

verifyload() {
  local -r table=$1
  local -r file=$2
  existfile $file
  log "Verify table $table against input file $2"
  local -r NOLINES=`numberoflines $file`
  log "Number of rows expected: $NOLINES"
  local -r TMP=`crtemp`
  local -r TMP1=`crtemp`
  # reduce the size of the clolumn, Hive produces extremely large size of the column
  local query="SELECT CAST(CONCAT('NUMBEROFROWS:',COUNT(*)) as CHAR(40)) AS XX FROM $table"
  if [ -n "$USEPIPECONCATENATE" ]; then query="SELECT 'NUMBEROFROWS:' || COUNT(*) AS XX FROM $table"; fi
  # avoid pipe here to catch to error from number of rows
  log "$query"
  numberofrows "$query" $table >$TMP1
  local -r RES=$?
  [ $RES -eq 124 ] && logfail "Timeout while loading"
  [ $RES -eq 0 ] || logfail "Failed while executing a query"
  cat $TMP1 | grep "NUMBEROFROWS:" | tr -d "\| " | cut -d ":" -f2 >$TMP
  NUMOFROWS=`cat $TMP`
  log "Number of rows returned: $NUMOFROWS"
  [ "$NOLINES" -eq "$NUMOFROWS" ] || logfail "Numbers do not match"
  log "OK."
}

testverify() {
  verifyload $TESTDATA $TCPDATA/$TESTDATA.dat
}

verifyallload() {
  verifydat
  log "Data loading ..."
  for f in $TCPDATA/*.dat
  do
    tbl=`basename $f .dat`
    verifyload $tbl $f
    [ $? -eq 0 ] || logfail "Failed while loading"
  done
}

verify() {

  local -r VERQ=$1

  DTYPEID=${DTYPEID:-$DTYPE}
  LOGDIR=${LOGDIR:-$TEMPDIR/${DTYPEID}log}

  mkdir -p $LOGDIR
  LOGFILE=$LOGDIR/mytcpds.log

  touchlogfile

  required_var DBNAME

  TEMPDIR=${TEMPDIR:-/tmp/mytpcds}
  TCPDS=${TCPDS:-$TCPROOT/tools/tpcds.sql}
  TCPDATA=${TCPDATA:-$TCPROOT/work/data}
  STREAMNO=${STREAMNO:-0}
  TCPQ0=${TCPQ0:-$TCPROOT/work/${DTYPE}queries/query_$STREAMNO.sql}
  RESFILE0=${RESFILE0:-$TCPROOT/work/${DTYPE}queries/${DTYPEID}.result$STREAMNO}
  LOADTIMEFILE=${LOADTIMELINE:-$TCPROOT/work/${DTYPE}queries/${DTYPEID}.loadtime}
  TESTQUERY=${TESTQUERY:-55}
  TESTDATA=${TESTDATA:-customer}
  QUERYTIMEOUT=${QUERYTIMEOUT:-10m}
  RESQUERYDIR=${RESQUERYDIR:-$PWD/qualifres}
  DELIM=${DELIM:-|}

  RESULTDIRECTORY=${RESULTDIRECTORY:-$TEMPDIR/${DTYPEID}result${STREAMNO}}
  TMPQ=${TMPQ:-$TEMPDIR/${DTYPEID}queries${STREAMNO}}
  mkdir -p $RESULTDIRECTORY
  mkdir -p $RESQUERYDIR

  required_listofvars "RESQUERYDIR RESULTDIRECTORY TCPDATA RESFILE0"

  existfile $TCPDS
  if [ $VERQ -eq 1 ]; then 
     existfile $TCPQ0
  fi
  [ -d $TCPDATA ] || logfail "$TCPDATA directory does not exist"
  [ -d $RESQUERYDIR ] || logfail "$RESQUERYDIR directory does not exist"

  [ -n "$REQUIREDVARS" ] && required_listofvars "$REQUIREDVARS"
  [ -n "$REQUIREDCOMMANDS" ] && required_listofcommands "$REQUIREDCOMMANDS"
}

testdbconnection() {
  testconnection >>$LOGFILE
  [ $? -eq 0 ] || logfail "Cannot connect to database"
  if [ -n "$DBURL" ]; then
    testjdbcconnection
  fi
}

getqueryname() {
  local TPLNAME=`grep -o  "[^ ]*\.tpl" $1`
  local QUERY=`basename -s.tpl $TPLNAME`
  echo $QUERY
}

preparequery() {
  local -r TEMPD=`mktemp -d`
  mkdir -p $TEMPD
  cd $TEMPD
  csplit --suppress-matched  $TCPQ0 "/-- end query/" "{*}" -f query -s
  # remove 0
  find $TEMPD -size  0 -exec rm {} \;

  # now move files to TMPQ according to template name
  rm -f $TMPQ/*
  mkdir -p $TMPQ

  for f in $TEMPD/query*
  do
   QUERY=`getqueryname $f`
   cp $f $TMPQ/$QUERY
  done
  rm -rf $TEMPD
  cd $STARTPWD
}

compactresult() {
   awk -f $STARTPWD/proc/transf.awk $1
}

resultline() {
  local -r RES=$1
  local -r NAME=$2
  local -r TPLNAME=$3
  local -r t=$4
  local mess=""
  if [ $RES -eq 0 ]; then mess="$NAME $DELIM $TPLNAME $DELIM $t"
  elif [ $RES -eq 124 ]; then mess="$NAME $DELIM $TPLNAME $DELIM TIMEOUT "
  else mess="$NAME $DELIM $TPLNAME $DELIM FAILED "
  fi
  echo $mess
}

modifyquery() {
  local -r qfile=$1
  local -r TMP=$2

  local TMP1=`crtemp`
  local TMP2=`crtemp`
  local TMP3=`crtemp`

  sed "s/c_last_review_date_sk/c_last_review_date/gi" $qfile |
    # remove space between cast and ( (MySQL)
    sed "s/cast ('/cast('/g" |
       sed "s/sum (/sum(/g" >$TMP

  if grep query2.tpl $TMP; then
    sed "s/catalog_sales)/catalog_sales) xxxx/g" $TMP >$TMP1
    cp $TMP1 $TMP
  fi

  if grep query49.tpl $TMP; then
    sed -z "s/)\n[ ]*order/) xxx\n order/g" $TMP >$TMP1
    cp $TMP1 $TMP
  fi

# manually modify for hive
# replace d1.d_date + 5 with date_add(d1.d_date,5)
# should be replaced by something more sophisticated because this replacement is space vulnerable

  if grep query72.tpl $TMP && ([ "$DTYPE" = "hive" ] || [ "$DTYPE" = "sparksql" ]); then    
    sed -z "s/d1.d_date + 5/date_add(d1.d_date,5)/" $TMP >$TMP1
    cp $TMP1 $TMP
  fi
    

  if grep query14.tpl $TMP; then
    sed -z "s/between 1999 AND 1999 + 2)[ ]*\n/between 1999 AND 1999 + 2) xxx\n/g" $TMP >$TMP1
    cp $TMP1 $TMP
  fi

  if grep query77.tpl $TMP; then
    sed -z "s/coalesce(returns,[ ]*0)[ ]*returns/coalesce(returns, 0) returnsxxx/g" $TMP >$TMP1
    cp $TMP1 $TMP
  fi

  if grep query23.tpl $TMP; then
    sed "s/group by c_customer_sk)/group by c_customer_sk) xx1 /g" $TMP |
      sed "s/from best_ss_customer))/from best_ss_customer)) xx2 /g" |
      sed "s/,c_first_name)/,c_first_name) xx2 /g" >$TMP1
    cp $TMP1 $TMP
  fi

#  sed "s/\(cast\ *(.*date)\)\ *+ *\([0-9]*\) *days/date_add(\1,\2)/g" $1 | sed "s/\(cast\ *(.*date)\)\ *- *\([0-9]*\) *days/date_sub(\1,\2)/g" >$TMP

  if [ -n "$REMOVEQUERYDAYS" ]; then
    sed -e "s/\+ *\([0-9]*\)  *days/+ \1/g" $TMP | sed -e "s/\- *\([0-9]*\)  *days/- \1/g" >$TMP1
    cp $TMP1 $TMP
  fi

  if [ -n "$REMOVECOMMENTS" ]; then
    sed "/--/d" $TMP >$TMP1
    cp $TMP1 $TMP
  fi

  if [ -n "$REPLACEPIPES" ]; then
    # replace ', ' with ','  (remove space)
    # replace two ||
    # replace one ||
    sed "s/ ', ' / ',' /g" $TMP |
      sed  "s/\,\(.*\) || \([^ ]*\) || \([^ ]*\) /,concat(\1 , \2 , \3) /g" |
        sed "s/\([^ ]*\) || \([^ ]*\) /concat(\1 , \2) /g" >$TMP1
    cp $TMP1 $TMP
  fi

  if [ -n "$MODIFYALIAS" ]; then
  # replace
  # select  sum(cs_ext_discount_amt)  as "excess discount amount"
  # with
  # select  sum(cs_ext_discount_amt)  as excess_discount_amount

  # as 31-60_days with 31_60_days
  # as >120_days with 120_days

    sed "s/as *\"\(.*\)\"/as ~(\1~)/g ; :lll s/\(~([^ ~)]*\)[ ]/\1_/; tlll ; s/~(//g ; s/~)//g" $TMP |
      sed "s/ as \([^ ]*\)-\([^ ]*\)days/as \1_\2\days/g" | sed 's/ as >\(.*\)days/as \1days/g' >$TMP1
    cat $TMP1
    cp $TMP1 $TMP
  fi

  if [ -n "$REPLACEQUERYDAYSPROC" ]; then
    # tackle also :  and d_date between cast('2002-03-29' as date) and (cast('2002-03-29' as date) +  60 days)
    # replace (cast ('2000-05-19' as date) +- 30 days) with date_add(cast('2018-01-01' as date),30)
    sed "s/and\ *(\(cast\ *(.*date)\)\ *+ *\([0-9]*\) *days/and (date_add(\1,\2)/g" $TMP |
    sed "s/\(cast\ *(.*date)\)\ *+ *\([0-9]*\) *days/date_add(\1,\2)/g" |
      sed "s/\(cast\ *(.*date)\)\ *- *\([0-9]*\) *days/date_sub(\1,\2)/g" >$TMP1
    cp $TMP1 $TMP
  fi

}

runsinglequery() {
  local qfile=$TMPQ/$1
  existfile $qfile
  local -r QUERY=`getqueryname $qfile`
  local -r TPLNAME=$QUERY.tpl
  RESULTSET=$RESULTDIRECTORY/$QUERY.res
  rm -f $RESULTSET

  if [[ "$SKIPQUERY" =~ .*${TPLNAME}.* ]]; then
    mess="$1 | $QUERY | SKIPPED"
    log "$mess"
    echo $mess >>$RESFILE0
    return
  fi
  [ $STREAMNO -eq 0 ] && log "$qfile  started ..."
  [ $STREAMNO -ne 0 ] && log "$STREAMNO $qfile  started ..."

  local TMP=`crtemp`

  modifyquery $qfile $TMP

  # query can contain more queries separated by ;
  local -r CDIR=`mktemp -d`
  csplit $TMP "/;/1"  -f $CDIR/query -s
  # remove empty file
  find $CDIR/query* -size 0c -exec rm {} \;
  find $CDIR/query* -size 1c -exec rm {} \;
  find $CDIR/query* -size 2c -exec rm {} \;

  local -r OUTPUTQUERY=`crtemp`
  local -r before=`getsec`
  for f in $CDIR/query*; do 
    runquery $f >>$LOGFILE
    RES=$?
    cat $RESULTSET >>$OUTPUTQUERY
    echo "---------" >>$OUTPUTQUERY
  done

  rm -rf $CDIR
  # copy back compacted output
  cp $OUTPUTQUERY $RESULTSET

  local -r t=`calculatesec $before`
  local mess=`resultline $RES $1 $TPLNAME $t`
  if [ $RES -eq 0 ] && [ -n "$QUALIFYTEST" ]; then
    local TMP2=`crtemp`
    local TMP3=`crtemp`

    local RESQUERY=$RESQUERYDIR/$QUERY.res
    if [ -n "$NULLLAST" ]; then
       local -r RESNULLLAST=$RESQUERYDIR/${QUERY}_null.res
       if [ -f $RESNULLLAST ]; then RESQUERY=$RESNULLLAST; fi
    fi
      
    log "Compare the result $RESQUERY against $RESULTSET"

    existfile $RESQUERY
    existfile $RESULTSET

    compactresult $RESQUERY >$TMP2
    compactresult $RESULTSET >$TMP3
    if  diff $TMP2 $TMP3 >>$LOGFILE >&2;  then mess="$mess $DELIM MATCH"; else mess="$mess $DELIM DIFFER"; fi
    # compare size
    local EXPECTEDLINE=`numberoflines $TMP2`
    log "Expected number of line $EXPECTEDLINE"
    local RESLINES=`numberoflines $TMP3`
    log "Number of lines received $RESLINES"
    if [ "$EXPECTEDLINE" -eq "$RESLINES" ]; then mess="$mess $DELIM NUMBER OF LINES MATCHES"; else mess="$mess $DELIM NUMBER OF LINES DIFFERS"; fi
  fi

  log "$mess"
  echo $mess >>$RESFILE0
  return $RES
}

testquery() {
  preparequery >>$LOGFILE
  runsinglequery query$TESTQUERY
}

runqueries() {
  preparequery >>$LOGFILE
  rm -f $RESFILE0
  rm -f $RESULTDIRECTORY/*
  local -r before=`date  +"%s"`
  for f in $TMPQ/query*
  do
    query=`basename $f`
    runsinglequery $query
  done
  local -r after=`date  +"%s"`
  local -r t=$(expr $after - $before)
  mess="ALL | $t"
  log "$mess"
  echo "$mess" >>$RESFILE0
}
# ------------------------------

printhelp() {
  log "Usage :"
  log "$0 /param/"
  log "  param : "
  log "    createtables : remove and create tables"
  log "    loaddata : load data"
  log "    verifyload : verify load "
  log "    runqueries : runqueries"
  log "    querystreams : query streams"
  log "    queryqualification : qualification queries"
  log " -- TEST"
  log "    test : test connection"
  log "    loadtest : load a single table as a test"
  log "    testverify : verify single file as a test"
  log "    testquery : run single query as a test"
  log "    removedata : drop all tables"
}

main() {
  case $1 in
    querystreams) producestreams;;
    queryqualification) producequalification;;
    test) testdbconnection;;
    createtables) droptables;;
    loaddata) loaddata;;
    loadtest) loaddatatest;;
    verifyload) verifyallload;;
    testverify) testverify;;
    testquery) testquery;;
    runqueries) runqueries;;
    removedata) removetables;;
    *) printhelp; logfail "Parameter expected";;
  esac
}

test() {
  preparequery
}


# main

VERQ=1
case $1 in
  querystreams|queryqualification) verify 0;;
  *) verify 1;;
esac

export RESULTSET=`crtemp`
trap "removetemp" EXIT

if [ -n "$DBURL" ]; then
   required_listofvars "JAVADRIVER"
fi

VERQ=1
case $1 in
  querystreams|queryqualification) VERQ=0;;
esac


main $1
