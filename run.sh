#export ENV=env/db2
#export ENV=env/bigsql
#export ENV=env/oracle
#export ENV=env/hive
#export ENV=env/postgresql
#export ENV=env/sparksql
#export ENV=env/thrive
#export ENV=env/phoenix
export ENV=env/mysql
#export ENV=env/netezza

export TEMPDIR=/tmp/mytpcds
export TCPROOT=/home/sbartkowski/work/v2.10.0rc2
#TCPROOT=/home/sb/tpc/v2.10.0rc2


#export TESTDATA=call_center
#export TESTDATA=catalog_sales
#export TESTDATA=store_sales
export TESTDATA=dbgen_version

export TESTQUERY=02
export QUERYTIMEOUT=5m
#export QUERYTIMEOUT=1m


#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
./tpc.sh runqueries
if [ $? -ne 0 ]; then echo "FAILED"; else echo "PASSED"; fi
