source proc/db2commonproc.sh
source db/db2cliproc.sh

runcreatetable() {
     local -r script=$1
     local -r TMP=`crtemp`
     sed "s/create /create hadoop /g" $script | sed "s/ time /varchar(20)/g" | sed "s/);/) $STOREDAS ;/g" >$TMP
     db2clirun $TMP
 }

required_var STOREDAS
export IFEXIST="IF EXISTS"
export PURGE="PURGE"
export REQUIREDVARS="SCHEMA"

