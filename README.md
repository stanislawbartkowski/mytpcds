### mytpcds
Run TPC-DS against different databases including Hive, Spark SQL and IBM BigSQL

https://github.com/stanislawbartkowski/mytpcds/wiki

Test results:
https://github.com/stanislawbartkowski/mytpcds/wiki/TPC-DS-BigData-results

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
phoenixproc.sh  | Implementation for HBase Phoenix (not working)
ptest.sh  | Starter for Throughout Test
res | Expected result sets for Qualify Test
run.sh | Launching script file
tpc.sh | Main tpc-ds test runner
env | Configuration files for databases
mysqlproc.sh | Implementation for MySQL/MariaDB
oracleproc.sh  | Implementation for Oracle
psqlproc.sh | Implementation for PostreSQL
run1.sh  | Alternative launching script
sparksqlproc.sh  | Implementation for SparkSQL
transf.awk | AWK script file used to transform the results

## The queries

Not all queries are ready to execute out of the box. The TPC-DS specification allows small alteration of the query to make them runnable (4.2.3.1).

> It is recognized that implementations require specific adjustments for their operating environment and the
> syntactic variations of its dialect of the SQL language

To avoid keeping a different version of queries for every database, I decided to make amendments on the fly. Most changes are related to date arithmetics like adding or subtracting a number of days or table aliases. I decided also to apply only changes possible to make through simple string or regular expression replacement.

The changes are list in https://github.com/stanislawbartkowski/mytpcds/blob/master/tpc.sh script file, **runsinglequery** bash function.

After that, I ended up with the following queries coverage.

Database | Coverage
------------ | -------------
 DB2   | 100%
 Oracle | 100%
 MySQL/MariaDB | 87%
 PostgreSQL | 97%
 Hive | 49%
 SparkSQL | 94%
 Netezza | 95%
 IBM BigSQL |  100%

## Query Validation

Unfortunately, I was unable to match the answer data set provided in TPC-DS package with any output. So I decided to use Oracle output as a reference answer set. But the Oracle answer set does not provide a perfect match. Sometimes it matches, sometimes does not. As a consequence, the Query Validation implemented is not fully reliable, it is not easy to tell if the query execution is valid or invalid.

https://github.com/stanislawbartkowski/mytpcds/tree/master/res


### QUALIFY test

## Global settings

Variable name | Description | Default/sample value
------------ | ------------- | -------------
TEMPDIR | Temporary directory for log file and temp files | /tmp/mytpcds
TCPROOT | Root directory for upacked TCP-DS payload | /home/sbartkowski/work/v2.10.0rc2
ENV | Resource file for a database under test | env/bigsql
TESTDATA | TCP-DS table used for test loading phase | call_center
TESTQUERY | Number of query used to execute a query test | 04
DONOTVERIFY | If empty, run Test Validation (QUALIFY). If not empty, ignore Test Validation | X (not empty)
QUERYTIMEOUT | Query time execution thereshold. Parameter for **timout** command | 5s (limit is 5 seconds)

## Configure database properties

Prepare the server, the client and the connection. https://github.com/stanislawbartkowski/mytpcds/wiki contains a bunch of useful informations.

In run.sh file uncomment the property file appropriate for a particular database and modify the file according to the environment. 

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

# Step 8, analyze the result

The test result, queries and the time of the execution, is stored in the directory: TCPROOT/work/{database}queries/{database}.result<br/>
Important: every **runqueries** truncated the result file. In order to keep historical result, one has to make a manual copy of the result  file.

### Power Test

* Prepare an appropriate data set using dsdgen utility
* **loaddata**
* **verifyload** (just in case)
* **runqueries**
* pick up the test result
