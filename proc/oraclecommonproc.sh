# -----------------------------------
# my oracle command shell functions
# version 1.00
# 2021/12/01
# 2022/01/01 - QUERYTIMEOUT
# -----------------------------------

#set -x
#w

oraclecheckvar() {
    required_listofcommands sqlplus sqlldr
    required_listofvars URL
}

oraclescript() {
  local -r TMP=`crtemp`
  local -r IGNOREEXIT=$2
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
  echo EXIT | $QUERYTIMEOUT sqlplus -S "$URL" \@$TMP
  local -r RES=$?
  [ -z "$IGNOREEXIT" ] && [ $RES -ne 0 ] && logfail "Oracle command failed"
  return 0
}

oraclecommand() {
  local TMP=`crtemp`
  echo "$1 ;" >$TMP
  oraclescript $TMP
}

oracletestconnection() {
   oraclecheckvar
   oraclecommand "SELECT * FROM USER_TABLES"
}

oracleloadfile() {
  required_listofcommands sqlldr
  local -r tbl=$1
  local -r file=$2
  local -r TMP=`crtemp`
  cat >$TMP <<EOF
  load data INFILE '$file'
  INTO TABLE $tbl
  TRUNCATE
  FIELDS TERMINATED BY "$COLDEL"
  TRAILING NULLCOLS
EOF
  local -r LOGDIR=$(dirname "$LOGFILE")
  local -r RESTMP=`crtemp`
  cha="("
  oraclecommand "select column_name,data_type from user_tab_columns where table_name = UPPER('$tbl') order by COLUMN_ID" >$RESTMP
  # oraclecommand outputs the result to $RESTMP file
  IFS='|' ; cat $RESTMP | while read -r cname ctype
  do
    echo $cha >>$TMP
    local CNAME=`trim $cname`
    echo -n $CNAME >>$TMP
    echo $ctype
    [ $ctype == 'DATE' ] && echo " date 'YYYY-MM-DD' " >>$TMP
    [ $ctype == 'VARCHAR2' ] && echo " CHAR(4000) " >>$TMP
    [ $ctype == 'XMLTYPE' ] && echo " CHAR(4000) " >>$TMP
    cha=","
  done
  echo -n ")" >>$TMP
  logfile $TMP
  log
  log "log=$LOGDIR/oracleload.log"
  sqlldr "$URL" control=$TMP log=$LOGDIR/oracleload.log  
}