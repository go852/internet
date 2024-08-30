#!/Library/Frameworks/Python.framework/Versions/3.12/bin/python3

import time
import random
import pyautogui

def get_current_app():
  import AppKit
  NSWorkspace = AppKit.NSWorkspace.sharedWorkspace()
  active_app_name = NSWorkspace.activeApplication()['NSApplicationName']
  return active_app_name

def autoclick(n):
  total_number = 0
  total_seconds = 0
  width, height = pyautogui.size()
  print("屏幕像素: ", width, height)

  while True:
    if get_current_app() != "抖音":
      continue

    x = int(width*0.35) + random.randint(0, int(width/100))
    y = int(height*0.5) + random.randint(0, int(height/100))
    print("x: %d, y: %d" %(x,y))
  
    pyautogui.click(x, y)
    pyautogui.click()
    total_number += 1
    print("点赞用时：%.1f秒,  次数：%d" % (total_seconds, total_number))
    if total_number % 1000 == 0:
      time.sleep(300)
    else:
      seconds = random.uniform(0.1, 0.2)
      total_seconds += seconds
      time.sleep(seconds)

autoclick(50000)
