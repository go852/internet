#!/bin/sh

while getopts ":s:" opt
do
  case $opt in
  s)
    ID=$OPTARG
    ;;
  esac
done

XMAX=1152
YMAX=2376

#ID="PQY5T21122000998"
swipe(){
  if [ $ID ]; then
    OPT_ID="-s $ID"
  fi
  echo adb $OPT_ID shell input swipe $1 $2 $3 $4
  adb $OPT_ID shell input swipe $1 $2 $3 $4
}

while true; do
  t=$(echo "scale=2;$RANDOM % 3999 / 10 + 3.27" | bc)
  x1=$((XMAX * (RANDOM % 10 + 45) / 100))
  y1=$((YMAX * (RANDOM % 10 + 80) / 100))
  x2=$((x1 + XMAX * (RANDOM % 10) / 100))
  y2=$((y1 - YMAX * (RANDOM % 30 + 30) / 100))
  echo "${t}s: $x1 $y1 $x2 $y2"
  swipe $x1 $y1 $x2 $y2
  sleep $t
done
