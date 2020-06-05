
runnzsql() {
  local -r tfile=$1
  timeout $QUERYTIMEOUT nzsql -r -t -h $DBHOST -U $DBUSER -W $DBPASSWORD -d $DBNAME -f $tfile
}

nzsqlcommand() {
  local -r TMPP=`mktemp`
  echo "$1" >$TMPP
  runnzsql $TMPP
  local -r RES=$?
  rm $TMPP
  return $RES
}

testconnection() {
  nzsqlcommand "\dt"
}

rundroptable() {
  runnzsql $1
}

runcreatetable() {
  runnzsql $1
}

loadfile() {
  local tbl=$1
  local file=$2

  nzsqlcommand "TRUNCATE $tbl"
  nzload -host $DBHOST -u $DBUSER -pw $DBPASSWORD -db $DBNAME -df $file -t $tbl -delim "|" -outputDir $LOGLOADDIR
}

#runquery() {
#  cat $1
#  runnzsql $1 >$RESULTSET
#}


testenv() {
  [ -z "$LOGLOADDIR" ] && logfail "LOGLOADDIR variable not defined"
  mkdir -p $LOGLOADDIR
}

export USEPIPECONCATENATE="X"
export REMOVEQUERYDAYS=X
export REQUIREDCOMMANDS="nzsql nzload"
export PURGE=" IF EXISTS"
export SKIPQUERY="query10.tpl query35.tpl"

testenv
