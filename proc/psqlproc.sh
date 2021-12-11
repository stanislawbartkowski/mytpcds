# -----------------------------------
# my postgresql command shell functions
# version 1.00
# 2021/12/11 
# -----------------------------------

#set -x
#w

psqlcommand() {
  required_command psql
  local -r command="$1"
  local PORT=""
  [ -n "$DBPORT" ] && PORT="-p $DBPORT"
  export PGPASSWORD=$DBPASSWORD; $QUERYTIMEOUT psql -h $DBHOST $PORT -U $DBUSER -d $DB -t -v "ON_ERROR_STOP=true" -c "$command"
}

psqlscript() {
  required_command psql    
  local PORT=""
  [ -n "$DBPORT" ] && PORT="-p $DBPORT"

  export PGPASSWORD=$DBPASSWORD; $QUERYTIMEOUT psql -h $DBHOST $PORT -U $DBUSER -d $DB -t -v "ON_ERROR_STOP=true" <$1 
}

