export TEMPDIR=/tmp/mytpcds
#export TCPROOT=/home/sbartkowski/work/v2.10.0rc2
#export TCPROOT=/home/sb/v2.10.0rc2
export TCPROOT=/home/perf/v2.10.1rc3
export TCPDATA=/mnt/data/data

#export ENV=env/envdb2
#export ENV=env/oracle
#export ENV=env/hive
#export ENV=env/postgresql
#export ENV=env/thrive
#export ENV=env/sparksql
#export ENV=env/phoenix
export ENV=env/bigsql
#export ENV=env/netezza

export QUERYTIMEOUT=4h
export DONOTVERIFY=X

export STREAMNO=$1
[ -z "$STREAMNO" ] && { echo "Provide parameter, STREAM number"; exit 1; }
echo "STREAM number $STREAMNO"

./tpc.sh runqueries
if [ $? -ne 0 ]; then echo "FAILED"; else echo "PASSED"; fi
