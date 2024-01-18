#!/bin/sh

EVENT="/dev/input/event6 0003 003a 00000016
/dev/input/event6 0003 0035 000002ce
/dev/input/event6 0003 0036 00000598
/dev/input/event6 0003 0039 00000000
/dev/input/event6 0000 0002 00000000
/dev/input/event6 0001 014a 00000001
/dev/input/event6 0000 0000 00000000
/dev/input/event6 0003 003a 00000016
/dev/input/event6 0003 0035 000002ce
/dev/input/event6 0003 0036 00000598
/dev/input/event6 0003 0039 00000000
/dev/input/event6 0000 0002 00000000
/dev/input/event6 0000 0000 00000000
/dev/input/event6 0003 003a 00000016
/dev/input/event6 0003 0035 000002ce
/dev/input/event6 0003 0036 00000598
/dev/input/event6 0003 0039 00000000
/dev/input/event6 0000 0002 00000000
/dev/input/event6 0000 0000 00000000
/dev/input/event6 0003 003a 00000016
/dev/input/event6 0003 0035 000002ce
/dev/input/event6 0003 0036 00000598
/dev/input/event6 0003 0039 00000000
/dev/input/event6 0000 0002 00000000
/dev/input/event6 0000 0000 00000000
/dev/input/event6 0003 003a 00000016
/dev/input/event6 0003 0035 000002e6
/dev/input/event6 0003 0036 0000059b
/dev/input/event6 0003 0039 00000000
/dev/input/event6 0000 0002 00000000
/dev/input/event6 0000 0000 00000000
/dev/input/event6 0000 0002 00000000
/dev/input/event6 0001 014a 00000000
/dev/input/event6 0000 0000 00000000
"



i=1
while true
do
  echo "当前点赞：$i"
  i=$((i+1))
  random_sleep=$(awk -v min=0.2 -v max=0.6 'BEGIN{srand(); print (min+rand()*(max-min))}')
  while read -r line
  do
    echo adb shell sendevent $line
    adb shell sendevent $line
  done < t2.txt
  sleep 5
  #sleep $random_sleep
done

