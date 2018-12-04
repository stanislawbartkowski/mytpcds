verifyphoenix() {
  [ -z "$PHOHOME" ] && logfail "Variable PHOHOME not defined"
  [ -z "$HDFSPATH" ] && logfail "Variable HDFSPATH not defined"/usr/hdp/2.6.4.0-91/phoenix
  [ -z "$PHOURL" ] && logfail "Variable PHOURL not defined"
  [ -z "$HDFSPATH" ] && logfail "Variable HDFSPATH not defined"

  [ -d $PHOHOME ] || logfail "$PHOHOME does not exist"
  PHO=$PHOHOME/bin/sqlline.py
  [ -f $PHO ] || logfail "$PHO does not exist"
}

runquery() {
  $PHO  "$PHOURL" << EOF
    $1 ;
EOF
}

runscript() {
   $PHO  "$PHOURL" $1
}

rundroptable() {
  runscript $1
}

phoenixtransformtable() {
  local infile=$1
  local outfile=$2
  local TMP=`mktemp`

  # get number of line <begofline>()
  grep -n "^(" $infile | cut -d ":" -f1 | while read lno; do
     # increase by one, next line for primary key
     lno=$((lno+1))
     # prepare sequence of sed command
     echo  "${lno}s/,$/ PRIMARY KEY,/" >>$TMP
  done
  #execute sed
  sed -f $TMP $infile | sed "/--/d" >$outfile
  rm $TMP
}

runcreatetable() {
  local TMP=`mktemp`
  phoenixtransformtable $1 $TMP
  cat $TMP
  runscript $TMP
  local RES=$?
  rm $TMP
  return $RES
}

testconnection() {
  runquery "SELECT DISTINCT TABLE_NAME from SYSTEM.CATALOG"
}

impmr() {
  export HADOOP_USER_NAME=hbase
  local table=$1
  local file=$2
#  deltable $table
  local f=`basename $file`
  hdfs dfs -copyFromLocal -f $file $HDFSPATH
  [ $? -eq 0 ] || logfail "Cannot upload local file to HDFS path $HDFSPATH"
  echo "hadoop jar $PHOHOME/phoenix-client.jar org.apache.phoenix.mapreduce.CsvBulkLoadTool -d '|' --table $table --input $HDFSPATH/$f -z $PHOURL"
  hadoop jar $PHOHOME/phoenix-client.jar org.apache.phoenix.mapreduce.CsvBulkLoadTool -d '|' --table $table --input $HDFSPATH/$f -z "$PHOURL"
#  echo python $PHOHOME/bin/psql.py -t $table -d '~' $PHOURL $file
#  python $PHOHOME/bin/psql.py -t $table -d '~' $PHOURL $file
  [ $? -eq 0 ] || logfail "Load failed $table $file"
}

numberofrows() {
   runquery "$1"
}


loadfile() {
  local tbl=$1
  local file=$2
  local TMP=`mktemp -d`
  cd $TMP
  split $file -l 2000000 --additional-suffix \.csv
  [ $? -eq 0 ] || logfail "Cannot split file $file"

  for f in $TMP/*; do
    impmr $tbl $f
  done

  rm -rf $TMP
}


verifyphoenix

export IFEXIST="IF EXISTS"
export REMOVEPRIMARY="X"
