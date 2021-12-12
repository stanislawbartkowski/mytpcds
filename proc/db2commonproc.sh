# -----------------------------------
# my db2 command shell functions
# version 1.00
# 2021/11/11
# 2021/12/02 - added set -x w at the beginning
# 2021/12/12 - change in loadserver
# -----------------------------------

#set -x
#w

db2clirun() {
    required_var DBPASSWORD

    local -r CONNECTION="DATABASE=$DBNAME;HOSTNAME=$DBHOST;PORT=$DBPORT;UID=$DBUSER;PWD=$DBPASSWORD"
    local -r sqlinput=$1
    local -r ITEMP=`crtemp`
    local -r OTEMP=`crtemp`
    [ -n "$SCHEMA" ] && echo "SET CURRENT SCHEMA $SCHEMA ;" >$ITEMP
    cat $1 >>$ITEMP
    $QUERYTIMEOUT db2cli execsql -statementdelimiter ";" -connstring "$CONNECTION" -inputsql $ITEMP -outfile $OTEMP
    local RES=0
    if grep "ErrorMsg" $OTEMP; then
      logfile $OTEMP
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
#  local -r SFILE=`serverfile $INLOADFILE`

cat << EOF > $TMPS
    CALL SYSPROC.ADMIN_CMD('load from $INLOADFILE  of del modified by coldel$COLDEL replace into $TABLENAME NONRECOVERABLE');
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
  CALL SYSPROC.ADMIN_CMD('LOAD FROM S3::$ENDPOINT::$AWSKEY::$AWSSECRETKEY::$BUCKET::$S3FILE OF DEL modified by coldel$COLDEL REPLACE INTO $TABLENAME NONRECOVERABLE');
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

   [[ -z $SCHEMA ]] && return 0

   log "Set schema $SCHEMA after connection"
   [[ -n $SCHEMA ]] && db2 "set current schema $SCHEMA"
   [ $? -ne 0 ] && logfail "Cannot set schema $SCHEMA"
}

db2terminate() {
  db2 terminate
}

db2runscript() {
  local -r f=$1
  db2 -x -tsf $f
  [ $? -ne 0 ] && logfail "Failed running $f"
}

db2exportcommand() {
  required_var DELIM
  local -r output=$1
  shift
  echo $@
  db2 EXPORT TO $output OF DEL MODIFIED BY NOCHARDEL COLDEL$DELIM $@
  [ $? -ne 0 ] && logfail "Failed while export the statement"
}

db2loadblobs() {
  local -r IMPFILE=$1
  local -r IMPBLOBDIR=$2
  local -r IMPTABLE=$3
  log "Load $IMPTABLE table from server $IMPFILE using blobs in $IMPBLOBDIR"
  db2 "LOAD FROM $IMPFILE OF DEL LOBS FROM $IMPBLOBDIR MODIFIED BY COLDEL$COLDEL REPLACE INTO $IMPTABLE"
  [ $? -ne 0 ] && logfail "Load failed"