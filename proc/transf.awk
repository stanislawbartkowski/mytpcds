# Converts all numbers to number with two digits after decimal point

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }

BEGIN {
  FS="|"
}

{
  for(i = 1; i <= NF; i++) {
     if (i > 1) printf(" | ");
     s = trim($i)
     if (s ~ /^[ ]*[+-]{0,1}\.[0]+$/) printf "0"
     else if (s ~ /^[ ]*[+-]{0,1}[0]*\.[0]+$/) printf "0"
     else if (s ~ /^[ ]*[+-]{0,1}[0-9]+[\.][0-9]*$/) printf "%.2f",strtonum(s)
     else if (s ~ /^[ ]*[+-]{0,1}\.[0-9]+$/) printf "%.2f",strtonum(s)
     else printf s
  }
  print ""
}
