source db/hivesql.proc

runcommand() {
  local command="$2"
  prepareurl $1
  required_command beeline
  timeout --foreground $QUERYTIMEOUT beeline -u "$U" $CREDEN -e "$command"
  [ $? -eq 0 ] || logfail "Cannot execute Hive command"
}

runscript() {
  local scriptfile=$1
  prepareurl 0
  timeout --foreground $QUERYTIMEOUT beeline -u "$U" $CREDEN -f $scriptfile
}

xxx_runquery() {
  prepareurl 1
  timeout --foreground $QUERYTIMEOUT beeline --outputformat=dsv --showHeader=false -u "$U" $CREDEN -f $1 >$RESULTSET
}

verifycommand

export REPLACEPIPES=X
export RUNQUERYDBPARAMS=-removeSemi