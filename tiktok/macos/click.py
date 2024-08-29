#!/Library/Frameworks/Python.framework/Versions/3.12/bin/python3

import time
import random
import pyautogui

width, height = pyautogui.size()
print(width, height)

x, y = pyautogui.position()
print("00000 x: %d, y: %d", x,y)
while True:
  # 移动鼠标到屏幕上的(x, y)位置
  x = int(width*0.35) + random.randint(0, int(width/20))
  y = int(height*0.5) + random.randint(0, int(height/20))
  #print("x: %d, y: %d", x,y)
  # 在(x, y)位置单击
  pyautogui.click(x, y)
  pyautogui.click()
  time.sleep(random.uniform(0.3, 0.4))

