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
#     if ($i ~ /^[ ]*[+-]{0,1}[0-9]+[\.]{0,1}[0-9]*$/) printf "%.2f",strtonum($i)
     if ($i ~ /^[ ]*[+-]{0,1}[0-9]+[\.][0-9]*$/) printf "%.2f",strtonum($i)
     else if ($i ~ /^[ ]*[+-]{0,1}\.[0-9]+$/) printf "%.2f",strtonum($i)
     else printf trim($i)
  }
  print ""
}
