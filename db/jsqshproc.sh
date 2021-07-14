jsqsh_script() {
    local -r script=$1
    OUTPUT=`crtemp`
    local -r TMP=`crtemp`
    echo "SET CURRENT SCHEMA $SCHEMA;" >$TMP
    cat $script >>$TMP

    timeout $QUERYTIMEOUT jsqsh $DBNAME -v footers=false -v headers=false -i $TMP -o $OUTPUT 2>>$LOGFILE
}

jsqsh_command() {
    local -r command="$1"
    local -r TMP=`crtemp`
    echo "$command" >$TMP
    jsqsh_script $TMP
    if [ $? -ne 0 ]; then logfail "jsqsh failed"; fi
}

# ===========================

loadfile() {
  local -r tablename=$1
  local -r inloadfile=$2
  local -r f=`basename $inloadfile`
  hdfs dfs -copyFromLocal -f $inloadfile $HDFSPATH/$f
  [ $? -eq 0 ] || logfail "Cannot upload local file to HDFS path $HDFSPATH"
  local -r TMP=`crtemp`

cat <<EOF >$TMP
  load hadoop using file url '$HDFSPATH/$f' with source properties ('field.delimiter'='|', 'ignore.extra.fields'='true') into table $tablename OVERWRITE;
EOF
#  cat $TMP

  jsqsh_script $TMP 
}


testconnection() {
    jsqsh_command "SELECT * FROM SYSCAT.TABLES"
}

rundroptable() {
    jsqsh_script $1
}

 runcreatetable() {
     local -r script=$1
     local -r TMP=`crtemp`
     sed "s/create /create hadoop /g" $script | sed "s/ time /varchar(20)/g" | sed "s/);/) $STOREDAS ;/g" >$TMP
     jsqsh_script $TMP
 }

# replaced by JDBC
# not used
jsqsh_runquery() {
  jsqsh_script $1
  local -r RES=$?
  # remove the first and the last line from outout
  sed '1d;$d' $OUTPUT >$RESULTSET
  return $RES
}

# ======================

export IFEXIST="IF EXISTS"
export PURGE="PURGE"
export REQUIREDVARS="STOREDAS HDFSPATH SCHEMA"
export REQUIREDCOMMANDS=jsqsh

