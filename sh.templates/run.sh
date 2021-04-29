source ./conn.rc 

#export TESTDATA=call_center
#export TESTDATA=catalog_page
#export TESTDATA=catalog_returns
#export TESTDATA=catalog_sales
#export TESTDATA=customer_address
#export TESTDATA=customer
#export TESTDATA=customer_demographics
#export TESTDATA=date_dim
#export TESTDATA=dbgen_version
#export TESTDATA=household_demographics
#export TESTDATA=income_band
#export TESTDATA=inventory
#export TESTDATA=item
#export TESTDATA=promotion
#export TESTDATA=reason
#export TESTDATA=ship_mode
#export TESTDATA=store
#export TESTDATA=store_returns
#export TESTDATA=store_sales
#export TESTDATA=time_dim
#export TESTDATA=warehouse
#export TESTDATA=web_page
#export TESTDATA=web_returns
#export TESTDATA=web_sales
export TESTDATA=web_site

export TESTQUERY=1
#export QUERYTIMEOUT=5m
#export QUERYTIMEOUT=1m

export QUALIFYTEST=X
export QUERYTIMEOUT=59m

#./tpc.sh querystreams 
#./tpc.sh queryqualification
# ./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
./tpc.sh runqueries
if [ $? -ne 0 ]; then echo "FAILED"; else echo "PASSED"; fi
