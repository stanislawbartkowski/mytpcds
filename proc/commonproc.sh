#set -x
#w

# ------------------
# variables
# ------------------

required_var() {
  local -r VARIABLE=$1
  [ -z "${!VARIABLE}" ] && logfail "Need to set environment variable $VARIABLE"
}

required_listofvars() {
  local -r listv=$1
  for value in $listv; do required_var $value; done
}


# -------------------------
# logging
# -------------------------

log() {
  [ -n "$LOGILE" ] && echo $1 >>$LOGFILE
  echo "$1"
}

logfail() {
  log "$1"
  log "Exit immediately"
  exit 1
}

touchlogfile() {
  required_var LOGFILE
  local -r basedir=$(dirname "$LOGILE")
  createbasedir $LOGFILE
  touch $LOGFILE  
}

# -------------------------
# temporary files
# -------------------------

usetemp() {
  export TMPSTORE=`mktemp`
  trap "removetemp" EXIT
}

crtemp() {
  required_var TMPSTORE
  local -r TMP=`mktemp`
  echo $TMP >>$TMPSTORE
  echo $TMP
}

removetemp() {
  while read rmfile;  do rm $rmfile; done <$TMPSTORE
  rm $TMPSTORE
}

# --------------------------
# some procs on file
# --------------------------

existfile() {
  local -r file=$1
  [ -f $file ] || logfail "File $file does not exist"
}

numberoflines() {
  wc --line $1 | cut -d ' ' -f 1
}

createbasedir() {
  local -r file=$1
  local -r basedir=$(dirname "$file")
  mkdir -p $basedir
  [ $? -ne 0 ] && logfail "Cannot create $basedir"
}

# -------------------
# time procs
# -------------------

getsec() {
  echo `date  +"%s"`
}

calculatesec() {
  local -r before=$1
  local -r after=`getsec`
  echo $(expr $after - $before)
}

# --------------------------
# commands
# --------------------------

required_command() {
  local -r COMMAND=$1

  if ! command -v $COMMAND >>$LOGFILE ; then logfail "$COMMAND not installed"; fi
}

required_listofcommands() {
  local -r LISTC=$1
  for value in $LISTC; do required_command $value; done
}

# -----------------------------
# db2 
# -----------------------------

db2clirun() {
    required_var DBPASSWORD

    local -r CONNECTION="DATABASE=$DBNAME;HOSTNAME=$DBHOST;PORT=$DBPORT;UID=$DBUSER;PWD=$DBPASSWORD"
    local -r sqlinput=$1
    local -r ITEMP=`crtemp`
    local -r OTEMP=`crtemp`
    [ -n "$SCHEMA" ] && echo "SET CURRENT SCHEMA $SCHEMA ;" >$ITEMP
    cat $1 >>$ITEMP
    db2cli execsql -statementdelimiter ";" -connstring "$CONNECTION" -inputsql $ITEMP -outfile $OTEMP
    local RES=0
    if grep "ErrorMsg" $OTEMP; then
      log "Error found while executing the query, check logs"
      RES=8
    fi
    cat $OTEMP
    return $RES
}


db2connect() {
   required_command db2
   required_var DBNAME DBUSER DBPASSWORD
   log "Connecting to $DBNAME user $DBUSER"
   db2 connect to $DBNAME user $DBUSER using $DBPASSWORD
   [ $? -ne 0 ] && logfail "Cannot connect to $DBNAME"
   log "Set schema $SCHEMA after connection"
   [[ -n $SCHEMA ]] && db2 "set current schema $SCHEMA"
   [ $? -ne 0 ] && logfail "Cannot set schema $SCHEMA"
}

db2terminate() {
  db2 terminate
}

db2exportcommand() {
  required_var DELIM
  local -r output=$1
  shift
  echo $@
  db2 EXPORT TO $output OF DEL MODIFIED BY NOCHARDEL COLDEL$DELIM $@
  [ $? -ne 0 ] && logfail "Failed while export the statement"
}


