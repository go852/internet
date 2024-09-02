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
      time.sleep(1)
      continue

    x = int(width*0.35) + random.randint(0, int(width/500))
    y = int(height*0.5) + random.randint(0, int(height/500))
    print("x: %d, y: %d" %(x,y))
  
    #pyautogui.click(x, y)
    #pyautogui.click()
    pyautogui.press('z')
    total_number += 1
    print("点赞用时：%.1f秒,  次数：%d" % (total_seconds, total_number))
    if total_number % 1000 == 0:
      n = 120
      print("休息%d秒...\n"%n)
      time.sleep(n)
    else:
      seconds = random.uniform(0.02, 0.05)
      total_seconds += seconds
      time.sleep(seconds)

autoclick(50000)
