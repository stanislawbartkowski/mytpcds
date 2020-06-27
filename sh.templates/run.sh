source ./conn.rc 

export TESTDATA=call_center
#export TESTDATA=dbgen_version
#export TESTDATA=catalog_sales
#export TESTDATA=store_sales
#export TESTDATA=dbgen_version

export TESTQUERY=1
#export QUERYTIMEOUT=5m
#export QUERYTIMEOUT=1m

export QUALIFYTEST=X
export QUERYTIMEOUT=59m

#./tpc.sh querystreams 
#./tpc.sh queryqualification
#./tpc.sh test
./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
if [ $? -ne 0 ]; then echo "FAILED"; else echo "PASSED"; fi
