
prepareurl() {
  local typ=$1
  if [ $typ -eq 0 ]
     then U=${HIVEURL/XX-XX/$TENAME}
     else U=${HIVEURL/XX-XX/$DBNAME}
  fi
  DBE=
  E=
  if [ -n "§USE" ]; then
  E='-e'
  if [ $typ -eq 0 ]
     then DBE="USE $TENAME"
     else DBE="USE $DBNAME"
  fi
  fi
  echo $DBE
}

runhive() {
  local command="$2"
  prepareurl $1
  beeline -u "$U" -n $DBUSER $E "$DBE" -e "$command"
  [ $? -eq 0 ] || logfail "Cannot execute Hive command"
}

# ROW FORMAT DELIMITED FIELDS TERMINATED BY "|";
transformtablesql() {
  local infile=$1
  local outfile=$2
  sed "s/ time /varchar(20)/g" $infile | sed "s/not null//g" | sed "s/integer/int/g" | sed "/primary key/d" | sed -z  "s/,[ ,\n]*);/\n);/g"  | sed "s/);/) ROW FORMAT DELIMITED FIELDS TERMINATED BY \"|\" ;"/g  >$outfile
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

rundroptable() {
  local -r TMP=`crtemp`
  sed "s/;/ PURGE;/g" $1 >$TMP
  runscript $TMP
}

runcreatetable() {
  local TMP=`crtemp`
  transformtablesql $1 $TMP
  runscript $TMP
}

testconnection() {
  log "Verify  Hive connection"
  runhive 0 "SHOW TABLES"
  runhive 1 "SHOW TABLES"
}

toremove_numberofrows() {
  local table=$1
  local TMP=$2
  runhive 1 "SELECT CONCAT('NUMBEROFROWS:',COUNT(*)) AS XX FROM $table" | grep "NUMBEROFROWS:" | tr -d "\| " | cut -d ":" -f2 >$TMP
}

numberofrows() {
  runhive 1 "$1"
}

loadfile() {
  local -r tablename=$1
  local -r inloadfile=$2
  hdfs dfs -copyFromLocal -f $inloadfile $HDFSPATH
  [ $? -eq 0 ] || logfail "Cannot upload local file to HDFS path $HDFSPATH"
  local -r f=`basename $inloadfile`
  runhive 0 "LOAD DATA INPATH \"$HDFSPATH/$f\" OVERWRITE INTO TABLE $tablename"
  runhive 0 "drop table IF EXISTS $DBNAME.$tablename purge"
  runhive 0 "create table $DBNAME.$tablename stored as parquet as select * from $tablename"
  runhive 0 "truncate table $tablename"
}

verifyhive() {
  [ -z "$HIVEURL" ] && logfail "Variable HIVEURL not defined"
  [ -z "$HDFSPATH" ] && logfail "Variable HDFSPATH not defined"
  [ -z "$TENAME" ] && logfail "Variable TENAME not defined"
}

export IFEXIST="IF EXISTS"
export REPLACEQUERYDAYSPROC=X
export MODIFYALIAS=X


verifyhive
