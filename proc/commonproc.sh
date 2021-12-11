# ----------------------------------
# my bash shell common utilitities
# version: 1.00
# 2021/11/11
# 2021/12/01 - COLDEL added, logfile
# ----------------------------------

#set -x
#w

# ------------------
# variables
# ------------------

REPDEL='|'
COLDEL=${COLDEL:-|}

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

logfile() {
  [ -n "$LOGFILE" ] && cat $1 >>$LOGFILE
  cat $1
}

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

execute_withlog() {
    local -r CMD="$@"
    # important: some command are assuming the first line in the output is not relevant and remove it
    # do not remove this log $CMD below
    log "$CMD"
    eval $CMD
    if [ $? -ne 0 ]; then
        # log CMD again, it can preceded by bunch of logs
        log "$CMD"
        logfail "Job failed"
    fi
}

# -------------------------
# misc
# -------------------------

trim() {
    local var="$1"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"   
    printf '%s' "$var"
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

getdate() {
    echo `date +"%Y-%m-%d %H-%M-%S"`
}

# -----------------------
# formated result table
# -----------------------


tsp() {
    local -r MESS="$1"
    local -r LEN=$2
    local -r OUT=`printf "%-${LEN}s" "$MESS"`
    echo "$OUT"
}

printreportline() {
    local -r REPORTFILE=$1
    shift
    echo -n $REPDEL >>$REPORTFILE
    while true; do
        [ -z "$1" ] && break
        O=`tsp "$1" $2`
        echo -n " $O $REPDEL" >>$REPORTFILE
        shift 2
    done
    echo >>$REPORTFILE
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