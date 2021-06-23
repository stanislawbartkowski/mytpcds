#set -x
#w

verifyvariable() {
  [ -z "$DBHOST" ] && logfail "Variable DBHOST not defined"
  [ -z "$KILLINTERVAL" ] && logfail "Variable KILLINTERVAL not defined"
}

psqlcommand() {
  local -r command="$1"
  local PORT=""
  [ -n "DBPORT" ] && PORT="-p $DBPORT"
  export PGPASSWORD=$DBPASSWORD; timeout -s 15 $QUERYTIMEOUT psql -h $DBHOST $PORT -U $DBUSER -d $DBNAME -t -v "ON_ERROR_STOP=true" -c "$command"
}

psqlscript() {
  local PORT=""
  [ -n "DBPORT" ] && PORT="-p $DBPORT"

  export PGPASSWORD=$DBPASSWORD; timeout -s 15 $QUERYTIMEOUT psql -h $DBHOST $PORT -U $DBUSER -d $DBNAME -t -v "ON_ERROR_STOP=true" <$1 >$RESULTSET
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
  local -r tbl=$1
  local -r file=$2
  local -r TMP=`crtemp`
  local -r TMPFILE=$LOADBUFFER

  required_var LOADBUFFER

  log "Transforming $file to $TMPFILE removing the last pipe"
  
  sed "s/|$//"g $file >$TMPFILE
  [ $? -eq 0 ] || logfail "Failed transforming load input file"

  log "OK, completed, now loading $TEMPFILE"

cat <<EOF >$TMP
TRUNCATE $tbl;
\copy $tbl FROM '$TMPFILE' ( DELIMITER('|'), NULL(''), ENCODING 'latin1' );
EOF

  psqlscript $TMP
}

testconnection() {
  psqlcommand "\l"
}


runquery() {
  killlong
  cat $1
#  psqlscript $1
  jdbcrunquery $1
}

verifyvariable

export IFEXIST="IF EXISTS"
export REMOVEQUERYDAYS=X
export REQUIREDCOMMANDS="psql"
export NULLLAST=X

