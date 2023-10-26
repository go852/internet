#!/bin/sh

# In macOS system, install GNU Bash, and run the command as :
# bash d3.sh

declare -A books=(
  ["数学（A版）必修第一册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/6e764703-6e5e-4ea3-9462-34652c2678ef.pkg/thumbnails/1.png" 
    ["数学（A版）必修第二册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/d296fc79-8d47-4b18-862c-6df49adc2ce0.pkg/thumbnails/1.png"
  ["数学（A版）选修第一册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/d0fd2c1f-6b4f-43f0-8229-de0a53b197df.pkg/thumbnails/1.png"
  ["数学（A版）选修第二册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/99c1fb5b-d1e0-4238-90b9-a573ab84bf08.pkg/thumbnails/1.png"
  ["数学（A版）选修第三册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/ffaba6c3-497d-47b0-b91a-784f43625507.pkg/thumbnails/1.png"
  ["物理必修第一册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/708256b6-6f06-4d14-89c7-4df16dfe3b81.pkg/thumbnails/1.png"
  ["物理必修第二册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/55baa3cc-156f-4358-8e28-bfa21a864450.pkg/thumbnails/1.png"
  ["物理必修第三册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/dcd8cc6b-5380-4008-a2d0-a061f24d34dd.pkg/thumbnails/1.png"
  ["物理选修第一册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/346c3c04-1663-472c-849e-ff876dcf293f.pkg/thumbnails/1.png"
  ["物理选修第二册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/2ee7d7fa-1920-4d37-a179-91d5fd59b8c1.pkg/thumbnails/1.png"
  ["物理选修第三册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/2109c25c-2e52-4da3-8ab3-18cbe632ec11.pkg/thumbnails/1.png"
  ["化学必修第一册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/5cd19072-e40d-4a73-8580-7b7ada5d4005.pkg/thumbnails/1.png"
  ["化学必修第二册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/07f7d663-a867-4eb6-ad39-03b55dbd4a65.pkg/thumbnails/1.png"
  ["化学选修第一册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/3502fe81-b23e-4f68-aa3d-7921e7932ec9.pkg/thumbnails/1.png"
  ["化学选修第二册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/b82cefe7-d631-4bde-baf9-352ca033cba4.pkg/thumbnails/1.png"
  ["化学选修第三册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/c561d8ee-7c06-4cb1-9a4d-e34036f02d53.pkg/thumbnails/1.png" 
)

for book in ${!books[*]}; do
  url=${books[$book]}
  url=${url/'thumbnails/1.png'/'pdf.pdf?v=1688387729168'}

  if [ ! -f "${book}.pdf" ]; then
    wget "$url" -O "${book}.pdf" 
  fi
done
