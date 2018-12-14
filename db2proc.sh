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

prepare_runscript() {
  local -r f=$1
  if [ -n "$DBUSER" ]; then
   echo "db2 connect to $DBNAME user $DBUSER using $DBPASSWORD"
 else
   echo "db2 connect to $DBNAME"
 fi
 if [ -n "$SCHEMA" ]; then
   echo "db2 set current schema=$SCHEMA"
 fi
 echo "db2 -x -tsf $f" '>$1'
 echo 'RES=$?'
 echo "db2 terminate"
 echo 'exit $RES'
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

xxx_runscript() {
  local -r TMP=`mktemp`
  # prepare external script to run as timeout
  prepare_runscript $1 >$TMP
  cat $TMP
  chmod 700 $TMP
  timeout $QUERYTIMEOUT $TMP $RESULTSET
  local -r RES=$?
  rm $TMP
  return $RES
}

runscript() {
  local scriptfile=$1
  local TMP=`mktemp`
  local SHTMP=`mktemp`
  local CONN=""
  if [ -n "$DBUSER" ]; then
    CONN=" -a $DBUSER/$DBPASSWORD"
  fi
  if [ -n "$SCHEMA" ]; then
    echo "set current schema=$SCHEMA; " >$SHTMP
  fi
  cat $scriptfile >>$SHTMP
  timeout $QUERYTIMEOUT db2batch -d $DBNAME $CONN -f $SHTMP -t "|" -r $RESULTSET,/dev/null -q on  2>$TMP
  local RES=$?
  cat $TMP
  if [ $RES -eq 0 ]; then
    if grep "CLI error" $TMP ; then RES=4; fi
  fi
  rm $TMP
  rm $SHTMP
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
#  trap "echo 'aaaaaaaaaaa'" RETURN
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
