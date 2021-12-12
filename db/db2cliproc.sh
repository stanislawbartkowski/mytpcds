source proc/db2commonproc.sh

loadfiles3() {
  db2loadfiles3 $1 $2
}

loadfileclient() {
  db2loadfileserver $1 $2
}


loadfile() {
  if [ -z "$LOADS3" ]; then loadfileclient $@; else loadfiles3 $@; fi
}

# CALL SYSPROC.ADMIN_CMD('LOAD FROM S3::$ENDPOINT::X$AWSKEY::$AWSSECRETKEY::$BUCKET::$INPATH OF DEL INSERT INTO $TABLEDEST');


testconnection() {
    local -r TMP=`crtemp`
    echo "select count(*) from syscat.tables;" >$TMP
    db2clirun $TMP
}

rundroptable() {
  db2clirun $1
}

runcreatetable() {
  db2clirun $1
}

export NULLLAST=X