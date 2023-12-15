#!/bin/sh


while getopts ":s:" opt
do
  case $opt in
  s)
    ID=$OPTARG
    ;;
  *)
    exit 1
    ;;
  esac
done

adb start-server

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
  t=$(echo "scale=2;$RANDOM % 1999 / 5 + 1.27" | bc)
  #sign=$(if [ $((RANDOM % 10)) -eq 1 ] ; then echo "1"; else echo "-1"; fi)
  sign="-1"
  x1=$((XMAX * (RANDOM % 10 + 45) / 100))
  y1=$((YMAX * (RANDOM % 10 + 50) / 100))
  x2=$((x1 + XMAX * (RANDOM % 8) / 100))
  y2=$((y1 + sign * YMAX * (RANDOM % 10 + 25) / 100))
  echo "${t}s: $x1 $y1 $x2 $y2"
  swipe $x1 $y1 $x2 $y2
  sleep $t
done
