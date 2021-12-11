
#JAVACMD="java $JVMPARS -cp RunQueries/target/RunQueries-1.0-SNAPSHOT-jar-with-dependencies.jar:$JAVADRIVER RunMain -url $DBURL -user $DBUSER -password $DBPASSWORD $RUNQUERYPAR $RUNQUERYDBPARAMS"

# ===================
# internal
# ===================

setjdbc() {
   JAVACMD="java $JVMPARS -cp RunQueries/target/RunQueries-1.0-SNAPSHOT-jar-with-dependencies.jar:$JAVADRIVER RunMain -url $DBURL -user $DBUSER -password $DBPASSWORD $RUNQUERYPAR $RUNQUERYDBPARAMS -rounddec 2"
}

queryjdbccommand() {
    setjdbc
    $QUERYTIMEOUT $JAVACMD $2 "$1" -query
}

jdbccommand() {
   queryjdbccommand "$1" -s
}

jdbcfilecommand() {
   cat $1 >>$LOGFILE
   queryjdbccommand $1 -f
}

jdbcqueryupdatefile() {
    setjdbc
    $QUERYTIMEOUT $JAVACMD -f "$1"
}

jdbcrunquery() {
    jdbcfilecommand $1 >$RESULTSET
}


# ==================
# interface command
# ==================

rundroptable() {
    jdbcqueryupdatefile $1
}

runcreatetable() {
    jdbcqueryupdatefile $1
}

numberofrows() {
    jdbccommand "$1"
}

runquery() {
    jdbcrunquery $1 
}

testjdbcconnection() {
    setjdbc
    $JAVACMD 
}
