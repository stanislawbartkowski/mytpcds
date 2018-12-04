sparksqlcommand() {
  export SPARK_MAJOR_VERSION=2
  timeout $QUERYTIMEOUT spark-sql $SPARKSQLPARAM --database $DBNAME -e "$1"
}

sparksqlscript() {
  export SPARK_MAJOR_VERSION=2
  timeout $QUERYTIMEOUT spark-sql $SPARKSQLPARAM --database $DBNAME -f "$1"
}

testconnection() {
  sparksqlcommand "show tables"
}

numberofrows() {
  sparksqlcommand "$1"
}

runquery() {
  sparksqlscript $1
}

verifyvariable() {
  [ -z "$SPARKSQLPARAM" ] && logfail "Variable SPARKSQLPARAM not defined"
}

export REPLACEQUERYDAYSPROC=X
