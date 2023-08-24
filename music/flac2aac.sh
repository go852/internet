#!/bin/sh
if [ $# -lt 1 ] ; then
  echo "使用说明："
  echo "  $0 目标目录"
  echo
  exit 0
fi

cd "$1"
dest=$(pwd "$1")
cd -

for d in *; do
  if [ -d "$d" ]; then
    echo "处理目录：$d"
    target="$dest/$d"
    if [ ! -d "$target" ] ; then mkdir -p "$target"; fi
    cd "$d"
    for f in *.flac; do
      target_filename="$target/${f%.flac}.m4a"
      echo xld "$f" -f aac -o "$target_filename"
      xld "$f" -f aac -o "$target_filename"
      echo
    done
    cd -
    echo
  fi
done
