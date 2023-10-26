#!/bin/sh

# In macOS system, install GNU Bash, and run the command as :
# bash d1.sh

declare -A books=(
  ["苏教版数学七年级上册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/6e764703-6e5e-4ea3-9462-34652c2678ef.pkg/thumbnails/1.png" 
)

for book in ${!books[*]}; do
  url=${books[$book]}
  url=${url/'thumbnails/1.png'/'pdf.pdf?v=1688387729168'}

  if [ ! -f "${book}.pdf" ]; then
    wget "$url" -O "${book}.pdf" 
  fi
done
