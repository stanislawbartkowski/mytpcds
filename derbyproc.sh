runscript() {
  local TMP=`crtemp`
  export DERBY_OPTS="-Dij.showNoCountForSelect=true -Dij.showNoConnectionsAtStart=true -Dij.connection.mynetconnection=jdbc:derby://$DBHOST:$DBPORT/$DBNAME\;create=true"
  # number of lines in the query
  local NOLINES=`numberoflines $1`
  log "xxxxxxxxxxxxx=$NOLINES"
#  $IJ $1 >$RESULTSET
  $IJ $1 >$TMP
  # remove first NOLINES from the input, the query is repeated and version information is included
  tail -n +$((NOLINES+2)) $TMP >$RESULTSET

  echo "==================" >>$LOGFILE
  cat $RESULTSET >>$LOGFILE
  echo "==================" >>$LOGFILE
  [ $? -eq 0 ] || logfail "Cannot run JVM for Derby client"
  if grep "ERROR.*:" $RESULTSET; then
    cat $RESULTSET >>$LOGFILE
    return 1;
  fi
}

runcommand() {
  local -r TMP=`crtemp`
  echo "$1" >$TMP
  runscript $TMP
}

verifyderby() {
  [ -z "$IJ" ] && logfail "Variable IJ not defined"
  [ -z "$DBHOST" ] && logfail "Variable DBHOST defined"
  [ -z "$REMOTEUSER" ] && logfail "Variable REMOTEUSER defined"
  DBPPORT=${DBPORT:-1527}
}

rundroptable() {
  runscript $1
}

 runcreatetable() {
   runscript $1
 }

 copyfiletoserver() {
   local -r S=$1
   local -r D=$2
   scp $S $REMOTEUSER@$DBHOST:$D
   [ $? -eq 0 ] || logfail "Cannot copy $S to remote server $DBHOST"
 }

 loadfile() {
   local -r tablename=$1
   local -r inloadfile=$2
   local -r TMP=`crtemp`
   local -r bname=`basename $inloadfile`
   local -r DEST="$bname"
   runcommand "TRUNCATE TABLE $tablename;"
   copyfiletoserver $inloadfile $DEST
   runcommand "CALL SYSCS_UTIL.SYSCS_IMPORT_TABLE(null,UPPER('$tablename'),'$DEST','|',null,null,0);"

#   echo "CALL SYSCS_UTIL.SYSCS_IMPORT_TABLE(null,UPPER('$tablename'),'$DEST','|',null,null,0);" >$TMP
#   runscript $TMP
 }

testconnection() {
  runcommand "SHOW TABLES;"
}

numberofrows() {
  local -r table=$2
  local -r query="SELECT 'NUMBEROFROWS:' || CAST(COUNT(*) AS CHAR(20)) AS XX FROM $table ;"
  runcommand "$query"
  [ $? -eq 0 ] || return 1
  cat $RESULTSET
}

runquery() {
  cat $1
  runcommand "$1"
}

verifyderby

export USEPIPECONCATENATE=X
export REMOVECOMMENTS=X
