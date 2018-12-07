#export ENV=env/envdb2
#export ENV=env/oracle
#export ENV=env/hive
#export ENV=env/postgresql
#export ENV=env/thrive
#export ENV=env/sparksql
#export ENV=env/phoenix
#export ENV=env/bigsql
export ENV=env/netezza

export QUERYTIMEOUT=5m
export DONOTVERIFY=X

export STREAMNO=$1
[ -z "$STREAMNO" ] && echo "Provide parameter, STREAM number"
[ -z "$STREAMNO" ] && exit 1
echo "STREAM number $STREAMNO"

./tpc.sh runqueries
if [ $? -ne 0 ]; then echo "FAILED"; else echo "PASSED"; fi
