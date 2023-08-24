#!/bin/bash

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
  echo "source:$source"
  echo "target:$target"  
  
  if [[ (-z "$source") || ( -z "$target") ]] ; then
    echo "使用说明："
    echo "  $0 -s 源目录 -t 目标目录"
    echo
    exit 1
  fi
}

qmc2flac(){
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
      target="$target/$d"
      if [ ! -d "$target" ] ; then mkdir -p "$target"; fi
      cd $d
      takiyasha --np *.qmcflac -d "$target"
      cd -
    fi
  done
  cd -
}

usage $*
qmc2flac