#!/bin/sh
shopt -s nullglob

PINYIN="$(pwd)/pinyin.py"

usage() {
  while getopts ":e:s:t:" opt; do
    case $opt in
    e)
      echo "ext: $OPTARG"
      ext=$OPTARG
      ;;
    s)
      echo "source_dir: $OPTARG"
      source_dir=$(cd $OPTARG; pwd)
      ;;
    t)
      echo "target_dir: $OPTARG"
      target_dir=$OPTARG
      if [ ! -d "$target_dir" ] ; then
        echo mkdir -p "$target_dir";
        mkdir -p "$target_dir";
      fi
      target_dir=$(cd $target_dir; pwd)
      ;;
    \?)
      echo "无效参数：-$OPTARG" >&2
      exit 1
      ;;
    esac
  done
  
  shift $((OPTIND -1)) 

  if [[ (-z "$ext") ||  (-z "$source_dir") || ( -z "$target_dir") ]] ; then
    echo "使用说明："
    echo "  $0 -e 扩展名 -s 源目录 -t 目标目录"
    echo "示例："
    echo "  $0 -e flac -s flac -t flac2"
    exit 1
  fi
}

process_dir(){
  source="$1"
  target="$2"

  echo "source: $source"
  echo "target: $target"

  if [ ! -d "$target" ] ; then
    echo mkdir -p "$target";
    mkdir -p "$target";
  fi

  cd $source
  for f in *.$ext; do
    f2=${f#*-}
    newname=$(python3 $PINYIN "$f2")
    dest_filename="$target/$newname"
    echo "$f: $dest_filename"
    cp "$f" "$dest_filename"
  done

  for d in *; do
    if [ -d "$d" ] ; then
      dir_name=$(cd $d; pwd)
      newd=$(python3 $PINYIN "${dir_name#$source_dir/}")
      echo "待处理的目录：$newd"
      dest="$target_dir/$newd"
      echo "process_dir $d $dest"
      process_dir $d $dest
    fi
  done
  cd -
#  echo "完成$source 目录的处理..."
}

usage $*
process_dir $source_dir $target_dir

