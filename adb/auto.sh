#!/bin/sh

ADB_DEVICES=$(adb devices)
echo $ADB_DEVICES

swipe(){
  adb shell input swipe $1 $2 $3 $4
}

for ;; do
  swipe 500 2000 500 1000
  delay 10
done
