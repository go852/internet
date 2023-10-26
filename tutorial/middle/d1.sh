#!/usr/local/bin/bash

# In macOS system, install GNU Bash, and run the command as :
# bash d1.sh

declare -A books=(
  ["统编版道德与法治一年级上册"]="https://r3-ndr.ykt.cbern.com.cn/edu_product/65/document/a99f662acf204783844599c56f2bfb1d/image/1.jpg"
  ["苏教版数学七年级上册"]="https://r3-ndr.ykt.cbern.com.cn/edu_product/esp/assets/01e365c7-9178-4155-8640-c862c5eff5e6.t/zh-CN/1688377923908/transcode/image/1.jpg?v=1688380045451"
  ["苏教版数学七年级下册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/f156dcad-f112-4937-a4bc-f4fa349beed6.t/zh-CN/1688378312803/transcode/image/1.jpg?v=1688392469062"
  ["苏教版数学八年级上册"]="https://r3-ndr.ykt.cbern.com.cn/edu_product/esp/assets/898de31a-e932-43ea-96af-83df3300020b.t/zh-CN/1688378175799/transcode/image/1.jpg?v=1688386577924"
  ["苏教版数学八年级下册"]="https://r2-ndr.ykt.cbern.com.cn/edu_product/esp/assets/e2eb2248-6d8e-44fc-a1ef-a1eaead72992.t/zh-CN/1688378294463/transcode/image/1.jpg?v=1688391748081"
  ["苏教版数学九年级上册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/bd633723-cfca-47c7-bea3-7496e1648a91.t/zh-CN/1688378249776/transcode/image/1.jpg?v=1688389495827"
  ["苏教版数学九年级下册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/33f1be2a-c063-4669-ba44-341c2b17a091.t/zh-CN/1688378050463/transcode/image/1.jpg?v=1688382757371"
  ["人教版生物学八年级上册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/5a29010d-b2f0-4bf0-9e05-e311168cd929.pkg/thumbnails/2023.07.04_林鑫.png"
  ["人教版生物学八年级下册"]="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/f4e7eb1c-2a75-4bc5-8fb9-404a108e1b84.t/zh-CN/1688378317278/transcode/image/1.jpg?v=1688392486061"
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

download(){
  for book in ${!books[*]};do
    url=${books[$book]}
    url=${url/.t*/.pkg}
    url=${url/thumbnails*/}
    url=${url/'image/1.jpg'/}
    url="${url}pdf.pdf?v=1688392469062"
    echo $url

    if [ ! -f "${book}.pdf" ]; then
      echo wget "$url" -O "${book}.pdf" 
      wget "$url" -O "${book}.pdf" 
    fi
  done
}

download

