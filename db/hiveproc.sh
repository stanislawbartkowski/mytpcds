source db/hivesql.proc

runcommand() {
  local command="$2"
  prepareurl $1
  beeline -u "$U" -n $DBUSER $E "$DBE" -e "$command"
  [ $? -eq 0 ] || logfail "Cannot execute Hive command"
}

runscript() {
  local scriptfile=$1
  prepareurl 0
  timeout --foreground $QUERYTIMEOUT beeline -u "$U" -n $DBUSER -f $scriptfile
}

runquery() {
  prepareurl 1
  cat $1
  timeout --foreground $QUERYTIMEOUT beeline --outputformat=dsv --showHeader=false -u "$U" -n $DBUSER -f $1 >$RESULTSET
}

verifycommand
