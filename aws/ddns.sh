#!/bin/bash
key=$(egrep key ddns.conf | awk -F'"' '{print $2}')
email=$(egrep email ddns.conf | awk -F'"' '{print $2}')
zoneid=$(egrep zoneid ddns.conf | awk -F'"' '{print $2}')
zonename=$(egrep zonename ddns.conf | awk -F'"' '{print $2}')
# ipv6 为 AAAA记录 ，ipv4 为 A 记录
recordtype="A"

usage(){
  help="Usage:\n
      -e email\n
      -i zoneid\n
      -k key\n
      -n hostname\n
      -p ip\n
      -z zonename\n
      \n"
  echo -e $help
  exit 1
}

while getopts :e:i:k:n:p:z argvs
do
  case $argvs in
    e)
      email=$OPTARG
      echo -e "email=$OPTARG\n";;
    i)
      zoneid=$OPTARG
      echo -e "zoneid=$OPTARG\n";;
    k)
      key=$OPTARG
      echo -e "key=$OPTARG\n";;
    n)
      hostname=$OPTARG
      echo -e "hostname=$OPTARG\n";;
    p)
      ip=$OPTARG
      echo -e "hostname=$OPTARG\n";;
    z)
      zonename=$OPTARG
      echo -e "zonename=$OPTARG\n";;
    *)
      usage
      exit 1;;
  esac
done

if [ -z "$hostname" ] ; then
  usage
  exit 1
fi

echo $(date)
# ip 的获取要根据实际情况修改
if [ -z "$ip" ] ; then
  ip=$(curl -s 'https://ifconfig.me/')
  echo Local Public IP: $ip
fi

# 判断 IP 是否变化
dns_ip=$(host $hostname |  awk '/has address/ { print $4 ; exit }')
#  dns_ip=$(dig +short $hostname)
echo "IP resolved from DNS: $hostname: $dns_ip: "

if [ "$ip" == "$dns_ip" ]; then
  :
#  exit 0
fi

zoneid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zonename" -H "X-Auth-Email: $email"  -H "X-Auth-Key: $key"  -H 'Content-Type: application/json' | awk -F , '{print $1}' | awk -F \" '{print $6}')
echo ZoneID: "$zoneid"

record_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?name=$hostname&type=$recordtype" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: application/json" | awk -F \" '{print $6}')
echo RecordID: "$record_id"

curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$record_id" -H "X-Auth-Email: $email" -H "X-Auth-Key: $key" -H "Content-Type: application/json" --data "{\"id\":\"$zoneid\",\"type\":\"$recordtype\",\"name\":\"$hostname\",\"content\":\"$ip\"}"

echo -e "\n"
ping -c 5 $hostname
