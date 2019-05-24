export TEMPDIR=/tmp/mytpcds
#export TCPROOT=/home/sbartkowski/work/v2.10.0rc2
export TCPROOT=/home/perf/v2.11.0rc2
export TCPDATA=/mnt/data/data1

#export ENV=env/db2
export ENV=env/bigsql
#export ENV=env/oracle
#export ENV=env/hive
#export ENV=env/postgresql
#export ENV=env/sparksql
#export ENV=env/thrive
#export ENV=env/phoenix
#export ENV=env/mysql
#export ENV=env/netezza
#export ENV=env/derby


export TESTDATA=call_center
#export TESTDATA=dbgen_version
#export TESTDATA=catalog_sales
#export TESTDATA=store_sales
#export TESTDATA=dbgen_version

export TESTQUERY=86
#export QUERYTIMEOUT=5m
#export QUERYTIMEOUT=1m

#export DONOTVERIFY=X
export QUERYTIMEOUT=59m

#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
if [ $? -ne 0 ]; then echo "FAILED"; else echo "PASSED"; fi
