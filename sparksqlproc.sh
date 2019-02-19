sparksqlcommand() {
  export SPARK_MAJOR_VERSION=2
  timeout $QUERYTIMEOUT spark-sql $SPARKSQLPARAM --database $DBNAME -e "$1"
}

sparksqlscript() {
  export SPARK_MAJOR_VERSION=2

 # check queue
  local -r PATT=QUEUE$STREAMNO
  # queue name
  local U=
  local -r YARNQUEUE=${!PATT}
  if [ -n "$YARNQUEUE" ]; then
    U="--queue=$YARNQUEUE"
  fi

  timeout $QUERYTIMEOUT spark-sql $SPARKSQLPARAM $U --database $DBNAME -f "$1"
}

testconnection() {
  sparksqlcommand "show tables"
}

numberofrows() {
  sparksqlcommand "$1"
}

runquery() {
  sparksqlscript $1 >$RESULTSET
}

verifyvariable() {
  [ -z "$SPARKSQLPARAM" ] && logfail "Variable SPARKSQLPARAM not defined"
}

export REPLACEQUERYDAYSPROC=X
export IFEXIST="IF EXISTS"
export MODIFYALIAS=X

