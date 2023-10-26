#!/bin/sh

# In macOS system, install GNU Bash, and run the command as :
# bash download.sh

# r1,r2,r3均可
URL="https://r1-ndr.ykt.cbern.com.cn/edu_product/esp/assets/"


declare -A books=(
  ["数学（A版）必修第一册"]="6e764703-6e5e-4ea3-9462-34652c2678ef"
  ["数学（A版）必修第二册"]="d296fc79-8d47-4b18-862c-6df49adc2ce0"
  ["数学（A版）选修第一册"]="d0fd2c1f-6b4f-43f0-8229-de0a53b197df"
  ["数学（A版）选修第二册"]="99c1fb5b-d1e0-4238-90b9-a573ab84bf08"
  ["数学（A版）选修第三册"]="ffaba6c3-497d-47b0-b91a-784f43625507"
  ["物理必修第一册"]="708256b6-6f06-4d14-89c7-4df16dfe3b81"
  ["物理必修第二册"]="55baa3cc-156f-4358-8e28-bfa21a864450"
  ["物理必修第三册"]="dcd8cc6b-5380-4008-a2d0-a061f24d34dd"
  ["物理选修第一册"]="346c3c04-1663-472c-849e-ff876dcf293f"
  ["物理选修第二册"]="2ee7d7fa-1920-4d37-a179-91d5fd59b8c1"
  ["物理选修第三册"]="2109c25c-2e52-4da3-8ab3-18cbe632ec11"
  ["化学必修第一册"]="5cd19072-e40d-4a73-8580-7b7ada5d4005"
  ["化学必修第二册"]="07f7d663-a867-4eb6-ad39-03b55dbd4a65"
  ["化学选修第一册"]="3502fe81-b23e-4f68-aa3d-7921e7932ec9"
  ["化学选修第二册"]="b82cefe7-d631-4bde-baf9-352ca033cba4"
  ["化学选修第三册"]="c561d8ee-7c06-4cb1-9a4d-e34036f02d53"  
)

for book in ${!books[*]}; do
  # echo "$book: ${URL}${books[$book]}.pkg/pdf.pdf?v=1688387729168"
  if [ ! -f "${book}.pdf" ]; then
    wget "${URL}${books[$book]}.pkg/pdf.pdf?v=1688387729168" -O "${book}.pdf" 
  fi
done
