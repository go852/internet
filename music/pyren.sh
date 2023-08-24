#!/bin/sh
PINYIN="$(pwd)/pinyin.py"
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
    echo "示例："
    echo "  $0 -s flac -t flac2"
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
      newd=$(python3 $PINYIN "$d")
      dest="$target/$newd"
      if [ ! -d "$dest" ] ; then mkdir -p "$dest"; fi
      cd "$d"
      for f in *.flac; do
        f2=${f#*-}
        newname=$(python3 $PINYIN "$f2")
        dest_filename="$dest/$newname"
        echo "$f: $dest_filename"
        #echo cp "$f" "$dest_filename"
        cp "$f" "$dest_filename"
      done
      echo
      cd -
    fi
  done
  cd -
}

usage $*
process_dir

