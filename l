+++ w
+++ STARTPWD=/home/sbartkowski/work/mytpcds
+++ IFEXIST=
+++ '[' -z env/postgresql ']'
+++ source ./env/postgresql.rc
++++ DBNAME=perfdb
++++ DBUSER=perf
++++ DBPASSWORD=secret
++++ DBHOST=thinkarek
++++ DBPORT=5432
++++ DBURL=jdbc:postgresql://thinkarek:5432/perfdb
++++ JAVADRIVER=/usr/share/java/postgresql-jdbc.jar
++++ LOADBUFFER=/tmp/load
++++ DTYPE=psql
++++ KILLINTERVAL='3 hours'
++++ JVMPARS=-Xmx4096m
++++ mktemp
+++ declare -g TMPSTORE=/tmp/tmp.pPi7zf2GA7
+++ '[' -z psql ']'
+++ '[' -z /tmp/tpcds ']'
+++ mkdir -p /tmp/tpcds
+++ source proc/commonproc.sh
++++ REPDEL='|'
++++ COLDEL='|'
+++ source db/jdbcproc.sh
+++ source db/psqlproc.sh
++++ source proc/psqlproc.sh
++++ verifyvariable
++++ '[' -z thinkarek ']'
++++ '[' -z '3 hours' ']'
++++ export DB=perfdb
++++ DB=perfdb
++++ export 'IFEXIST=IF EXISTS'
++++ IFEXIST='IF EXISTS'
++++ export REMOVEQUERYDAYS=X
++++ REMOVEQUERYDAYS=X
++++ export REQUIREDCOMMANDS=psql
++++ REQUIREDCOMMANDS=psql
++++ export NULLLAST=X
++++ NULLLAST=X
+++ source proc/queries.sh
+++ COLQUERYLEN=7
+++ COLTIMELEN=4
+++ COLRESULTLEN=7
+++ COLLINESLEN=10
+++ VERQ=1
+++ case $1 in
+++ verify 1
+++ local -r VERQ=1
+++ DTYPEID=psql
+++ LOGDIR=/tmp/tpcds/psqllog
+++ mkdir -p /tmp/tpcds/psqllog
+++ LOGFILE=/tmp/tpcds/psqllog/mytcpds.log
+++ touchlogfile
+++ required_var LOGFILE
+++ local -r VARIABLE=LOGFILE
+++ '[' -z /tmp/tpcds/psqllog/mytcpds.log ']'
++++ dirname ''
+++ local -r basedir=.
+++ createbasedir /tmp/tpcds/psqllog/mytcpds.log
+++ local -r file=/tmp/tpcds/psqllog/mytcpds.log
++++ dirname /tmp/tpcds/psqllog/mytcpds.log
+++ local -r basedir=/tmp/tpcds/psqllog
+++ mkdir -p /tmp/tpcds/psqllog
+++ '[' 0 -ne 0 ']'
+++ touch /tmp/tpcds/psqllog/mytcpds.log
+++ required_var DBNAME
+++ local -r VARIABLE=DBNAME
+++ '[' -z perfdb ']'
+++ TEMPDIR=/tmp/tpcds
+++ TCPDS=/home/sbartkowski/work/DSGen-software-code-3.2.0rc1/tools/tpcds.sql
+++ TCPDATA=/mnt/s3/sbtest/tpcdata/data1
+++ STREAMNO=0
+++ TCPQ0=/home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/query_0.sql
+++ RESFILE0=/home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/psql.result0
+++ LOADTIMEFILE=/home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/psql.loadtime
+++ TESTQUERY=5
+++ TESTDATA=customer
+++ QUERYTIMEOUT='timeout 10m'
+++ RESQUERYDIR=/home/sbartkowski/work/mytpcds/qualifres
+++ DELIM='|'
+++ RESULTDIRECTORY=/tmp/tpcds/psqlresult0
+++ TMPQ=/tmp/tpcds/psqlqueries0
+++ mkdir -p /tmp/tpcds/psqlresult0
+++ mkdir -p /home/sbartkowski/work/mytpcds/qualifres
+++ required_listofvars 'RESQUERYDIR RESULTDIRECTORY TCPDATA RESFILE0'
+++ local -r 'listv=RESQUERYDIR RESULTDIRECTORY TCPDATA RESFILE0'
+++ for value in $listv
+++ required_var RESQUERYDIR
+++ local -r VARIABLE=RESQUERYDIR
+++ '[' -z /home/sbartkowski/work/mytpcds/qualifres ']'
+++ for value in $listv
+++ required_var RESULTDIRECTORY
+++ local -r VARIABLE=RESULTDIRECTORY
+++ '[' -z /tmp/tpcds/psqlresult0 ']'
+++ for value in $listv
+++ required_var TCPDATA
+++ local -r VARIABLE=TCPDATA
+++ '[' -z /mnt/s3/sbtest/tpcdata/data1 ']'
+++ for value in $listv
+++ required_var RESFILE0
+++ local -r VARIABLE=RESFILE0
+++ '[' -z /home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/psql.result0 ']'
+++ required_command python3
+++ local -r COMMAND=python3
+++ command -v python3
+++ existfile /home/sbartkowski/work/DSGen-software-code-3.2.0rc1/tools/tpcds.sql
+++ local -r file=/home/sbartkowski/work/DSGen-software-code-3.2.0rc1/tools/tpcds.sql
+++ '[' -f /home/sbartkowski/work/DSGen-software-code-3.2.0rc1/tools/tpcds.sql ']'
+++ '[' 1 -eq 1 ']'
+++ existfile /home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/query_0.sql
+++ local -r file=/home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/query_0.sql
+++ '[' -f /home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/query_0.sql ']'
+++ '[' -d /mnt/s3/sbtest/tpcdata/data1 ']'
+++ '[' -d /home/sbartkowski/work/mytpcds/qualifres ']'
+++ '[' -n '' ']'
+++ '[' -n psql ']'
+++ required_listofcommands psql
+++ local -r LISTC=psql
+++ for value in $LISTC
+++ required_command psql
+++ local -r COMMAND=psql
+++ command -v psql
++++ crtemp
++++ required_var TMPSTORE
++++ local -r VARIABLE=TMPSTORE
++++ '[' -z /tmp/tmp.pPi7zf2GA7 ']'
+++++ mktemp
++++ local -r TMP=/tmp/tmp.L94bwo6HQh
++++ echo /tmp/tmp.L94bwo6HQh
++++ echo /tmp/tmp.L94bwo6HQh
+++ export RESULTSET=/tmp/tmp.L94bwo6HQh
+++ RESULTSET=/tmp/tmp.L94bwo6HQh
+++ trap removetemp EXIT
+++ '[' -n jdbc:postgresql://thinkarek:5432/perfdb ']'
+++ required_listofvars JAVADRIVER
+++ local -r listv=JAVADRIVER
+++ for value in $listv
+++ required_var JAVADRIVER
+++ local -r VARIABLE=JAVADRIVER
+++ '[' -z /usr/share/java/postgresql-jdbc.jar ']'
+++ VERQ=1
+++ case $1 in
+++ main testquery
+++ case $1 in
+++ testquery
+++ preparequery
++++ mktemp -d
+++ local -r TEMPD=/tmp/tmp.UuY0TCWj7R
+++ mkdir -p /tmp/tmp.UuY0TCWj7R
+++ cd /tmp/tmp.UuY0TCWj7R
+++ csplit --suppress-matched /home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/query_0.sql '/-- end query/' '{*}' -f query -s
+++ find /tmp/tmp.UuY0TCWj7R -size 0 -exec rm '{}' ';'
+++ rm -f /tmp/tpcds/psqlqueries0/query1 /tmp/tpcds/psqlqueries0/query10 /tmp/tpcds/psqlqueries0/query11 /tmp/tpcds/psqlqueries0/query12 /tmp/tpcds/psqlqueries0/query13 /tmp/tpcds/psqlqueries0/query14 /tmp/tpcds/psqlqueries0/query15 /tmp/tpcds/psqlqueries0/query16 /tmp/tpcds/psqlqueries0/query17 /tmp/tpcds/psqlqueries0/query18 /tmp/tpcds/psqlqueries0/query19 /tmp/tpcds/psqlqueries0/query2 /tmp/tpcds/psqlqueries0/query20 /tmp/tpcds/psqlqueries0/query21 /tmp/tpcds/psqlqueries0/query22 /tmp/tpcds/psqlqueries0/query23 /tmp/tpcds/psqlqueries0/query24 /tmp/tpcds/psqlqueries0/query25 /tmp/tpcds/psqlqueries0/query26 /tmp/tpcds/psqlqueries0/query27 /tmp/tpcds/psqlqueries0/query28 /tmp/tpcds/psqlqueries0/query29 /tmp/tpcds/psqlqueries0/query3 /tmp/tpcds/psqlqueries0/query30 /tmp/tpcds/psqlqueries0/query31 /tmp/tpcds/psqlqueries0/query32 /tmp/tpcds/psqlqueries0/query33 /tmp/tpcds/psqlqueries0/query34 /tmp/tpcds/psqlqueries0/query35 /tmp/tpcds/psqlqueries0/query36 /tmp/tpcds/psqlqueries0/query37 /tmp/tpcds/psqlqueries0/query38 /tmp/tpcds/psqlqueries0/query39 /tmp/tpcds/psqlqueries0/query4 /tmp/tpcds/psqlqueries0/query40 /tmp/tpcds/psqlqueries0/query41 /tmp/tpcds/psqlqueries0/query42 /tmp/tpcds/psqlqueries0/query43 /tmp/tpcds/psqlqueries0/query44 /tmp/tpcds/psqlqueries0/query45 /tmp/tpcds/psqlqueries0/query46 /tmp/tpcds/psqlqueries0/query47 /tmp/tpcds/psqlqueries0/query48 /tmp/tpcds/psqlqueries0/query49 /tmp/tpcds/psqlqueries0/query5 /tmp/tpcds/psqlqueries0/query50 /tmp/tpcds/psqlqueries0/query51 /tmp/tpcds/psqlqueries0/query52 /tmp/tpcds/psqlqueries0/query53 /tmp/tpcds/psqlqueries0/query54 /tmp/tpcds/psqlqueries0/query55 /tmp/tpcds/psqlqueries0/query56 /tmp/tpcds/psqlqueries0/query57 /tmp/tpcds/psqlqueries0/query58 /tmp/tpcds/psqlqueries0/query59 /tmp/tpcds/psqlqueries0/query6 /tmp/tpcds/psqlqueries0/query60 /tmp/tpcds/psqlqueries0/query61 /tmp/tpcds/psqlqueries0/query62 /tmp/tpcds/psqlqueries0/query63 /tmp/tpcds/psqlqueries0/query64 /tmp/tpcds/psqlqueries0/query65 /tmp/tpcds/psqlqueries0/query66 /tmp/tpcds/psqlqueries0/query67 /tmp/tpcds/psqlqueries0/query68 /tmp/tpcds/psqlqueries0/query69 /tmp/tpcds/psqlqueries0/query7 /tmp/tpcds/psqlqueries0/query70 /tmp/tpcds/psqlqueries0/query71 /tmp/tpcds/psqlqueries0/query72 /tmp/tpcds/psqlqueries0/query73 /tmp/tpcds/psqlqueries0/query74 /tmp/tpcds/psqlqueries0/query75 /tmp/tpcds/psqlqueries0/query76 /tmp/tpcds/psqlqueries0/query77 /tmp/tpcds/psqlqueries0/query78 /tmp/tpcds/psqlqueries0/query79 /tmp/tpcds/psqlqueries0/query8 /tmp/tpcds/psqlqueries0/query80 /tmp/tpcds/psqlqueries0/query81 /tmp/tpcds/psqlqueries0/query82 /tmp/tpcds/psqlqueries0/query83 /tmp/tpcds/psqlqueries0/query84 /tmp/tpcds/psqlqueries0/query85 /tmp/tpcds/psqlqueries0/query86 /tmp/tpcds/psqlqueries0/query87 /tmp/tpcds/psqlqueries0/query88 /tmp/tpcds/psqlqueries0/query89 /tmp/tpcds/psqlqueries0/query9 /tmp/tpcds/psqlqueries0/query90 /tmp/tpcds/psqlqueries0/query91 /tmp/tpcds/psqlqueries0/query92 /tmp/tpcds/psqlqueries0/query93 /tmp/tpcds/psqlqueries0/query94 /tmp/tpcds/psqlqueries0/query95 /tmp/tpcds/psqlqueries0/query96 /tmp/tpcds/psqlqueries0/query97 /tmp/tpcds/psqlqueries0/query98 /tmp/tpcds/psqlqueries0/query99
+++ mkdir -p /tmp/tpcds/psqlqueries0
+++ '[' -z '' ']'
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query00
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query00
++++ local TPLNAME=query96.tpl
+++++ basename -s.tpl query96.tpl
++++ local QUERY=query96
++++ echo query96
+++ QUERY=query96
+++ cp /tmp/tmp.UuY0TCWj7R/query00 /tmp/tpcds/psqlqueries0/query96
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query01
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query01
++++ local TPLNAME=query7.tpl
+++++ basename -s.tpl query7.tpl
++++ local QUERY=query7
++++ echo query7
+++ QUERY=query7
+++ cp /tmp/tmp.UuY0TCWj7R/query01 /tmp/tpcds/psqlqueries0/query7
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query02
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query02
++++ local TPLNAME=query75.tpl
+++++ basename -s.tpl query75.tpl
++++ local QUERY=query75
++++ echo query75
+++ QUERY=query75
+++ cp /tmp/tmp.UuY0TCWj7R/query02 /tmp/tpcds/psqlqueries0/query75
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query03
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query03
++++ local TPLNAME=query44.tpl
+++++ basename -s.tpl query44.tpl
++++ local QUERY=query44
++++ echo query44
+++ QUERY=query44
+++ cp /tmp/tmp.UuY0TCWj7R/query03 /tmp/tpcds/psqlqueries0/query44
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query04
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query04
++++ local TPLNAME=query39.tpl
+++++ basename -s.tpl query39.tpl
++++ local QUERY=query39
++++ echo query39
+++ QUERY=query39
+++ cp /tmp/tmp.UuY0TCWj7R/query04 /tmp/tpcds/psqlqueries0/query39
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query05
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query05
++++ local TPLNAME=query80.tpl
+++++ basename -s.tpl query80.tpl
++++ local QUERY=query80
++++ echo query80
+++ QUERY=query80
+++ cp /tmp/tmp.UuY0TCWj7R/query05 /tmp/tpcds/psqlqueries0/query80
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query06
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query06
++++ local TPLNAME=query32.tpl
+++++ basename -s.tpl query32.tpl
++++ local QUERY=query32
++++ echo query32
+++ QUERY=query32
+++ cp /tmp/tmp.UuY0TCWj7R/query06 /tmp/tpcds/psqlqueries0/query32
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query07
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query07
++++ local TPLNAME=query19.tpl
+++++ basename -s.tpl query19.tpl
++++ local QUERY=query19
++++ echo query19
+++ QUERY=query19
+++ cp /tmp/tmp.UuY0TCWj7R/query07 /tmp/tpcds/psqlqueries0/query19
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query08
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query08
++++ local TPLNAME=query25.tpl
+++++ basename -s.tpl query25.tpl
++++ local QUERY=query25
++++ echo query25
+++ QUERY=query25
+++ cp /tmp/tmp.UuY0TCWj7R/query08 /tmp/tpcds/psqlqueries0/query25
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query09
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query09
++++ local TPLNAME=query78.tpl
+++++ basename -s.tpl query78.tpl
++++ local QUERY=query78
++++ echo query78
+++ QUERY=query78
+++ cp /tmp/tmp.UuY0TCWj7R/query09 /tmp/tpcds/psqlqueries0/query78
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query10
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query10
++++ local TPLNAME=query86.tpl
+++++ basename -s.tpl query86.tpl
++++ local QUERY=query86
++++ echo query86
+++ QUERY=query86
+++ cp /tmp/tmp.UuY0TCWj7R/query10 /tmp/tpcds/psqlqueries0/query86
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query11
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query11
++++ local TPLNAME=query1.tpl
+++++ basename -s.tpl query1.tpl
++++ local QUERY=query1
++++ echo query1
+++ QUERY=query1
+++ cp /tmp/tmp.UuY0TCWj7R/query11 /tmp/tpcds/psqlqueries0/query1
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query12
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query12
++++ local TPLNAME=query91.tpl
+++++ basename -s.tpl query91.tpl
++++ local QUERY=query91
++++ echo query91
+++ QUERY=query91
+++ cp /tmp/tmp.UuY0TCWj7R/query12 /tmp/tpcds/psqlqueries0/query91
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query13
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query13
++++ local TPLNAME=query21.tpl
+++++ basename -s.tpl query21.tpl
++++ local QUERY=query21
++++ echo query21
+++ QUERY=query21
+++ cp /tmp/tmp.UuY0TCWj7R/query13 /tmp/tpcds/psqlqueries0/query21
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query14
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query14
++++ local TPLNAME=query43.tpl
+++++ basename -s.tpl query43.tpl
++++ local QUERY=query43
++++ echo query43
+++ QUERY=query43
+++ cp /tmp/tmp.UuY0TCWj7R/query14 /tmp/tpcds/psqlqueries0/query43
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query15
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query15
++++ local TPLNAME=query27.tpl
+++++ basename -s.tpl query27.tpl
++++ local QUERY=query27
++++ echo query27
+++ QUERY=query27
+++ cp /tmp/tmp.UuY0TCWj7R/query15 /tmp/tpcds/psqlqueries0/query27
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query16
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query16
++++ local TPLNAME=query94.tpl
+++++ basename -s.tpl query94.tpl
++++ local QUERY=query94
++++ echo query94
+++ QUERY=query94
+++ cp /tmp/tmp.UuY0TCWj7R/query16 /tmp/tpcds/psqlqueries0/query94
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query17
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query17
++++ local TPLNAME=query45.tpl
+++++ basename -s.tpl query45.tpl
++++ local QUERY=query45
++++ echo query45
+++ QUERY=query45
+++ cp /tmp/tmp.UuY0TCWj7R/query17 /tmp/tpcds/psqlqueries0/query45
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query18
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query18
++++ local TPLNAME=query58.tpl
+++++ basename -s.tpl query58.tpl
++++ local QUERY=query58
++++ echo query58
+++ QUERY=query58
+++ cp /tmp/tmp.UuY0TCWj7R/query18 /tmp/tpcds/psqlqueries0/query58
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query19
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query19
++++ local TPLNAME=query64.tpl
+++++ basename -s.tpl query64.tpl
++++ local QUERY=query64
++++ echo query64
+++ QUERY=query64
+++ cp /tmp/tmp.UuY0TCWj7R/query19 /tmp/tpcds/psqlqueries0/query64
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query20
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query20
++++ local TPLNAME=query36.tpl
+++++ basename -s.tpl query36.tpl
++++ local QUERY=query36
++++ echo query36
+++ QUERY=query36
+++ cp /tmp/tmp.UuY0TCWj7R/query20 /tmp/tpcds/psqlqueries0/query36
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query21
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query21
++++ local TPLNAME=query33.tpl
+++++ basename -s.tpl query33.tpl
++++ local QUERY=query33
++++ echo query33
+++ QUERY=query33
+++ cp /tmp/tmp.UuY0TCWj7R/query21 /tmp/tpcds/psqlqueries0/query33
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query22
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query22
++++ local TPLNAME=query46.tpl
+++++ basename -s.tpl query46.tpl
++++ local QUERY=query46
++++ echo query46
+++ QUERY=query46
+++ cp /tmp/tmp.UuY0TCWj7R/query22 /tmp/tpcds/psqlqueries0/query46
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query23
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query23
++++ local TPLNAME=query62.tpl
+++++ basename -s.tpl query62.tpl
++++ local QUERY=query62
++++ echo query62
+++ QUERY=query62
+++ cp /tmp/tmp.UuY0TCWj7R/query23 /tmp/tpcds/psqlqueries0/query62
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query24
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query24
++++ local TPLNAME=query16.tpl
+++++ basename -s.tpl query16.tpl
++++ local QUERY=query16
++++ echo query16
+++ QUERY=query16
+++ cp /tmp/tmp.UuY0TCWj7R/query24 /tmp/tpcds/psqlqueries0/query16
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query25
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query25
++++ local TPLNAME=query10.tpl
+++++ basename -s.tpl query10.tpl
++++ local QUERY=query10
++++ echo query10
+++ QUERY=query10
+++ cp /tmp/tmp.UuY0TCWj7R/query25 /tmp/tpcds/psqlqueries0/query10
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query26
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query26
++++ local TPLNAME=query63.tpl
+++++ basename -s.tpl query63.tpl
++++ local QUERY=query63
++++ echo query63
+++ QUERY=query63
+++ cp /tmp/tmp.UuY0TCWj7R/query26 /tmp/tpcds/psqlqueries0/query63
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query27
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query27
++++ local TPLNAME=query69.tpl
+++++ basename -s.tpl query69.tpl
++++ local QUERY=query69
++++ echo query69
+++ QUERY=query69
+++ cp /tmp/tmp.UuY0TCWj7R/query27 /tmp/tpcds/psqlqueries0/query69
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query28
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query28
++++ local TPLNAME=query60.tpl
+++++ basename -s.tpl query60.tpl
++++ local QUERY=query60
++++ echo query60
+++ QUERY=query60
+++ cp /tmp/tmp.UuY0TCWj7R/query28 /tmp/tpcds/psqlqueries0/query60
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query29
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query29
++++ local TPLNAME=query59.tpl
+++++ basename -s.tpl query59.tpl
++++ local QUERY=query59
++++ echo query59
+++ QUERY=query59
+++ cp /tmp/tmp.UuY0TCWj7R/query29 /tmp/tpcds/psqlqueries0/query59
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query30
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query30
++++ local TPLNAME=query37.tpl
+++++ basename -s.tpl query37.tpl
++++ local QUERY=query37
++++ echo query37
+++ QUERY=query37
+++ cp /tmp/tmp.UuY0TCWj7R/query30 /tmp/tpcds/psqlqueries0/query37
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query31
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query31
++++ local TPLNAME=query98.tpl
+++++ basename -s.tpl query98.tpl
++++ local QUERY=query98
++++ echo query98
+++ QUERY=query98
+++ cp /tmp/tmp.UuY0TCWj7R/query31 /tmp/tpcds/psqlqueries0/query98
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query32
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query32
++++ local TPLNAME=query85.tpl
+++++ basename -s.tpl query85.tpl
++++ local QUERY=query85
++++ echo query85
+++ QUERY=query85
+++ cp /tmp/tmp.UuY0TCWj7R/query32 /tmp/tpcds/psqlqueries0/query85
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query33
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query33
++++ local TPLNAME=query70.tpl
+++++ basename -s.tpl query70.tpl
++++ local QUERY=query70
++++ echo query70
+++ QUERY=query70
+++ cp /tmp/tmp.UuY0TCWj7R/query33 /tmp/tpcds/psqlqueries0/query70
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query34
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query34
++++ local TPLNAME=query67.tpl
+++++ basename -s.tpl query67.tpl
++++ local QUERY=query67
++++ echo query67
+++ QUERY=query67
+++ cp /tmp/tmp.UuY0TCWj7R/query34 /tmp/tpcds/psqlqueries0/query67
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query35
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query35
++++ local TPLNAME=query28.tpl
+++++ basename -s.tpl query28.tpl
++++ local QUERY=query28
++++ echo query28
+++ QUERY=query28
+++ cp /tmp/tmp.UuY0TCWj7R/query35 /tmp/tpcds/psqlqueries0/query28
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query36
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query36
++++ local TPLNAME=query81.tpl
+++++ basename -s.tpl query81.tpl
++++ local QUERY=query81
++++ echo query81
+++ QUERY=query81
+++ cp /tmp/tmp.UuY0TCWj7R/query36 /tmp/tpcds/psqlqueries0/query81
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query37
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query37
++++ local TPLNAME=query97.tpl
+++++ basename -s.tpl query97.tpl
++++ local QUERY=query97
++++ echo query97
+++ QUERY=query97
+++ cp /tmp/tmp.UuY0TCWj7R/query37 /tmp/tpcds/psqlqueries0/query97
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query38
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query38
++++ local TPLNAME=query66.tpl
+++++ basename -s.tpl query66.tpl
++++ local QUERY=query66
++++ echo query66
+++ QUERY=query66
+++ cp /tmp/tmp.UuY0TCWj7R/query38 /tmp/tpcds/psqlqueries0/query66
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query39
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query39
++++ local TPLNAME=query90.tpl
+++++ basename -s.tpl query90.tpl
++++ local QUERY=query90
++++ echo query90
+++ QUERY=query90
+++ cp /tmp/tmp.UuY0TCWj7R/query39 /tmp/tpcds/psqlqueries0/query90
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query40
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query40
++++ local TPLNAME=query17.tpl
+++++ basename -s.tpl query17.tpl
++++ local QUERY=query17
++++ echo query17
+++ QUERY=query17
+++ cp /tmp/tmp.UuY0TCWj7R/query40 /tmp/tpcds/psqlqueries0/query17
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query41
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query41
++++ local TPLNAME=query47.tpl
+++++ basename -s.tpl query47.tpl
++++ local QUERY=query47
++++ echo query47
+++ QUERY=query47
+++ cp /tmp/tmp.UuY0TCWj7R/query41 /tmp/tpcds/psqlqueries0/query47
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query42
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query42
++++ local TPLNAME=query95.tpl
+++++ basename -s.tpl query95.tpl
++++ local QUERY=query95
++++ echo query95
+++ QUERY=query95
+++ cp /tmp/tmp.UuY0TCWj7R/query42 /tmp/tpcds/psqlqueries0/query95
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query43
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query43
++++ local TPLNAME=query92.tpl
+++++ basename -s.tpl query92.tpl
++++ local QUERY=query92
++++ echo query92
+++ QUERY=query92
+++ cp /tmp/tmp.UuY0TCWj7R/query43 /tmp/tpcds/psqlqueries0/query92
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query44
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query44
++++ local TPLNAME=query3.tpl
+++++ basename -s.tpl query3.tpl
++++ local QUERY=query3
++++ echo query3
+++ QUERY=query3
+++ cp /tmp/tmp.UuY0TCWj7R/query44 /tmp/tpcds/psqlqueries0/query3
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query45
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query45
++++ local TPLNAME=query51.tpl
+++++ basename -s.tpl query51.tpl
++++ local QUERY=query51
++++ echo query51
+++ QUERY=query51
+++ cp /tmp/tmp.UuY0TCWj7R/query45 /tmp/tpcds/psqlqueries0/query51
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query46
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query46
++++ local TPLNAME=query35.tpl
+++++ basename -s.tpl query35.tpl
++++ local QUERY=query35
++++ echo query35
+++ QUERY=query35
+++ cp /tmp/tmp.UuY0TCWj7R/query46 /tmp/tpcds/psqlqueries0/query35
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query47
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query47
++++ local TPLNAME=query49.tpl
+++++ basename -s.tpl query49.tpl
++++ local QUERY=query49
++++ echo query49
+++ QUERY=query49
+++ cp /tmp/tmp.UuY0TCWj7R/query47 /tmp/tpcds/psqlqueries0/query49
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query48
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query48
++++ local TPLNAME=query9.tpl
+++++ basename -s.tpl query9.tpl
++++ local QUERY=query9
++++ echo query9
+++ QUERY=query9
+++ cp /tmp/tmp.UuY0TCWj7R/query48 /tmp/tpcds/psqlqueries0/query9
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query49
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query49
++++ local TPLNAME=query31.tpl
+++++ basename -s.tpl query31.tpl
++++ local QUERY=query31
++++ echo query31
+++ QUERY=query31
+++ cp /tmp/tmp.UuY0TCWj7R/query49 /tmp/tpcds/psqlqueries0/query31
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query50
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query50
++++ local TPLNAME=query11.tpl
+++++ basename -s.tpl query11.tpl
++++ local QUERY=query11
++++ echo query11
+++ QUERY=query11
+++ cp /tmp/tmp.UuY0TCWj7R/query50 /tmp/tpcds/psqlqueries0/query11
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query51
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query51
++++ local TPLNAME=query93.tpl
+++++ basename -s.tpl query93.tpl
++++ local QUERY=query93
++++ echo query93
+++ QUERY=query93
+++ cp /tmp/tmp.UuY0TCWj7R/query51 /tmp/tpcds/psqlqueries0/query93
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query52
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query52
++++ local TPLNAME=query29.tpl
+++++ basename -s.tpl query29.tpl
++++ local QUERY=query29
++++ echo query29
+++ QUERY=query29
+++ cp /tmp/tmp.UuY0TCWj7R/query52 /tmp/tpcds/psqlqueries0/query29
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query53
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query53
++++ local TPLNAME=query38.tpl
+++++ basename -s.tpl query38.tpl
++++ local QUERY=query38
++++ echo query38
+++ QUERY=query38
+++ cp /tmp/tmp.UuY0TCWj7R/query53 /tmp/tpcds/psqlqueries0/query38
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query54
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query54
++++ local TPLNAME=query22.tpl
+++++ basename -s.tpl query22.tpl
++++ local QUERY=query22
++++ echo query22
+++ QUERY=query22
+++ cp /tmp/tmp.UuY0TCWj7R/query54 /tmp/tpcds/psqlqueries0/query22
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query55
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query55
++++ local TPLNAME=query89.tpl
+++++ basename -s.tpl query89.tpl
++++ local QUERY=query89
++++ echo query89
+++ QUERY=query89
+++ cp /tmp/tmp.UuY0TCWj7R/query55 /tmp/tpcds/psqlqueries0/query89
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query56
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query56
++++ local TPLNAME=query15.tpl
+++++ basename -s.tpl query15.tpl
++++ local QUERY=query15
++++ echo query15
+++ QUERY=query15
+++ cp /tmp/tmp.UuY0TCWj7R/query56 /tmp/tpcds/psqlqueries0/query15
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query57
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query57
++++ local TPLNAME=query6.tpl
+++++ basename -s.tpl query6.tpl
++++ local QUERY=query6
++++ echo query6
+++ QUERY=query6
+++ cp /tmp/tmp.UuY0TCWj7R/query57 /tmp/tpcds/psqlqueries0/query6
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query58
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query58
++++ local TPLNAME=query52.tpl
+++++ basename -s.tpl query52.tpl
++++ local QUERY=query52
++++ echo query52
+++ QUERY=query52
+++ cp /tmp/tmp.UuY0TCWj7R/query58 /tmp/tpcds/psqlqueries0/query52
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query59
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query59
++++ local TPLNAME=query50.tpl
+++++ basename -s.tpl query50.tpl
++++ local QUERY=query50
++++ echo query50
+++ QUERY=query50
+++ cp /tmp/tmp.UuY0TCWj7R/query59 /tmp/tpcds/psqlqueries0/query50
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query60
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query60
++++ local TPLNAME=query42.tpl
+++++ basename -s.tpl query42.tpl
++++ local QUERY=query42
++++ echo query42
+++ QUERY=query42
+++ cp /tmp/tmp.UuY0TCWj7R/query60 /tmp/tpcds/psqlqueries0/query42
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query61
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query61
++++ local TPLNAME=query41.tpl
+++++ basename -s.tpl query41.tpl
++++ local QUERY=query41
++++ echo query41
+++ QUERY=query41
+++ cp /tmp/tmp.UuY0TCWj7R/query61 /tmp/tpcds/psqlqueries0/query41
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query62
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query62
++++ local TPLNAME=query8.tpl
+++++ basename -s.tpl query8.tpl
++++ local QUERY=query8
++++ echo query8
+++ QUERY=query8
+++ cp /tmp/tmp.UuY0TCWj7R/query62 /tmp/tpcds/psqlqueries0/query8
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query63
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query63
++++ local TPLNAME=query12.tpl
+++++ basename -s.tpl query12.tpl
++++ local QUERY=query12
++++ echo query12
+++ QUERY=query12
+++ cp /tmp/tmp.UuY0TCWj7R/query63 /tmp/tpcds/psqlqueries0/query12
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query64
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query64
++++ local TPLNAME=query20.tpl
+++++ basename -s.tpl query20.tpl
++++ local QUERY=query20
++++ echo query20
+++ QUERY=query20
+++ cp /tmp/tmp.UuY0TCWj7R/query64 /tmp/tpcds/psqlqueries0/query20
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query65
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query65
++++ local TPLNAME=query88.tpl
+++++ basename -s.tpl query88.tpl
++++ local QUERY=query88
++++ echo query88
+++ QUERY=query88
+++ cp /tmp/tmp.UuY0TCWj7R/query65 /tmp/tpcds/psqlqueries0/query88
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query66
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query66
++++ local TPLNAME=query82.tpl
+++++ basename -s.tpl query82.tpl
++++ local QUERY=query82
++++ echo query82
+++ QUERY=query82
+++ cp /tmp/tmp.UuY0TCWj7R/query66 /tmp/tpcds/psqlqueries0/query82
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query67
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query67
++++ local TPLNAME=query23.tpl
+++++ basename -s.tpl query23.tpl
++++ local QUERY=query23
++++ echo query23
+++ QUERY=query23
+++ cp /tmp/tmp.UuY0TCWj7R/query67 /tmp/tpcds/psqlqueries0/query23
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query68
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query68
++++ local TPLNAME=query14.tpl
+++++ basename -s.tpl query14.tpl
++++ local QUERY=query14
++++ echo query14
+++ QUERY=query14
+++ cp /tmp/tmp.UuY0TCWj7R/query68 /tmp/tpcds/psqlqueries0/query14
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query69
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query69
++++ local TPLNAME=query57.tpl
+++++ basename -s.tpl query57.tpl
++++ local QUERY=query57
++++ echo query57
+++ QUERY=query57
+++ cp /tmp/tmp.UuY0TCWj7R/query69 /tmp/tpcds/psqlqueries0/query57
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query70
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query70
++++ local TPLNAME=query65.tpl
+++++ basename -s.tpl query65.tpl
++++ local QUERY=query65
++++ echo query65
+++ QUERY=query65
+++ cp /tmp/tmp.UuY0TCWj7R/query70 /tmp/tpcds/psqlqueries0/query65
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query71
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query71
++++ local TPLNAME=query71.tpl
+++++ basename -s.tpl query71.tpl
++++ local QUERY=query71
++++ echo query71
+++ QUERY=query71
+++ cp /tmp/tmp.UuY0TCWj7R/query71 /tmp/tpcds/psqlqueries0/query71
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query72
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query72
++++ local TPLNAME=query34.tpl
+++++ basename -s.tpl query34.tpl
++++ local QUERY=query34
++++ echo query34
+++ QUERY=query34
+++ cp /tmp/tmp.UuY0TCWj7R/query72 /tmp/tpcds/psqlqueries0/query34
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query73
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query73
++++ local TPLNAME=query48.tpl
+++++ basename -s.tpl query48.tpl
++++ local QUERY=query48
++++ echo query48
+++ QUERY=query48
+++ cp /tmp/tmp.UuY0TCWj7R/query73 /tmp/tpcds/psqlqueries0/query48
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query74
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query74
++++ local TPLNAME=query30.tpl
+++++ basename -s.tpl query30.tpl
++++ local QUERY=query30
++++ echo query30
+++ QUERY=query30
+++ cp /tmp/tmp.UuY0TCWj7R/query74 /tmp/tpcds/psqlqueries0/query30
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query75
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query75
++++ local TPLNAME=query74.tpl
+++++ basename -s.tpl query74.tpl
++++ local QUERY=query74
++++ echo query74
+++ QUERY=query74
+++ cp /tmp/tmp.UuY0TCWj7R/query75 /tmp/tpcds/psqlqueries0/query74
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query76
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query76
++++ local TPLNAME=query87.tpl
+++++ basename -s.tpl query87.tpl
++++ local QUERY=query87
++++ echo query87
+++ QUERY=query87
+++ cp /tmp/tmp.UuY0TCWj7R/query76 /tmp/tpcds/psqlqueries0/query87
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query77
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query77
++++ local TPLNAME=query77.tpl
+++++ basename -s.tpl query77.tpl
++++ local QUERY=query77
++++ echo query77
+++ QUERY=query77
+++ cp /tmp/tmp.UuY0TCWj7R/query77 /tmp/tpcds/psqlqueries0/query77
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query78
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query78
++++ local TPLNAME=query73.tpl
+++++ basename -s.tpl query73.tpl
++++ local QUERY=query73
++++ echo query73
+++ QUERY=query73
+++ cp /tmp/tmp.UuY0TCWj7R/query78 /tmp/tpcds/psqlqueries0/query73
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query79
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query79
++++ local TPLNAME=query84.tpl
+++++ basename -s.tpl query84.tpl
++++ local QUERY=query84
++++ echo query84
+++ QUERY=query84
+++ cp /tmp/tmp.UuY0TCWj7R/query79 /tmp/tpcds/psqlqueries0/query84
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query80
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query80
++++ local TPLNAME=query54.tpl
+++++ basename -s.tpl query54.tpl
++++ local QUERY=query54
++++ echo query54
+++ QUERY=query54
+++ cp /tmp/tmp.UuY0TCWj7R/query80 /tmp/tpcds/psqlqueries0/query54
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query81
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query81
++++ local TPLNAME=query55.tpl
+++++ basename -s.tpl query55.tpl
++++ local QUERY=query55
++++ echo query55
+++ QUERY=query55
+++ cp /tmp/tmp.UuY0TCWj7R/query81 /tmp/tpcds/psqlqueries0/query55
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query82
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query82
++++ local TPLNAME=query56.tpl
+++++ basename -s.tpl query56.tpl
++++ local QUERY=query56
++++ echo query56
+++ QUERY=query56
+++ cp /tmp/tmp.UuY0TCWj7R/query82 /tmp/tpcds/psqlqueries0/query56
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query83
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query83
++++ local TPLNAME=query2.tpl
+++++ basename -s.tpl query2.tpl
++++ local QUERY=query2
++++ echo query2
+++ QUERY=query2
+++ cp /tmp/tmp.UuY0TCWj7R/query83 /tmp/tpcds/psqlqueries0/query2
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query84
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query84
++++ local TPLNAME=query26.tpl
+++++ basename -s.tpl query26.tpl
++++ local QUERY=query26
++++ echo query26
+++ QUERY=query26
+++ cp /tmp/tmp.UuY0TCWj7R/query84 /tmp/tpcds/psqlqueries0/query26
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query85
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query85
++++ local TPLNAME=query40.tpl
+++++ basename -s.tpl query40.tpl
++++ local QUERY=query40
++++ echo query40
+++ QUERY=query40
+++ cp /tmp/tmp.UuY0TCWj7R/query85 /tmp/tpcds/psqlqueries0/query40
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query86
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query86
++++ local TPLNAME=query72.tpl
+++++ basename -s.tpl query72.tpl
++++ local QUERY=query72
++++ echo query72
+++ QUERY=query72
+++ cp /tmp/tmp.UuY0TCWj7R/query86 /tmp/tpcds/psqlqueries0/query72
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query87
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query87
++++ local TPLNAME=query53.tpl
+++++ basename -s.tpl query53.tpl
++++ local QUERY=query53
++++ echo query53
+++ QUERY=query53
+++ cp /tmp/tmp.UuY0TCWj7R/query87 /tmp/tpcds/psqlqueries0/query53
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query88
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query88
++++ local TPLNAME=query79.tpl
+++++ basename -s.tpl query79.tpl
++++ local QUERY=query79
++++ echo query79
+++ QUERY=query79
+++ cp /tmp/tmp.UuY0TCWj7R/query88 /tmp/tpcds/psqlqueries0/query79
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query89
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query89
++++ local TPLNAME=query18.tpl
+++++ basename -s.tpl query18.tpl
++++ local QUERY=query18
++++ echo query18
+++ QUERY=query18
+++ cp /tmp/tmp.UuY0TCWj7R/query89 /tmp/tpcds/psqlqueries0/query18
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query90
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query90
++++ local TPLNAME=query13.tpl
+++++ basename -s.tpl query13.tpl
++++ local QUERY=query13
++++ echo query13
+++ QUERY=query13
+++ cp /tmp/tmp.UuY0TCWj7R/query90 /tmp/tpcds/psqlqueries0/query13
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query91
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query91
++++ local TPLNAME=query24.tpl
+++++ basename -s.tpl query24.tpl
++++ local QUERY=query24
++++ echo query24
+++ QUERY=query24
+++ cp /tmp/tmp.UuY0TCWj7R/query91 /tmp/tpcds/psqlqueries0/query24
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query92
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query92
++++ local TPLNAME=query4.tpl
+++++ basename -s.tpl query4.tpl
++++ local QUERY=query4
++++ echo query4
+++ QUERY=query4
+++ cp /tmp/tmp.UuY0TCWj7R/query92 /tmp/tpcds/psqlqueries0/query4
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query93
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query93
++++ local TPLNAME=query99.tpl
+++++ basename -s.tpl query99.tpl
++++ local QUERY=query99
++++ echo query99
+++ QUERY=query99
+++ cp /tmp/tmp.UuY0TCWj7R/query93 /tmp/tpcds/psqlqueries0/query99
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query94
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query94
++++ local TPLNAME=query68.tpl
+++++ basename -s.tpl query68.tpl
++++ local QUERY=query68
++++ echo query68
+++ QUERY=query68
+++ cp /tmp/tmp.UuY0TCWj7R/query94 /tmp/tpcds/psqlqueries0/query68
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query95
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query95
++++ local TPLNAME=query83.tpl
+++++ basename -s.tpl query83.tpl
++++ local QUERY=query83
++++ echo query83
+++ QUERY=query83
+++ cp /tmp/tmp.UuY0TCWj7R/query95 /tmp/tpcds/psqlqueries0/query83
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query96
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query96
++++ local TPLNAME=query61.tpl
+++++ basename -s.tpl query61.tpl
++++ local QUERY=query61
++++ echo query61
+++ QUERY=query61
+++ cp /tmp/tmp.UuY0TCWj7R/query96 /tmp/tpcds/psqlqueries0/query61
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query97
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query97
++++ local TPLNAME=query5.tpl
+++++ basename -s.tpl query5.tpl
++++ local QUERY=query5
++++ echo query5
+++ QUERY=query5
+++ cp /tmp/tmp.UuY0TCWj7R/query97 /tmp/tpcds/psqlqueries0/query5
+++ for f in $TEMPD/query*
++++ getqueryname /tmp/tmp.UuY0TCWj7R/query98
+++++ grep -o '[^ ]*\.tpl' /tmp/tmp.UuY0TCWj7R/query98
++++ local TPLNAME=query76.tpl
+++++ basename -s.tpl query76.tpl
++++ local QUERY=query76
++++ echo query76
+++ QUERY=query76
+++ cp /tmp/tmp.UuY0TCWj7R/query98 /tmp/tpcds/psqlqueries0/query76
+++ rm -rf /tmp/tmp.UuY0TCWj7R
+++ cp '/tmp/tmp.UuY0TCWj7R/*' /tmp/tpcds/psqlqueries0
cp: nie można wykonać stat na '/tmp/tmp.UuY0TCWj7R/*': No such file or directory
+++ cd /home/sbartkowski/work/mytpcds
+++ runsinglequery query5
+++ local qfile=/tmp/tpcds/psqlqueries0/query5
+++ existfile /tmp/tpcds/psqlqueries0/query5
+++ local -r file=/tmp/tpcds/psqlqueries0/query5
+++ '[' -f /tmp/tpcds/psqlqueries0/query5 ']'
++++ getqueryname /tmp/tpcds/psqlqueries0/query5
+++++ grep -o '[^ ]*\.tpl' /tmp/tpcds/psqlqueries0/query5
++++ local TPLNAME=query5.tpl
+++++ basename -s.tpl query5.tpl
++++ local QUERY=query5
++++ echo query5
+++ local -r QUERY=query5
+++ local -r TPLNAME=query5.tpl
+++ RESULTSET=/tmp/tpcds/psqlresult0/query5.res
+++ rm -f /tmp/tpcds/psqlresult0/query5.res
++++ getsec
+++++ date +%s
++++ echo 1639401652
+++ local -r BEG=1639401652
+++ [[ '' =~ .*query5.tpl.* ]]
+++ '[' 0 -eq 0 ']'
+++ log '/tmp/tpcds/psqlqueries0/query5  started ...'
+++ '[' -n /tmp/tpcds/psqllog/mytcpds.log ']'
+++ echo /tmp/tpcds/psqlqueries0/query5 started ...
+++ echo '/tmp/tpcds/psqlqueries0/query5  started ...'
+++ '[' 0 -ne 0 ']'
++++ crtemp
++++ required_var TMPSTORE
++++ local -r VARIABLE=TMPSTORE
++++ '[' -z /tmp/tmp.pPi7zf2GA7 ']'
+++++ mktemp
++++ local -r TMP=/tmp/tmp.WyeIjzJSCN
++++ echo /tmp/tmp.WyeIjzJSCN
++++ echo /tmp/tmp.WyeIjzJSCN
+++ local TMP=/tmp/tmp.WyeIjzJSCN
+++ modifyquery /tmp/tpcds/psqlqueries0/query5 /tmp/tmp.WyeIjzJSCN
+++ local -r qfile=/tmp/tpcds/psqlqueries0/query5
+++ local -r TMP=/tmp/tmp.WyeIjzJSCN
++++ crtemp
++++ required_var TMPSTORE
++++ local -r VARIABLE=TMPSTORE
++++ '[' -z /tmp/tmp.pPi7zf2GA7 ']'
+++++ mktemp
++++ local -r TMP=/tmp/tmp.KbW3ItsNUt
++++ echo /tmp/tmp.KbW3ItsNUt
++++ echo /tmp/tmp.KbW3ItsNUt
+++ local TMP1=/tmp/tmp.KbW3ItsNUt
++++ crtemp
++++ required_var TMPSTORE
++++ local -r VARIABLE=TMPSTORE
++++ '[' -z /tmp/tmp.pPi7zf2GA7 ']'
+++++ mktemp
++++ local -r TMP=/tmp/tmp.oyfSGZg58R
++++ echo /tmp/tmp.oyfSGZg58R
++++ echo /tmp/tmp.oyfSGZg58R
+++ local TMP2=/tmp/tmp.oyfSGZg58R
++++ crtemp
++++ required_var TMPSTORE
++++ local -r VARIABLE=TMPSTORE
++++ '[' -z /tmp/tmp.pPi7zf2GA7 ']'
+++++ mktemp
++++ local -r TMP=/tmp/tmp.haVlXcWuJ6
++++ echo /tmp/tmp.haVlXcWuJ6
++++ echo /tmp/tmp.haVlXcWuJ6
+++ local TMP3=/tmp/tmp.haVlXcWuJ6
+++ sed s/c_last_review_date_sk/c_last_review_date/gi /tmp/tpcds/psqlqueries0/query5
+++ sed 's/cast ('\''/cast('\''/g'
+++ sed 's/sum (/sum(/g'
+++ grep query2.tpl /tmp/tmp.WyeIjzJSCN
+++ grep query49.tpl /tmp/tmp.WyeIjzJSCN
+++ grep query72.tpl /tmp/tmp.WyeIjzJSCN
+++ grep query14.tpl /tmp/tmp.WyeIjzJSCN
+++ grep query77.tpl /tmp/tmp.WyeIjzJSCN
+++ grep query23.tpl /tmp/tmp.WyeIjzJSCN
+++ '[' -n '' ']'
+++ '[' -n '' ']'
+++ '[' -n X ']'
+++ sed s/days//g /tmp/tmp.WyeIjzJSCN
+++ cp /tmp/tmp.KbW3ItsNUt /tmp/tmp.WyeIjzJSCN
+++ '[' -n '' ']'
+++ '[' -n '' ']'
+++ '[' psql = mssql ']'
++++ mktemp -d
+++ local -r CDIR=/tmp/tmp.BYj4zg1a67
+++ csplit /tmp/tmp.WyeIjzJSCN '/;/1' -f /tmp/tmp.BYj4zg1a67/query -s
+++ find /tmp/tmp.BYj4zg1a67/query00 /tmp/tmp.BYj4zg1a67/query01 -size 0c -exec rm '{}' ';'
+++ find /tmp/tmp.BYj4zg1a67/query00 /tmp/tmp.BYj4zg1a67/query01 -size 1c -exec rm '{}' ';'
+++ find /tmp/tmp.BYj4zg1a67/query00 -size 2c -exec rm '{}' ';'
++++ crtemp
++++ required_var TMPSTORE
++++ local -r VARIABLE=TMPSTORE
++++ '[' -z /tmp/tmp.pPi7zf2GA7 ']'
+++++ mktemp
++++ local -r TMP=/tmp/tmp.lQ0Ba4RDq7
++++ echo /tmp/tmp.lQ0Ba4RDq7
++++ echo /tmp/tmp.lQ0Ba4RDq7
+++ local -r OUTPUTQUERY=/tmp/tmp.lQ0Ba4RDq7
+++ for f in $CDIR/query*
+++ runquery /tmp/tmp.BYj4zg1a67/query00
+++ echo /tmp/tmp.BYj4zg1a67/query00
+++ return 0
+++ RES=0
+++ cat /tmp/tpcds/psqlresult0/query5.res
+++ echo ---------
+++ rm -rf /tmp/tmp.BYj4zg1a67
+++ cp /tmp/tmp.lQ0Ba4RDq7 /tmp/tpcds/psqlresult0/query5.res
+++ '[' 0 -ne 0 ']'
+++ RESMESS=PASSED
+++ RESLINES=
+++ '[' -n '' ']'
+++ printresultline 1639401652 query5 PASSED ''
+++ local -r BEG=1639401652
+++ local -r QUERY=query5
+++ local -r RES=PASSED
+++ local -r RESMATCH=
+++ '[' -z PASSED ']'
+++ '[' -z '' ']'
++++ calculatesec 1639401652
++++ local -r before=1639401652
+++++ getsec
++++++ date +%s
+++++ echo 1639401652
++++ local -r after=1639401652
+++++ expr 1639401652 - 1639401652
++++ echo 0
+++ printreportline /home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/psql.result0 query5 7 0 4 PASSED 7
+++ local -r REPORTFILE=/home/sbartkowski/work/DSGen-software-code-3.2.0rc1/work/psqlqueries/psql.result0
+++ shift
+++ echo -n '|'
+++ true
+++ '[' -z query5 ']'
++++ tsp query5 7
++++ local -r MESS=query5
++++ local -r LEN=7
+++++ printf %-7s query5
++++ local -r 'OUT=query5 '
++++ echo 'query5 '
+++ O='query5 '
+++ echo -n ' query5  |'
+++ shift 2
+++ true
+++ '[' -z 0 ']'
++++ tsp 0 4
++++ local -r MESS=0
++++ local -r LEN=4
+++++ printf %-4s 0
++++ local -r 'OUT=0   '
++++ echo '0   '
+++ O='0   '
+++ echo -n ' 0    |'
+++ shift 2
+++ true
+++ '[' -z PASSED ']'
++++ tsp PASSED 7
++++ local -r MESS=PASSED
++++ local -r LEN=7
+++++ printf %-7s PASSED
++++ local -r 'OUT=PASSED '
++++ echo 'PASSED '
+++ O='PASSED '
+++ echo -n ' PASSED  |'
+++ shift 2
+++ true
+++ '[' -z '' ']'
+++ break
+++ echo
+++ return
+++ return 0
+++ removetemp
+++ read rmfile
+++ rm /tmp/tmp.L94bwo6HQh
+++ read rmfile
+++ rm /tmp/tmp.WyeIjzJSCN
+++ read rmfile
+++ rm /tmp/tmp.KbW3ItsNUt
+++ read rmfile
+++ rm /tmp/tmp.oyfSGZg58R
+++ read rmfile
+++ rm /tmp/tmp.haVlXcWuJ6
+++ read rmfile
+++ rm /tmp/tmp.lQ0Ba4RDq7
+++ read rmfile
+++ rm /tmp/tmp.pPi7zf2GA7
