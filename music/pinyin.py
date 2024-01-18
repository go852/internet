#!/usr/bin/python3
import sys
from xpinyin import Pinyin

def pinyin_capitalize(str):
  p = Pinyin()
  py = p.get_pinyin(str, '@@', tone_marks=1)
  py2 = py.split('@@')
  py3 = [c.capitalize() for c in py2]
  py4 = ' '.join(py3[0:])
  print(py4)
  return py4

if len(sys.argv) == 2:
  str=sys.argv[1]
  pinyin_capitalize(str)