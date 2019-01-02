#set -x
#w

STARTPWD=$PWD

IFEXIST=
[ -z "$ENV" ] && { echo "Variable ENV not defined"; exit 1; }
source ./$ENV.rc

declare -g TMPSTORE=`mktemp`

log() {
  echo $1 >>$LOGFILE
  echo "$1"
}

logfail() {
  log "$1"
  log "Exit immediately"
  exit 1
}

crtemp() {
#  typeset -ga TMPSTORE
  local -r TMP=`mktemp`
  echo $TMP >>$TMPSTORE
  echo $TMP
}

removetemp() {
  while read rmfile;  do rm $rmfile; done <$TMPSTORE
  rm $TMPSTORE
}

[ -z "$DTYPE" ] && { echo "Variable DTYPE not defined"; exit 1; }
[ -z "$TEMPDIR" ] && { echo "Variable TEMPDIR not defined"; exit 1; }
mkdir -p $TEMPDIR
source ./${DTYPE}proc.sh

# ---------------------

removetables() {
  log "Dropping tables ...."
  local -r tmpfile=`crtemp`
  cat $TCPDS | grep "create\ *table" |
  while read t1 t1 tablename; do
    log "DROP TABLE $IFEXIST $tablename"
    echo "DROP TABLE $IFEXIST $tablename ;" >>$tmpfile
  done
  rundroptable $tmpfile >>$LOGFILE
  # do not return report error code
}

droptables() {
  removetables
  local TMP=`crtemp`
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

   loadfile $1 $2 >>$LOGFILE
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

loaddata() {
   verifydat
   log "Data loading ..."
   for f in $TCPDATA/*.dat
   do
     tbl=`basename $f .dat`
     loadsinglefile $tbl $f
   done
}

numberoflines() {
  wc --line $1 | cut -d ' ' -f 1
}

verifyload() {
  local -r table=$1
  local -r file=$2
  [ -f $file ] || logfail "File $file does not exist"
  log "Verify table $table against input file $2"
  local -r NOLINES=`numberoflines $file`
  log "Number of rows expected: $NOLINES"
  local -r TMP=`crtemp`
  local -r TMP1=`crtemp`
  local query="SELECT CONCAT('NUMBEROFROWS:',COUNT(*)) AS XX FROM $table"
  if [ -n "$USEPIPECONCATENATE" ]; then query="SELECT 'NUMBEROFROWS:' || COUNT(*) AS XX FROM $table"; fi
  # avoid pipe here to catch to error from number of rows
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

  DTYPEID=${DTYPEID:-$DTYPE}
  LOGDIR=${LOGDIR:-$TEMPDIR/${DTYPEID}log}

  mkdir -p $LOGDIR
  LOGFILE=$LOGDIR/mytcpds.log

  [ -z "$DBNAME" ] && logfail "Variable DBNAME not defined"

  # "${VAR1:-default value}"
  TEMPDIR=${TEMPDIR:-/tmp/mytpcds}
  TCPDS=${TCPDS:-$TCPROOT/tools/tpcds.sql}
  TCPDATA=${TCPDATA:-$TCPROOT/work/data}
  STREAMNO=${STREAMNO:-0}
  TCPQ0=${TCPQ0:-$TCPROOT/work/${DTYPE}queries/query_$STREAMNO.sql}
  RESFILE0=${RESFILE0:-$TCPROOT/work/${DTYPE}queries/${DTYPEID}.result$STREAMNO}
  TESTQUERY=${TESTQUERY:-55}
  TESTDATA=${TESTDATA:-customer}
  QUERYTIMEOUT=${QUERYTIMEOUT:-10m}
  RESQUERYDIR=${RESQUERYDIR:-$PWD/res}

  RESULTDIRECTORY=${RESULTDIRECTORY:-$TEMPDIR/${DTYPEID}result${STREAMNO}}
  TMPQ=${TMPQ:-$TEMPDIR/${DTYPEID}queries}
  mkdir -p $RESULTDIRECTORY

  [ -z "$RESQUERYDIR" ] && logfail "Variable RESQUERYDIR not defined"
  [ -z "$RESULTDIRECTORY" ] && logfail "Variable RESULTDIRECTORY not defined"
  [ -z "$TCPDATA" ] && logfail "Variable TCPDATA not defined"
  [ -z "$RESFILE0" ] && logfail "Variable RESFILE0 not defined"
  [ -f $TCPDS ] || logfail "$TCPDS does not exist"
  [ -f $TCPQ0 ] || logfail "$TCPQ0 does not exist"
  [ -d $TCPDATA ] || logfail "$TCPDATA directory does not exist"
  [ -d $RESQUERYDIR ] || logfail "$RESQUERYDIR directory does not exist"
}

testdbconnection() {
  testconnection >>$LOGFILE
  [ $? -eq 0 ] || logfail "Cannot connect to database"
}


preparequery() {
  mkdir -p $TMPQ
  rm -f $TMPQ/*
  cd $TMPQ
  csplit --suppress-matched  $TCPQ0 "/-- end query/" "{*}" -f query
  # remove 0
  find $TMPQ -size  0 -exec rm {} \;
}

compactresult() {
  # trim the first column
  sed "s/^ [ ]*\([^|]*\)|/\1|/g" $1 |
    # trim right spaces
    sed "s/\([^ ]\) [ ]*|/\1|/g" | sed 's/[ ]*$//g' |
    # trim left
      sed "s/| [ ]*\([^ ]\)/|\1/g" |
    # replace decimal , with .
         sed "s/\([0-9][0-9]*\),\([0-9][0-9]*\)/\1.\2/g"  |
    # remove emmpty lines
          sed '/^\s*$/d' |
          # replace 0.9 with 0.90
#            sed "s/\(\.[0-9]\)$/\10/g" |
#              sed "s/\(\.[0-9]\)|/\10|/g" |
               # remove NULL NaN
               # run twice !
                 sed "s/NULL//g" | sed "s/NaN//g" | sed "s/|-|/||/g" | sed "s/|-|/||/g" | sed "s/^-|/|/g" |
                # replace |9999| with |9999.00|
                # run twice the same, can overlap
#                sed "s/|\([0-9][0-9]*\)|/|\1.00|/g" | sed "s/|\([0-9][0-9]*\)|/|\1.00|/g" |

   awk -f $STARTPWD/transf.awk

}

runsinglequery() {
  local qfile=$TMPQ/$1
  [ -f $qfile ] || logfail "$qfile does not exist"
  local TPLNAME=`grep -o  "[^ ]*\.tpl" $qfile`
  local QUERY=`basename -s.tpl $TPLNAME`
  RESULTSET=$RESULTDIRECTORY/$QUERY.res
  rm -f $RESULTSET

  if [[ "$SKIPQUERY" =~ .*$QUERY.* ]]; then
    mess="$1 | $QUERY | SKIPPED"
    log "$mess"
    echo $mess >>$RESFILE0
    return
  fi

  log "$qfile  started ..."
  [ -f $qfile ] || logfail "Query $qfile does not exist"
  local TMP=`mktemp`
  local TMP1=`mktemp`
  local TMP2=`mktemp`
  local TMP3=`mktemp`

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

  local -r before=`date  +"%s"`
  runquery $TMP >>$LOGFILE
  local -r RES=$?
  local -r after=`date  +"%s"`
  local -r t=$(expr $after - $before)
  if [ $RES -eq 0 ]; then
      if [ -z "$DONOTVERIFY" ]; then
         mess="$1 | $TPLNAME | PASSED | $t"
         local RESQUERY=$RESQUERYDIR/$QUERY.res
         log "Compare the result $RESQUERY against $RESULTSET"
         compactresult $RESQUERY >$TMP2
         compactresult $RESULTSET >$TMP3
         if  diff $TMP2 $TMP3 >>$LOGFILE >&2;  then mess="$mess | MATCH"; else mess="$mess | DIFFER"; fi
         # compare size
         local EXPECTEDLINE=`numberoflines $TMP2`
         log "Expected number of line $EXPECTEDLINE"
         local RESLINES=`numberoflines $TMP3`
         log "Number of lines received $RESLINES"
         if [ "$EXPECTEDLINE" -eq "$RESLINES" ]; then mess="$mess | NUMBER OF LINES MATCHES"; else mess="$mess | NUMBER OF LINES DIFFERS"; fi
      else
        mess="$1 | $TPLNAME | PASSED | $t"
      fi
  elif [ $RES -eq 124 ]; then mess="$1 | $TPLNAME | TIMEOUT | $t"
  else mess="$1 | $TPLNAME | FAILED "
  fi
  rm $TMP
  rm $TMP1
  rm $TMP2
  rm $TMP3
#  echo $TMP2
#  echo $TMP3

# uncomment for debugging
#  cat $RESULTSET >>$LOGFILE
#  echo >>$LOGFILE
#  echo >>$LOGFILE
#  echo >>$LOGFILE
#  compactresult $RESULTSET >>$LOGFILE

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
  log " -- TEST"
  log "    test : test connection"
  log "    loadtest : load a single table as a test"
  log "    testverify : verify single file as a test"
  log "    testquery : run single query as a test"
  log "    removedata : drop all tables"
}


# main

verify
export RESULTSET=`crtemp`
trap "removetemp" EXIT

case $1 in
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
