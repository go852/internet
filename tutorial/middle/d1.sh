#!/usr/local/bin/bash

# In macOS system, install GNU Bash, and run the command as :
# bash d1.sh

declare -A books=(
  ["语文七年级上册"]="https://v1.ykt.cbern.com.cn/65/document/9f996e9b45d847339b4f07d5db80bd43/pdf.pdf"
  ["语文七年级下册"]="https://v1.ykt.cbern.com.cn/65/document/206240c75072408bb343d0c403696efa/pdf.pdf"
  ["语文八年级上册"]="https://v3.ykt.cbern.com.cn/65/document/afce7897a3b44ce48a6daa0f03a06f5a/pdf.pdf"
  ["语文八年级下册"]="https://v3.ykt.cbern.com.cn/65/document/030cc3fde02044ef992260b739792925/pdf.pdf"
  ["语文九年级上册"]="https://v3.ykt.cbern.com.cn/65/document/69ec38b3e3da416ab984ffd76cdec58e/pdf.pdf"
  ["语文九年级下册"]="https://v2.ykt.cbern.com.cn/65/document/4558cc2a9eac4098ac012f7778d23163/pdf.pdf"
  ["数学七年级上册"]="https://v1.ykt.cbern.com.cn/65/document/1f950f67804f41afad067332c90281e0/pdf.pdf"
  ["数学七年级下册"]="https://v3.ykt.cbern.com.cn/65/document/c48d85ba39b945bcb8d9a6d2ce0ff660/pdf.pdf"
  ["数学八年级上册"]="https://v2.ykt.cbern.com.cn/65/document/e2ca61551006430db66554049764a8b6/pdf.pdf"
  ["数学八年级下册"]="https://v2.ykt.cbern.com.cn/65/document/f14ca004aa554c38aa838424f6e145c8/pdf.pdf"
  ["数学九年级上册"]="https://v1.ykt.cbern.com.cn/65/document/bb58ee260f5f4d97b232fc2bfd6a56e7/pdf.pdf"
  ["数学九年级下册"]="https://v3.ykt.cbern.com.cn/65/document/38ac2ce34b304b6ea44a95b39231e5d6/pdf.pdf"
  ["物理八年级上册"]="https://v3.ykt.cbern.com.cn/65/document/455b5519a1b54154b81bca9bcb75d8b0/pdf.pdf"
  ["物理八年级下册"]="https://v3.ykt.cbern.com.cn/65/document/9db08b6e44854f2ea9450acf9a64effe/pdf.pdf"
  ["物理九年级上册"]="https://v1.ykt.cbern.com.cn/65/document/6f5d9380d1e0421dbf8ee9ec9312dec9/pdf.pdf"
  ["物理九年级下册"]="https://v3.ykt.cbern.com.cn/65/document/90f98efd11b94f339133779144ed3011/pdf.pdf"
  ["化学九年级上册"]="https://v2.ykt.cbern.com.cn/65/document/c257d888966b443481f3db28214df28e/pdf.pdf"
  ["化学九年级下册"]="https://v3.ykt.cbern.com.cn/65/document/02d52dbeec9746fbae3abfd98cff6e4b/pdf.pdf"
)

download(){
  for book in ${!books[*]};do
    url=${books[$book]}
    echo $url

    if [ ! -f "${book}.pdf" ]; then
      echo wget "$url" -O "${book}.pdf" 
      wget "$url" -O "${book}.pdf" 
    fi
  done
}

download


