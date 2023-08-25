#!/bin/bash
shopt -s nullglob

usage() {
  while getopts ":s:t:" opt; do
    case $opt in
    s)
      echo "source: $OPTARG"
      source=$OPTARG
      ;;
    t)
      echo "target: $OPTARG"
      target=$OPTARG
      ;;
    \?)
      echo "无效参数：-$OPTARG" >&2
      exit 1
      ;;
    esac
  done
  
  shift $((OPTIND -1)) 
  
  if [[ (-z "$source") || ( -z "$target") ]] ; then
    echo "使用说明："
    echo "  $0 -s 源目录 -t 目标目录"
    echo
    exit 1
  fi
}

process_dir(){
  PWD="$(pwd)"
  if [[ "${source:0:1}" != "/" ]]; then
    source="$PWD/$source"
  fi
  if [[ "${target:0:1}" != "/" ]]; then
    target="$PWD/$target"
  fi
  
  cd $source
  for d in *; do
    if [ -d "$d" ] ; then
      echo "处理目录：$d"
      dest="$target/$d"
      if [ ! -d "$dest" ] ; then mkdir -p "$dest"; fi
      cd $d
      for f in *.qmcflac; do
        dest_filename="${f/.qmcflac/.flac}"
        if [ ! -f "$dest/$dest_filename" ]; then
          takiyasha --np "$f" -d "$dest"
        fi
      done
      cd -
    fi
  done
  cd -
}

usage $*
process_dir
