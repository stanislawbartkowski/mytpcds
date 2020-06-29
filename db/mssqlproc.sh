

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
  bcp $tablename in $inloadfile $CONNPARS -c -t \| 
}

export REQUIREDCOMMANDS="sqlcmd bcp"
export REMOVELASTPIPE=X
