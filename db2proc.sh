connect() {
   if [ -n "$DBUSER" ]; then
    db2 connect to $DBNAME user $DBUSER using $DBPASSWORD
  else
    db2 connect to $DBNAME
  fi
  echo "-------------"
  if [ -n "$SCHEMA" ]; then
    db2 "set current schema=$SCHEMA"
  fi
}

disconnect() {
  db2 terminate
}

testconnection() {
  connect
  [ $? -eq 0 ] || logfail "Cannot connect to DB2"
  disconnect
}

old_runscript() {
  local scriptfile=$1
  connect
  #timeout $QUERYTIMEOUT  (cannot use timeout for DB2)
  # do not display header and query
  db2 -xv -tsvf $scriptfile >$RESULTSET
  local RES=$?
  disconnect
  return $RES
}

runscript() {
  local scriptfile=$1
  local TMP=`mktemp`
  local CONN=""
  if [ -n "$DBUSER" ]; then
    CONN=" -a $DBUSER/$DBPASSWORD"
  fi
  db2batch -d $DBNAME $CONN -f $scriptfile -t "|" -r $RESULTSET,$TMP -q on
  local RES=$?
  rm $TMP
  return $RES
}


rundroptable() {
  runscript $1
}

runcreatetable() {
  runscript $1
}

runquery() {
  runscript $1
  local RES=$?
  [ $RES -eq 1 ] && return 0
  return $RES
}

numberofrows() {
  connect
  db2 -x "$1"
  local RES=$?
  disconnect
  return $RES
}

loadfile() {
  local tablename=$1
  local inloadfile=$2
  connect
  db2 "set integrity for $tablename off "
  db2 "load $CLIENT from $inloadfile of del modified by coldel| replace into $tablename"
  local RES=$?
  db2 "set integrity for $tablename IMMEDIATE CHECKED FORCE GENERATED"
  disconnect
  return $RES
}
