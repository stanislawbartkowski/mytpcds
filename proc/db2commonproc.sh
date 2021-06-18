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

##################################################
# DB2 load delimited file from server location
# important: text file delimited by |
# Arguments:
#   $1 - table to load
#   $2 - server location of delimited file
#######################################

db2loadfileserver() {
  local -r TABLENAME=$1
  local -r INLOADFILE=$2
  local -r TMPS=`crtemp`
  local -r SFILE=`serverfile $INLOADFILE`

cat << EOF > $TMPS
    CALL SYSPROC.ADMIN_CMD('load from $SFILE  of del modified by coldel| replace into $TABLENAME');
EOF

  db2clirun $TMPS
}


serverfile() {
    local -r tbl=`basename $1`
    echo "$PREFIXSERVER/$tbl"
}


##################################################
# DB2 load delimited file from S3 bucker
# important: text file delimited by |
#
# GLOBALS:
#    PREFIXSERVER: root directory in S3 bucket, prefix to $2
#    ENDPOINT: S3 endpoint
#    AWSKEY: AWS key
#    AWSSECRETKEY: AWS secret key
#    BUCKET: AWS secret
# Arguments:
#   $1 - table to load
#   $2 - location in S3 bucket of file to load
#####################################################

db2loadfiles3() {
  local -r TABLENAME=$1
  local -r INLOADFILE=$2
  local -r TMPS=`crtemp`

  required_listofvars PREFIXSERVER ENDPOINT AWSKEY AWSSECRETKEY BUCKET

  local -r S3FILE=`serverfile $INLOADFILE`

  log "Loading from $S3FILE S3/AWS file"

cat << EOF > $TMPS

  CALL SYSPROC.ADMIN_CMD('LOAD FROM S3::$ENDPOINT::$AWSKEY::$AWSSECRETKEY::$BUCKET::$S3FILE OF DEL modified by coldel| REPLACE INTO $TABLENAME NONRECOVERABLE');
EOF

  db2clirun $TMPS
#  jdbcqueryupdatefile $TMPS
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


