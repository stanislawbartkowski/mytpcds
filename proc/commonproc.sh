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
  [ -n "$LOGFILE" ] && echo $1 >>$LOGFILE
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