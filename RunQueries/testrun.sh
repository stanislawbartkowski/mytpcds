DRIVER=/usr/local/nz/lib/nzjdbc3.jar
SQLFILE=/tmp/test.sql
java -cp target/RunQueries-1.0-SNAPSHOT-jar-with-dependencies.jar:$DRIVER RunMain -url jdbc:netezza://netezza:5480/perfdb -user perf -password secret -f $SQLFILE -query
