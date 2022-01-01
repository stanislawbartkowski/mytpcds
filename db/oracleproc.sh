source proc/oraclecommonproc.sh

runquery() {
  local -r TMP=`crtemp`
  sed -e "s/EXCEPT/minus/gi" $1 >$TMP
  cat $TMP
  jdbcrunquery $TMP
}

rundroptable() {
  local -r TMP=`crtemp`
  cp $1 $TMP
  oraclescript $TMP IGNORE
}

runcreatetable() {
  local -r TMP=`crtemp`
  sed "s/ time /varchar(20)/g" $1  >$TMP
  oraclescript $TMP
}


testconnection() {
   oracletestconnection
}

loadfile() {
  oracleloadfile $@  >>$LOGFILE
}

export REMOVEQUERYDAYS=X
export REQUIREDCOMMANDS="sqlplus sqlldr"
export NULLLAST=X
export RUNQUERYDBPARAMS=-removeSemi

