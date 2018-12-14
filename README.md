### mytpcds
Run TPC-DS against different databases including Hive, Spark SQL and IBM BigSQL

https://github.com/stanislawbartkowski/mytpcds/wiki

### Inspiration

http://www.tpc.org/tpcds/

TPC-DS is an objective tool to measure and compare different databases systems. The same set of data and non trivial queries can be loaded and executed and give an insight how databases respond to the workload. Also, having expected result based on experience, the tool can be also used for testing and tunning the newly installed or upgraded database.
But using TPC-DS is not easy out of the box. Requires some manual tasks to perform. So I decided to prepare an automated tool to do the task. Just download the TPC-DS files, configure and run it.

## Tool description.

The following database servers are supported: PosgreSQL, MySQL (MariaDB), Oracle, DB2, Netezza, Hive, SparkSQL and IBM BigSQL.
The tool consists of several simple bash and awk script files. The tool does not require any dependencies. 

File | Description
------------ | -------------
db2proc.sh  | Implementation for DB2 and BigSQL 
hiveproc.sh | Implementation for Hive and SparkSQL Thrive
netezzaproc.sh | Implementation for Netezza
phoenixproc.sh  | Implementation for HBAse Phoenix (not working)
ptest.sh  | Starter for Throughout Test
res | Expected result sets for Qualify and Performace Test
run.sh | Launching script file
tpc.sh | Main tpc-ds test runner
env | Resource file for a databases
mysqlproc.sh | Implementation for MySQL and MariaDB
oracleproc.sh  | Implementation for Oracle
psqlproc.sh | Implementation for PostreSQL
run1.sh  | Alternative launching script
sparksqlproc.sh  | Implementation for SparkSQL
transf.awk | AWK script file used to transform the results

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

The test compares number of lines in text input file and number of rows in the target table

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

# Step 5, load all data

Uncomment **./tpc.sh loaddata** line and run the script

```bash
#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
```
# Step 6, verify loaded data

This test compares number of line in input text files against corresponding target tables.

Uncomment **./tpc.sh verifyload** line and run the script

```bash
#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
./tpc.sh verifyload
#./tpc.sh runqueries
```

# Step 7, run a single query

Run single query as a test

Uncomment **./tpc.sh testquery** line and run the script

export TESTQUERY=98

```bash
#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
#./tpc.sh runqueries
```
# Step 7, run all queries, QUALIFY TEST

Uncomment **./tpc.sh runqueries** line and run the script

```bash
#./tpc.sh test
#./tpc.sh removedata
#./tpc.sh createtables
#./tpc.sh loadtest
#./tpc.sh testverify
#./tpc.sh testquery

#./tpc.sh loaddata
#./tpc.sh verifyload
./tpc.sh runqueries
```
