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

click(){
  echo $ADB shell input tap $1 $2
  $ADB shell input tap $1 $2
}

while true; do
  y1=$((YMAX * (RANDOM % 10 + 50) / 100))
  x1=$((XMAX * (RANDOM % 10 + 50) / 100))
  echo "tap: $x1 $y1"
  click $x1 $y1
  sleep 1
done
