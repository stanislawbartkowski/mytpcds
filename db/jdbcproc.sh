
JAVACMD="java $JVMPARS -cp RunQueries/target/RunQueries-1.0-SNAPSHOT-jar-with-dependencies.jar:$JAVADRIVER RunMain -url $DBURL -user $DBUSER -password $DBPASSWORD"

# ===================
# internal
# ===================

queryjdbccommand() {
    timeout $QUERYTIMEOUT $JAVACMD $2 "$1" -query
}

jdbccommand() {
   queryjdbccommand "$1" -s
}

jdbcfilecommand() {
   queryjdbccommand $1 -f
}

jdbcqueryupdatefile() {
    timeout $QUERYTIMEOUT $JAVACMD -f "$1"
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
    jdbcfilecommand $1 >$RESULTSET
}

testjdbcconnection() {
    $JAVACMD 
}