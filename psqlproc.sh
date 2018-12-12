verifyvariable() {
  [ -z "$DBHOST" ] && logfail "Variable DBHOST not defined"
  [ -z "$KILLINTERVAL" ] && logfail "Variable KILLINTERVAL not defined"
}

psqlcommand() {
  local command="$1"
  export PGPASSWORD=$DBPASSWORD; timeout -s 15 $QUERYTIMEOUT psql -h $DBHOST -U $DBUSER -d $DBNAME -t -v "ON_ERROR_STOP=true" -c "$command"
}

psqlscript() {
  export PGPASSWORD=$DBPASSWORD; timeout -s 15 $QUERYTIMEOUT psql -h $DBHOST -U $DBUSER -d $DBNAME -t -v "ON_ERROR_STOP=true" <$1 >$RESULTSET
}

rundroptable() {
  psqlscript $1
}

runcreatetable() {
  psqlscript $1
}

killlong() {
   local stmt="SELECT pid FROM pg_stat_activity WHERE datname='$DBNAME' and usename='$DBUSER' and state='active' and (now() - pg_stat_activity.query_start) > interval '$KILLINTERVAL'"
   psqlcommand "$stmt" | while read PID
   do
     [ -n "$PID" ] && log "Killing = $PID"
     [ -n "$PID" ] && psqlcommand "SELECT pg_cancel_backend($PID)"
   done
}

loadfile() {
  local tbl=$1
  local file=$2
  local TMP=`mktemp`
  sed -e "s/|$//g" $file | sed -e "s/\xd4/X/g"  | sed -e "s/\x54/X/g" | sed -e "s/\xc9/X/g" | sed -e "s/\x55/X/g" >$TMP
  echo "\copy $tbl FROM '$file' ( DELIMITER('|') )"
  echo "$TMP"
  psqlcommand "TRUNCATE $tbl"
  psqlcommand "\copy $tbl FROM '$TMP' ( DELIMITER('|'), NULL('') )"
  local RES=$?
  rm $TMP
  return $RES
}

numberofrows() {
  psqlcommand "$1"
}

toremove_numberofrows() {
  local table=$1
  local TMP=$2
  psqlcommand "SELECT CONCAT('NUMBEROFROWS:',COUNT(*)) AS XX FROM $table" | grep "NUMBEROFROWS:" | tr -d "\| " | cut -d ":" -f2 >$TMP
}

runquery() {
  killlong
  cat $1
  psqlscript $1
}

testconnection() {
  psqlcommand "\dt"
}

verifyvariable

export IFEXIST="IF EXISTS"
export REMOVEQUERYDAYS=X
