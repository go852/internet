#!/bin/bash

W2_IID="i-03560e38a39741de9"

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

update_ip $W2_IID
./ddns.sh -n w2.gocoin.one -p $NewIP
