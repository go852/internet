#!/bin/sh

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

ADB="adb"
$ADB start-server
if [ $ID ]; then
  OPT_ID="-s $ID"
fi
ADB="$ADB $OPT_ID"

ACTIVITIES="
  com.ss.android.ugc.aweme.lite/com.ss.android.ugc.aweme.splash.SplashActivity
  com.ss.android.ugc.live/com.ss.android.ugc.aweme.splash.SplashActivity
  com.ss.android.article.lite/com.ss.android.article.lite.activity.SplashActivity
  com.dragon.read/com.dragon.read.reader.ui.ReaderActivity
  com.sankuai.meituan/com.meituan.android.pt.homepage.activity.MainActivity
"

SWIPEUP_APPS="ss.android.ugc.aweme.lite ss.android.ugc.live sankuai.meituan ss.android.article.lite cat.readall"
SWIPELEFT_APPS="dragon.read xs.fm" 

swipe(){
  #echo $ADB shell input swipe $1 $2 $3 $4
  $ADB shell input swipe $1 $2 $3 $4
}

swipe_left(){
  y1=$((YMAX * (RANDOM % 10 + 50) / 100))
  y2=$((y1 + YMAX * (RANDOM % 5) / 100))
  x1=$((XMAX * (RANDOM % 10 + 50) / 100))
  x2=$((x1 - XMAX * (RANDOM % 8 + 15) / 100))
  echo "swipe_left: $x1 $y1 $x2 $y2"
  swipe $x1 $y1 $x2 $y2
}

swipe_up(){
  x1=$((XMAX * (RANDOM % 10 + 45) / 100))
  x2=$((x1 + XMAX * (RANDOM % 5) / 100))
  y1=$((YMAX * (RANDOM % 10 + 70) / 100))
  y2=$((y1 - YMAX * (RANDOM % 5 + 20) / 100))
  echo "swipe_up: $x1 $y1 $x2 $y2"
  swipe $x1 $y1 $x2 $y2
}

get_focus_app(){
  FOCUS_APP=$($ADB shell "dumpsys window | grep mCurrentFocus" | awk -F 'com\.|/' '{print $2}')
  echo $FOCUS_APP
}

switch_app(){
  $ADB shell am start $1
}

process_app(){
  total_time=0
  while [[ $(echo "$total_time / 1" | bc ) -lt 3600 ]]; do
    echo "Foucs Application: $(get_focus_app)"
    for app in $SWIPEUP_APPS; do
      if [[ "$(get_focus_app)" == "$app" ]] ; then 
        t=$(echo "scale=2;$RANDOM % 999 / 5 + 1.27" | bc)
        echo "after $t s..."
        swipe_up 
        sleep $t
        total_time=$(echo "$total_time + $t" | bc)
        echo "total_time: $total_time seconds..."
        echo
      fi
    done
    for app in $SWIPELEFT_APPS; do
      if [[ "$(get_focus_app)" == "$app" ]] ; then 
        t=$(echo "scale=2;$RANDOM % 499 / 5 + 5.27" | bc)
        echo "after $t s..."
        swipe_left
        sleep t
        total_time=$(echo "$total_time + $t" | bc)
        echo "total_time: $total_time seconds..."
        echo
      fi
    done
  done
}

XMAX=$($ADB shell wm size | awk -F ': ' '{print $2}' | sed 's/x.*//')
YMAX=$($ADB shell wm size | awk -F ': ' '{print $2}' | sed 's/.*x//')
echo "XMAX: $XMAX, YMAX:$YMAX"

while true; do
  for activity in $ACTIVITIES; do
    echo
    echo $activity
    switch_app $activity
    process_app
  done
done
