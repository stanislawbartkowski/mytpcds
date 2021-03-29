
mysqlcall() {
  local -r command="$1"
  timeout $QUERYTIMEOUT  mysql -A -h $DBHOST $DBNAME -u $DBUSER -p$DBPASSWORD -e "$command"
}

mysqlscript() {
  local -r script="$1"
  timeout $QUERYTIMEOUT mysql -t -N -A -h $DBHOST $DBNAME -u $DBUSER -p$DBPASSWORD <$script
}

loadfile() {
  local -r tbl=$1
  local -r file=$2
  # MySQL - truncate table
  mysqlcall "TRUNCATE $tbl"
  [ $? -eq 0 ] || return 1
  mysqlcall "LOAD DATA LOCAL INFILE '$file' INTO TABLE $tbl FIELDS TERMINATED BY '|'"
}

runquery() {
  local -r TMP=`crtemp`
  local -r TMP1=`crtemp`
  sed -e "s/\+ *\([0-9]*\)  *days/+ INTERVAL \1 DAY/g" $1 | sed -e "s/\- *\([0-9]*\)  *days/- INTERVAL \1 DAY/g"  >$TMP
  cat $TMP
  #mysqlscript $TMP >$TMP1
  jdbcrunquery $TMP
#  local -r RES=$?
#  rm $TMP
  # remove first and last line from outout
 # cat $TMP1 | sed '1d;$d' |
  # remove first and last pipe
#  sed 's/^|[ ]*//g ; s/|[ ]*$//g' >$RESULTSET
#  rm $TMP1
#  return $RES
}

rundroptable() {
  mysqlscript $1
}

runcreatetable() {
  mysqlscript $1
}

testconnection() {
  mysqlcall "SHOW TABLES"
}

verifyvariable() {
  [ -z "$DBHOST" ] && logfail "Variable DBHOST not defined"
}

verifyvariable

export IFEXIST="IF EXISTS"
