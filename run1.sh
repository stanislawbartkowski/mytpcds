#export ENV=env/envdb2
export ENV=env/oracle
#export ENV=env/hive
#export ENV=env/postgresql
#export ENV=env/thrive
#export ENV=env/sparksql
#export ENV=env/phoenix
#export ENV=env/bigsql

export TESTDATA=call_center
export TESTQUERY=01
export QUERYTIMEOUT=5m


#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
if [ $? -ne 0 ]; then echo "FAILED"; else echo "PASSED"; fi