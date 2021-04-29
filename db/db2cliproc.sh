
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

serverfile() {
    local -r tbl=`basename $1`
    echo "$PREFIXSERVER/$tbl"
}

loadfiles3() {
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

loadfileclient() {
  local -r TABLENAME=$1
  local -r INLOADFILE=$2
  local -r TMPS=`crtemp`
  local -r SFILE=`serverfile $INLOADFILE`


cat << EOF > $TMPS
    CALL SYSPROC.ADMIN_CMD('load from $SFILE  of del modified by coldel| replace into $TABLENAME');
EOF

  db2clirun $TMPS
#  jdbcqueryupdatefile $TMPS
}


loadfile() {
  [ -z "$LOADS3" ] && loadfileclient $@
  [ -n "$LOADS3" ] && loadfiles3 $@
}



# CALL SYSPROC.ADMIN_CMD('LOAD FROM S3::$ENDPOINT::X$AWSKEY::$AWSSECRETKEY::$BUCKET::$INPATH OF DEL INSERT INTO $TABLEDEST');


testconnection() {
    local -r TMP=`crtemp`
    echo "select count(*) from syscat.tables;" >$TMP
    db2clirun $TMP
}

rundroptable() {
  db2clirun $1
}

runcreatetable() {
  db2clirun $1
}
