#!/bin/bash

update_ip() {
  IID=$1
  echo "Instance-ID: $IID"
  OldIP=$(aws ec2 describe-instances --instance-id $IID | grep PublicIp | awk -F'[:"]' 'NR==2{print $5}')
  echo $OldIP
  
  # stop instances
  echo "停止实例..."
  aws ec2 stop-instances --instance-id $IID
  
  echo "等待2分钟..."
  sleep 120
  
  # start instances
  echo "启动实例..."
  aws ec2 start-instances --instance-id $IID
  
  echo "等待2分钟..."
  sleep 120

  NewIP=$(aws ec2 describe-instances --instance-id $IID | grep PublicIp | awk -F'[:"]' 'NR==2{print $5}')
  echo $NewIP
}

config_files=$(ls uip*.conf)
for config_file in $config_files; do
  echo $config_file
  iid=$(egrep instance-id $config_file | awk -F '"' '{print $2}')
  hostname=$(egrep hostname $config_file | awk -F '"' '{print $2}')
  echo $iid
  echo $hostname
  update_ip $iid
  echo ./ddns.sh -n $hostname -p $NewIP
done
