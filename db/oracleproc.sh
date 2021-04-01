

oraclescript() {
  local -r TMP=`mktemp`
  cat >$TMP <<EOF
  WHENEVER OSERROR EXIT FAILURE;
  WHENEVER SQLERROR EXIT SQL.SQLCODE;
  SET LINESIZE 32000;
  SET PAGESIZE 40000;
  SET ECHO OFF NEWP 0 SPA 0 PAGES 0 FEED OFF HEAD ON TRIMS ON WRAP OFF TAB OFF COLSEP |;
  SET NUMFORMAT "99999999.99";
  alter session set NLS_DATE_FORMAT = 'yyyy-mm-dd';
EOF
  cat $1 >>$TMP
  echo EXIT | timeout $QUERYTIMEOUT sqlplus -S "$URL" \@$TMP >$RESULTSET
  local RES=$?
  rm $TMP
  # remove parameter file, the calling function must not remove it
  rm $1
  return $RES
}

oraclecommand() {
  local TMP=`crtemp`
  echo "$1 ;" >$TMP
  oraclescript $TMP
}

runquery() {
  local -r TMP=`mktemp`
  sed -e "s/EXCEPT/minus/gi" $1 >$TMP
  cat $TMP
#  oraclescript $TMP
  jdbcrunquery $TMP
}

rundroptable() {
  # oraclescript removes the file passed as a parameter
  local -r TMP=`crtemp`
  cp $1 $TMP
  oraclescript $TMP
}

runcreatetable() {
  local -r TMP=`crtemp`
  sed "s/ time /varchar(20)/g" $1  >$TMP
  oraclescript $TMP
}

loadfile() {
  local -r tbl=$1
  local -r file=$2
  local -r TMP=`mktemp`
  cat >$TMP <<EOF
  load data INFILE '$file'
  INTO TABLE $tbl
  TRUNCATE
  FIELDS TERMINATED BY "|"
  TRAILING NULLCOLS
EOF
  cha="("
  oraclecommand "select column_name,data_type from user_tab_columns where table_name = UPPER('$tbl') order by COLUMN_ID"
  # oraclecommand outputs the result to $RESULTSET file
  IFS='|' ; cat $RESULTSET | while read -r cname ctype
  do
    echo $cha >>$TMP
    echo -n $cname >>$TMP
    [ $ctype == 'DATE' ] && echo -n " date 'YYYY-MM-DD' " >>$TMP
    cha=","
  done
  echo ")" >>$TMP
  cat $TMP
  log "log=$LOGDIR/oracleload.log"
  sqlldr "$URL" control=$TMP log=$LOGDIR/oracleload.log
  local -r RES=$?
  rm $TMP
  return $RES
}

testconnection() {
   oraclecommand "SELECT * FROM USER_TABLES"
}

check_variables() {
  [ -z "$URL" ] && logfail "Variable URL not defined"
}

check_variables

export REMOVEQUERYDAYS=X
export REQUIREDCOMMANDS="sqlplus sqlldr"

