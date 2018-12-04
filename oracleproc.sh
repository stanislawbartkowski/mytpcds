

oraclescript() {
  local TMP=`mktemp`
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
  return $RES
}

oraclecommand() {
  local TMP=`mktemp`
  echo "$1 ;" >$TMP
  oraclescript $TMP
  local RES=$?
  rm $TMP
  return $RES
}

runquery() {
  local TMP=`mktemp`
  sed -e "s/EXCEPT/minus/gi" $1 >$TMP
  cat $TMP
  oraclescript $TMP
  local RES=$?
  rm $TMP
  return $RES
}

rundroptable() {
  oraclescript $1
}

runcreatetable() {
  local TMP=`mktemp`
  sed "s/ time /varchar(20)/g" $1  >$TMP
  oraclescript $TMP
  local RES=$?
  rm $TMP
  return $RES
}

loadfile() {
  local tbl=$1
  local file=$2
  local TMP=`mktemp`
  cat >$TMP <<EOF
  load data INFILE '$file'
  INTO TABLE $tbl
  TRUNCATE
  FIELDS TERMINATED BY "|"
EOF
  cha="("
  oraclecommand "select column_name,data_type from user_tab_columns where table_name = UPPER('$tbl') order by COLUMN_ID" | while read -r cname ctype
  do
    echo $cha >>$TMP
    echo -n $cname >>$TMP
    [ $ctype == "DATE" ] && echo -n " date 'YYYY-MM-DD' " >>$TMP
    cha=","
  done
  echo ")" >>$TMP
  sqlldr "$URL" control=$TMP
  local RES=$?
  rm $TMP
  return $RES
}

numberofrows() {
  oraclecommand "$1"
}

testconnection() {
   oraclecommand "SELECT * FROM USER_TABLES"
}

check_variables() {
  [ -z "$URL" ] && logfail "Variable URL not defined"
}

check_variables

export REMOVEQUERYDAYS=X
