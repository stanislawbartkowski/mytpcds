

CONNPARS="-S tcp:$DBHOST,$DBPORT -U $DBUSER -d $DBNAME -P $DBPASSWORD"
SQLCOMMAND="sqlcmd $CONNPARS"


testconnection() {
    $SQLCOMMAND -Q "SELECT 1"
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
