# -----------------------------
# db2 
# -----------------------------

db2clirun() {
    required_var DBPASSWORD

    local -r CONNECTION="DATABASE=$DBNAME;HOSTNAME=$DBHOST;PORT=$DBPORT;UID=$DBUSER;PWD=$DBPASSWORD"
    local -r sqlinput=$1
    local -r ITEMP=`crtemp`
    local -r OTEMP=`crtemp`
    [ -n "$SCHEMA" ] && echo "SET CURRENT SCHEMA $SCHEMA ;" >$ITEMP
    cat $1 >>$ITEMP
    db2cli execsql -statementdelimiter ";" -connstring "$CONNECTION" -inputsql $ITEMP -outfile $OTEMP
    local RES=0
    if grep "ErrorMsg" $OTEMP; then
      log "Error found while executing the query, check logs"
      RES=8
    fi
    cat $OTEMP
    return $RES
}


db2connect() {
   required_command db2
   required_var DBNAME DBUSER DBPASSWORD
   log "Connecting to $DBNAME user $DBUSER"
   db2 connect to $DBNAME user $DBUSER using $DBPASSWORD
   [ $? -ne 0 ] && logfail "Cannot connect to $DBNAME"
   log "Set schema $SCHEMA after connection"
   [[ -n $SCHEMA ]] && db2 "set current schema $SCHEMA"
   [ $? -ne 0 ] && logfail "Cannot set schema $SCHEMA"
}

db2terminate() {
  db2 terminate
}

db2exportcommand() {
  required_var DELIM
  local -r output=$1
  shift
  echo $@
  db2 EXPORT TO $output OF DEL MODIFIED BY NOCHARDEL COLDEL$DELIM $@
  [ $? -ne 0 ] && logfail "Failed while export the statement"
}


