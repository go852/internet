#/usr/bin/python

def pinyin_capitalize(str):
    from xpinyin import Pinyin
    p = Pinyin()
    py = p.get_pinyin(str, '@@')
    py2 = py.split('@@')
    py3 = [c.capitalize() for c in py2]
    py4 = ''.join(py3[0:])
    return py4

def rename_pinyin(folder='/Volumes/Data/flac'):
    import os
    import re
    curdir = os.getcwd()
    os.chdir(folder)
    print("Processing ", folder, "...")

    file_list = [f for f in os.listdir() if not f.startswith('.')
                if f !='script']
    for count, f in enumerate(file_list):
        if f[0] == '.':
            continue
        filename = re.sub(r'[0-9]+\.', '',  f)
        filename = str(count).zfill(3) + '.' + pinyin_capitalize(filename) #
        if os.path.isdir(f):
            print("rename ", f, filename)
            os.rename(f, filename)
            rename_pinyin(folder = folder + '/' + filename)
        else:
            name, ext = os.path.splitext(filename)
            e = ext.lower()
            if e.endswith("flac") or e.endswith("wav") or e.endswith("m4a"):
                print("rename ", f, filename)
                os.rename(f, filename)
    os.chdir(curdir)

import sys
rename_pinyin(sys.argv[1])
