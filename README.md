# mytpcds
Run TPC-DS against different databases including Hive, Spark SQL and IBM BigSQL

https://github.com/stanislawbartkowski/mytpcds/wiki

Test results:
https://github.com/stanislawbartkowski/mytpcds/wiki/TPC-DS-BigData-results

### Inspiration

http://www.tpc.org/tpcds/

TPC-DS is an objective tool to measure and compare different databases systems. The same set of data and non trivial queries can be loaded and executed and give an insight how databases respond to the workload. Also, having expected result based on experience, the tool can be also used for testing and tunning the newly installed or upgraded database.
But using TPC-DS is not easy out of the box. Requires some manual tasks to perform. So I decided to prepare an automated tool to do the task. Just download the TPC-DS files, configure and run it.

## TPC-DS preparation
Unpack the compressed zip file in the directory. The following directory structure is created.
* v2.10.1rc3/v2.11.0rc2
  * answer_sets  
  * EULA.txt  
  * query_templates  
  * query_variants  
  * specification  
  * tests  
  * tools  
  
For the purpose of the test the additional directories should be created.
* v2.10.1rc3/v2.11.0rc2
  * work
     * data (will contained input data)
     * db2queries (queries and results related to appropriate database)
     * mysqlqueries
     * (etc)
    
> cd v2.10.1rc3(v2.11.0rc2)/tools<br>
> make <br>

Executable files are created. To create an input data set run the command *dsdgen*. The parameter **-sc** describes the size of the data.
> ./dsdgen -dir ../work/data -sc 100

## Tool description.

The following database servers are supported: PosgreSQL, MySQL (MariaDB), Oracle, DB2, Netezza, Hive, SparkSQL and IBM BigSQL.
The tool consists of several simple bash and awk script files. The tool does not require any dependencies. 

File | Description | Wiki
------------ | ------------- | ------
db/db2proc.sh  | Implementation for DB2 and BigSQL | https://github.com/stanislawbartkowski/mytpcds/wiki/DB2<br>https://github.com/stanislawbartkowski/mytpcds/wiki/IBM-BigSQL
db/hiveproc.sh | Implementation for Hive and SparkSQL Thrive | https://github.com/stanislawbartkowski/mytpcds/wiki/SparkSQL-Thrive
db/netezzaproc.sh | Implementation for Netezza | https://github.com/stanislawbartkowski/mytpcds/wiki/Netezza
db/phoenixproc.sh  | Implementation for HBase Phoenix (not working)
db/mysqlproc.sh | Implementation for MySQL/MariaDB | https://github.com/stanislawbartkowski/mytpcds/wiki/MySQL
db/oracleproc.sh  | Implementation for Oracle | https://github.com/stanislawbartkowski/mytpcds/wiki/Oracle
db/psqlproc.sh | Implementation for PostreSQL | https://github.com/stanislawbartkowski/mytpcds/wiki/PostgreSQL
db/sparksqlproc.sh  | Implementation for SparkSQL | https://github.com/stanislawbartkowski/mytpcds/wiki/SparkSQL-Thrive
db/jsqshproc.sh | Alternative solution for BigSQL, jsqsh | https://github.com/stanislawbartkowski/mytpcds/tree/master/RunQueries
| proc | Several supporting bash and awk scripts | https://github.com/stanislawbartkowski/mytpcds/tree/master/proc
| RunQueries | Java tool to run queries using JDBC connection | https://github.com/stanislawbartkowski/mytpcds/tree/master/proc
ptest.sh  | Starter for Throughput Test
res | Expected result sets for Qualify Test
run.sh | Launching script file
tpc.sh | Main tpc-ds test runner
env | Configuration files for databases
transf.awk | AWK script file used to transform the results
env.templates | Templates for configuration files
sh.templates | Templates for lauch scripts
res | Refeence data set for Qualify Test
qualification | Queries parameters used to run Qualify Test

## Java Query Runner

The queries can be executed by an appropriate command line tool. But to pass Qalify Test, the output should match the reference answer result set. Because every tool comes with its own output format, it is not easy to find a common denominator for all databases. So I develeped a simple Java QueryRunner giving the same output format regardless of the database.<br>

**Build Java Query Runner**
> cd RunQueries<br>
> mvn package<br>

The following directory structure should be created.
```
ll target/
  archive-tmp
  classes
  generated-sources
  lib
  maven-archiver
  maven-status
  RunQueries-1.0-SNAPSHOT.jar
  RunQueries-1.0-SNAPSHOT-jar-with-dependencies.jar
```
In order to use QueryRunner in the test, **DBURL** and **JAVADRIVER** configuration parameters should be provied.

## Tool configuarion
Copy bash scripts from *sh.templates* to the directory.

> cd mytpcds<br>
> cp sh.templates/* .<br>

Create directory for database connection specification.
> mkdir env<br>

Copy relevent properties file from *env.templates* to *env* and configure according to yout evironment.
For instance: to run Hive TPC/DS test.<br>

> cp env.templates/hive.rc env<br>

The common configuration parameters

| Parameter | Value | Example
| ------- | ------- | ----- |
| DBNAME | Database name | PERFDB
| DBUSER | Database user, should have full privileges in the database | perf
| DBPASSWORD | Database password | secret
| DBHOST | Database host name | netezza.fyre.ibm.com
| DTYPE | Database identifier, should correspond to db/${DTYPE}proc.sh | netezza, points to db/netezzaproc.sh
| DBURL | JDBC URL to connect to database | jdbc:netezza://$DBHOST:5480/$DBNAME
| JAVADRIVER | JDBC Java driver jar file | /usr/local/nz/lib/nzjdbc3.jar

**DBURL** and **JAVADRIVER** should be specified only if QueryRunner is going to be used. If only database client software is utilized, these parameters should be ignored.

## The queries

Not all queries are ready to execute out of the box. The TPC-DS specification allows small alteration of the query to make them runnable (4.2.3.1).

> It is recognized that implementations require specific adjustments for their operating environment and the
> syntactic variations of its dialect of the SQL language

To avoid keeping a different version of queries for every database, I decided to make amendments on the fly. Most changes are related to date arithmetics like adding or subtracting a number of days or table aliases. Changes are limited to basic text substitution without touching the query logic.

The changes are implemented in https://github.com/stanislawbartkowski/mytpcds/blob/master/tpc.sh script file, **runsinglequery** bash function.

After that, I ended up with the following queries coverage.

Database | Coverage
------------ | -------------
 DB2   | 100%
 Oracle | 100%
 MySQL/MariaDB | 87%
 PostgreSQL | 97%
 Hive 2.1 | 49%
 SparkSQL 2.3 | 94%
 Netezza/NPS | 95%
 IBM BigSQL |  100%
 
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

In **conn.rc** file uncomment the property file appropriate for a particular database and modify the file according to the environment. 

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

### Qualify Test

## Qualify dataset

Qualify database is 1GB size.

> ./dsdgen -dir ../work/data -sc 1

## Qualify queries

Qualify queries are used to validate SQL SELECT statements. Qualify queries contains hardcoded parameter values and executed against qualify dataset should yield the same result set. The **run.sh** **queryqualification** task creates a serie of qualify queries. Every test templates has corresponding parameter definition in **qualification** directory. For instance, query template **query_templates/query4.tpl** has corresponding parameters set **qualification/4.par**
```
YEAR=2001
SELECTONE=t_s_secyear.customer_preferred_cust_flag
```
To prepare qualification queries:
* Configure **conn.rc** and **env/{db}proc.sh** file
* **run.sh** file, uncomment *./tpc.sh queryqualification* line and comment out all other *./tpc.sh* lines.
* ./run.sh
```
qgen2 Query Generator (Version 2.11.0)
Copyright Transaction Processing Performance Council (TPC) 2001 - 2019
Warning: This scale factor is valid for QUALIFICATION ONLY
Parsed 99 templates
PASSED
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

## Power Test

* Prepare an appropriate data set using dsdgen utility
* **loaddata**
* **verifyload** (just in case)
* **runqueries**
* pick up the test result

## Throughput Test
### Preparation
(TPC-DS specification : 7.4.6)<br>
Throughput Test measures the ability of the database engine to process queries with multiple users.
Assume the minimal number of concurrent streams, 4.<br>
A separate batch file *ptest.sh* should be launched to emulate one session. The *ptest.sh* accepts a parameter, number 0-3 meaning the stream number. Example, stream number 3.
> ./ptest.sh 3
### Prepare the query streams.
> ./dsqgen -VERBOSE Y -DIRECTORY ../query_templates -INPUT ../query_templates/templates.lst -OUTPUT_DIR ../work/{directory} -DIALECT {dialect} -STREAMS 4 -sc 100<br>

Example for DB2:<br>

> ./dsqgen -VERBOSE Y -DIRECTORY ../query_templates -INPUT ../query_templates/templates.lst -OUTPUT_DIR ../work/db2queries -DIALECT db2 -STREAMS 4 -sc 100<br>

The command prepares four streams of queriers in *../work/db2queries* directory.
```
 query_0.sql
 query_1.sql
 query_2.sql
 query_3.sql
```
### Run the test
Next step is to launch four *ptest.sh* session with parameters 0,1,2, and 3 running in parallel. Every session runs appropriate list of queries and produce a separate result report.
For instance:
> ./ptest 2<br>

It will execute *query_2.sql* query set and outputs the result in *work/db2queries/db2sql.result2*
### Result
When all sessions complete, evaluate the result in *work/db2queries*.
