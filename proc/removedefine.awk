BEGIN {
    ignore=0
}

/define/ {
    if (!($0 ~ /_LIMIT/)) ignore=1
}

{
    if (ignore == 0) print $0
    if (ignore == 1 && ($0 ~ /;/)) ignore=0
}