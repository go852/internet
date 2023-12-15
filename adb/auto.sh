#!/bin/sh

while getopts ":s:" opt
do
  case $opt in
  s)
    ID=$OPTARG
    ;;
  esac
done

if [ $ID ]; then
  OPT_ID="-s $ID"
fi
ADB="adb $OPT_ID"

XMAX=$($ADB shell wm size | awk -F ': ' '{print $2}' | sed 's/x.*//')
YMAX=$($ADB shell wm size | awk -F ': ' '{print $2}' | sed 's/.*x//')
echo "XMAX: $XMAX, YMAX:$YMAX"

swipe(){
  echo $ADB shell input swipe $1 $2 $3 $4
  $ADB shell input swipe $1 $2 $3 $4
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
