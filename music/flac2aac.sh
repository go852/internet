#!/bin/sh

format="aac"
ext="m4a"

usage() {
  while getopts ":f:s:t:" opt; do
    case $opt in
    f)
      echo "format: $OPTARG"
      format=$OPTARG
      ;;      
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
    echo "  $0 -f 格式 -s 源目录 -t 目标目录"
    echo " 格式："
    echo "    wav - wave"
    echo "    aac - m4a"
    echo "示例："
    echo "  $0 -f wav -s flac -t wav"
    echo "  $0 -f aac -s flac -t m4a"
    exit 1
  fi
}


process_dir(){
  [ "$format" == "aac" ] && ext="m4a" || ext="$format"
  echo "ext:$ext"
  
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
      cd "$d"
      #takiyasha --np *.qmcflac -d "$dest"
      for f in *.flac; do
        dest_filename="$dest/${f%.flac}.$ext"
        echo xld "$f" -f aac -o "$dest_filename"
        xld "$f" -f $format -o "$dest_filename"
        echo
      done
      cd -
    fi
  done
  cd -
}

usage $*
process_dir