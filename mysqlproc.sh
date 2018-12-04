
mysqlcall() {
  local command="$1"
  timeout $QUERYTIMEOUT  mysql -A -h $DBHOST $DBNAME -u $DBUSER -p$DBPASSWORD -e "$command"
}

mysqlscript() {
  local script="$1"
  timeout $QUERYTIMEOUT mysql -A -h $DBHOST $DBNAME -u $DBUSER -p$DBPASSWORD <$script
}

loadfile() {
  local tbl=$1
  local file=$2
  mysqlcall "LOAD DATA LOCAL INFILE '$file' INTO TABLE $tbl FIELDS TERMINATED BY '|'"
}

numberofrows() {
  mysqlcall "$1"
}

runquery() {
  local TMP=`mktemp`
  sed -e "s/\+ *\([0-9]*\)  *days/+ INTERVAL \1 DAY/g" $1 | sed -e "s/\- *\([0-9]*\)  *days/- INTERVAL \1 DAY/g"  >$TMP
  cat $TMP
  mysqlscript $TMP
  local RES=$?
  rm $TMP
  return $RES
}

testconnection() {
  mysqlcall "SHOW TABLES"
}

rundroptable() {
  mysqlscript $1
}

runcreatetable() {
  mysqlscript $1
}

verifyvariable() {
  [ -z "$DBHOST" ] && logfail "Variable DBHOST not defined"
}

verifyvariable

export IFEXIST="IF EXISTS"
