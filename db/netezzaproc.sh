

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
  local -r TMP=`mktemp`
  sed "s/;/ IF EXISTS;/g" $1 >$TMP
  runnzsql $TMP
  local -r RES=$?
  rm $TMP
  return $RES
}

runcreatetable() {
  runnzsql $TMP
}

loadfile() {
  local tbl=$1
  local file=$2

  nzsqlcommand "TRUNCATE $tbl"
  nzload -host $DBHOST -u $DBUSER -pw $DBPASSWORD -db $DBNAME -df $file -t $tbl -delim "|" -outputDir $LOGLOADDIR
}

runquery() {
  cat $1
  runnzsql $1 >$RESULTSET
}


numberofrows() {
  nzsqlcommand "$1"
}


testenv() {
  if ! [ -x "$(command -v nzsql)" ]; then logfail "nzsql is not available"; fi
  if ! [ -x "$(command -v nzload)" ]; then logfail "nzload is not available"; fi
  [ -z "$LOGLOADDIR" ] && logfail "LOGLOADDIR variable not defined"
  mkdir -p $LOGLOADDIR
}

export USEPIPECONCATENATE="X"
export REMOVEQUERYDAYS=X

testenv
