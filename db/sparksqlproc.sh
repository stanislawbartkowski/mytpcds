source db/hivesql.proc

runcommand() {
  export SPARK_MAJOR_VERSION=2
  local command="$2"
  prepareurl $1

  timeout $QUERYTIMEOUT spark-sql $U -e "$command"
}

runscript() {
  export SPARK_MAJOR_VERSION=2
  local scriptfile=$1
  prepareurl 0

  # queue name
  local -r Q="--queue=$TEZQUEUE"

  timeout $QUERYTIMEOUT spark-sql $U $Q -f "$1"
}

runquery() {
  runscript $1 >$RESULTSET
}

export REPLACEQUERYDAYSPROC=X
export IFEXIST="IF EXISTS"
export MODIFYALIAS=X

verifycommand
