#!/bin/sh

#ACTIVITIES="com.dragon.read/com.dragon.read.reader.ui.ReaderActivity
ACTIVITIES="
  com.ss.android.ugc.aweme.lite/com.ss.android.ugc.aweme.splash.SplashActivity
  com.ss.android.ugc.live/com.ss.android.ugc.aweme.splash.SplashActivity
  com.sankuai.meituan/com.meituan.android.qtitans.QtitansContainerActivity
  com.ss.android.article.lite/com.ss.android.article.lite.activity.SplashActivity
"

SWIPEUP_APPS="ss.android.ugc.aweme.lite ss.android.ugc.live sankuai.meituan ss.android.article.lite cat.readall"
SWIPELEFT_APPS="dragon.read" 

swipe(){
  #echo $ADB shell input swipe $1 $2 $3 $4
  $ADB shell input swipe $1 $2 $3 $4
}

swipe_left(){
  t=$(echo "scale=2;$RANDOM % 499 / 5 + 5.27" | bc)
  y1=$((YMAX * (RANDOM % 10 + 50) / 100))
  y2=$((y1 + YMAX * (RANDOM % 5) / 100))
  x1=$((XMAX * (RANDOM % 10 + 50) / 100))
  x2=$((x1 - XMAX * (RANDOM % 8 + 15) / 100))
  echo "${t}s: $x1 $y1 $x2 $y2"
  swipe $x1 $y1 $x2 $y2
  sleep $t
}

swipe_up(){
  t=$(echo "scale=2;$RANDOM % 999 / 5 + 1.27" | bc)
  x1=$((XMAX * (RANDOM % 10 + 45) / 100))
  x2=$((x1 + XMAX * (RANDOM % 5) / 100))
  y1=$((YMAX * (RANDOM % 10 + 50) / 100))
  y2=$((y1 - YMAX * (RANDOM % 5 + 30) / 100))
  echo "${t}s: $x1 $y1 $x2 $y2"
  swipe $x1 $y1 $x2 $y2
  sleep $t
}

get_focus_app(){
  FOCUS_APP=$(adb shell "dumpsys activity | grep mCurrentFocus" | awk -F 'com\.|/' '{print $2}')
  echo $FOCUS_APP
}

switch_app(){
  adb shell am start $1
}

process_app(){
  while true; do
    echo "Foucs Application: $(get_focus_app)"
    for app in $SWIPEUP_APPS; do
      if [[ "$(get_focus_app)" == "$app" ]] ; then 
        swipe_up 
      fi
    done
    for app in $SWIPELEFT_APPS; do
      if [[ "$(get_focus_app)" == "$app" ]] ; then 
        swipe_left
      fi
    done
  done
}

while getopts ":s:" opt
do
  case $opt in
  s)
    ID=$OPTARG
    ;;
  *)
    echo "Usage:"
    echo "  -h: help"
    echo "  -s device_id" 
    echo
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

export -f process_app
for activity in $ACTIVITIES; do
  echo
  echo $activity
  #switch_app $activity
  process_app
done
