source db/hivesql.proc

runcommand() {
  export SPARK_MAJOR_VERSION=2
  local -r command="$2"
  prepareurl $1

  timeout $QUERYTIMEOUT spark-sql $U -e "$command"
}

i_runscript() {
  export SPARK_MAJOR_VERSION=2
  local -r scriptfile=$2
  prepareurl $1

  # queue name
  local -r Q="--queue=$TEZQUEUE"

  timeout $QUERYTIMEOUT spark-sql $U $Q -f $scriptfile
}


runscript() {
  i_runscript 0 $1
}

runquery() {
  i_runscript 1 $1 >$RESULTSET
}

export REPLACEQUERYDAYSPROC=X
export IFEXIST="IF EXISTS"
export MODIFYALIAS=X

verifycommand
