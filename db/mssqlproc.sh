

CONNPARS="-S tcp:$DBHOST,$DBPORT -U $DBUSER -d $DBNAME -P $DBPASSWORD"
SQLCOMMAND="sqlcmd $CONNPARS"


testconnection() {
    $SQLCOMMAND -Q "SELECT 1"
    [ $? -eq 0 ] || return 1
    log "Now create several MSSQL UDFs"
    runscript db/sqlserver.proc.sql
}

runscript() {
  local scriptfile=$1
  $SQLCOMMAND -i $scriptfile
}

rundroptable() {
  runscript $1
}

runcreatetable() {
  runscript $1
}

loadfile() {
  local tablename=$1
  local inloadfile=$2
  log "Truncate table $tablename"
  $SQLCOMMAND -Q "TRUNCATE TABLE $tablename"
  [ $? -eq 0 ] || logfail "Truncating table failed"

  bcp $tablename in $inloadfile $CONNPARS -c -t \| 
}

export REQUIREDCOMMANDS="sqlcmd bcp"
export REMOVELASTPIPE=X
export REPLACEQUERYDAYSPROC=X
