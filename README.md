### mytpcds
Run TPC-DS against different databases including Hive, Spark SQL and IBM BigSQL

https://github.com/stanislawbartkowski/mytpcds/wiki

### Inspiration

http://www.tpc.org/tpcds/
TPC-DS is an objective tool to measure and compare different databases systems. The same set of data and non trivial queries can be loaded and executed and give an insight how databases respond to the workload. Also, having expected result based on experience, the tool can be also used for testing and tunning the newly installed or upgraded database.


### QUALIFY test

Prepare the server, the client and the connection. https://github.com/stanislawbartkowski/mytpcds/wiki contains a bunch of useful informations.

In run.sh file uncomment the resource file appropriate for a particular database.

https://github.com/stanislawbartkowski/mytpcds/blob/master/run.sh

For instance, for Oracle
```bash
#export ENV=env/db2
#export ENV=env/bigsql
export ENV=env/oracle
#export ENV=env/hive
#export ENV=env/postgresql
#export ENV=env/sparksql
#export ENV=env/thrive
#export ENV=env/phoenix
#export ENV=env/mysql
#export ENV=env/netezza
```

## Step 1, test the connection

Uncomment **#./tpc.sh test** line in run.sh file

```bash
./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
```
Execute ./run.sh. If connection is working, the output should be:
```
./run.sh 
PASSED
```
If the connection is not configured properly then look at output log file. The log directory is specified as **LOGDIR** in the resource file. 
> tail -f  /tmp/mytpcds/oraclelog/mytcp.log

## Step 2, create tables

Uncomment **./tpc.sh createtables** line and run the script
```bash
#./tpc.sh test
#./tpc.sh removedata
./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
```
# Step 3, load single table as a test
Uncomment **./tpc.sh loadtest** line and run the script

```bash
export TESTDATA=call_center

#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
```
# Step 4, verify data loaded

The test compares number of lines in text input file and number of rows in target table

Uncomment **./tpc.sh testverify** line and run the script

```bash
export TESTDATA=call_center

#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
```
