# Converts all numbers to number with tw digits after decimal point

BEGIN {
  FS="|"
}

{
  for(i = 1; i <= NF; i++) {
     if (i > 1) printf(" | ");
     if ($i ~ /^[ ]*[+-]{0,1}[0-9]+[\.]{0,1}[0-9]*$/) printf "%.2f",strtonum($i)
     else if ($i ~ /^[ ]*[+-]{0,1}\.[0-9]+$/) printf "%.2f",strtonum($i)
     else printf $i;
  }
  print ""
}
