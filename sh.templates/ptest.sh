source ./conn.rc 

export QUERYTIMEOUT="timeout 4h"

export ORDERBYSTREAM=X

export STREAMNO=$1
[ -z "$STREAMNO" ] && { echo "Provide parameter, STREAM number"; exit 1; }
echo "STREAM number $STREAMNO"

./tpc.sh runqueries
if [ $? -ne 0 ]; then echo "FAILED"; else echo "PASSED"; fi
