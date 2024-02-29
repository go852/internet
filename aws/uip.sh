#!/bin/bash

ID="i-0a96fef467a0abf9b"
NAME1=w2
NAME2=np2
SITE="852us.top"

write_config_file(){
  cat > uip-$NAME.conf <<EOF
instance-id="$ID"
hostname="$NAME1.$SITE"
EOF
}


write_host_file(){
  cat > uip-$NAME.host <<EOF
$NAME1.$SITE
$NAME2.$SITE
EOF
}

restart_instance() {
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

restart(){
  config_files=$(ls uip*.conf)
  for config_file in $config_files; do
    echo $config_file
    iid=$(egrep instance-id $config_file | awk -F '"' '{print $2}')
    hostname=$(egrep hostname $config_file | awk -F '"' '{print $2}')
    echo $iid
    echo "重启：$hostname"
    restart_instance $iid
    #aws ec2 describe-instances --instance-id $iid | grep -e '"LaunchTime"' -e '"Name":'
  
    host_file="${config_file/.conf/.host}"
    for host in $(<$host_file); do
      echo ./ddns.sh -h $host -p $NewIP
      ./ddns.sh -h $host -p $NewIP
    done
  done
}

write_config_file
write_host_file
restart
