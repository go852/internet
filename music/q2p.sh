#!/bin/sh

./qmc2flac.sh -s qmcflac -t flac
./flac2aac.sh -f wav -s flac -t wav
./pyren.sh -e wav -s wav -t pinyin
