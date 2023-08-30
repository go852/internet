#!/bin/bash
TEMPDIR="/tmp/naive"
USER="User"
PASSWORD="!Qaz2023"
HOST=""
declare -a HOSTS
while getopts ":h:e:u:p:" opt
do
  case $opt in
  e)  # 处理 -e 选项
    echo "EMAIL: $OPTARG"
    EMAIL=$OPTARG
    ;;
  h)  # 处理 -h 选项
    #echo "0: HOST: $HOST"
    #echo "0: HOSTS: $HOSTS"
    echo "HOST: $OPTARG"
    if [ -z "$HOST" ] ; then
      HOST="$OPTARG"
      HOSTS+="$HOST"
      #echo "1: HOST: $HOST#"
      #echo "1: HOSTS: $HOSTS"
    else
      HOST="$OPTARG"
      HOSTS+=($HOST)
      #echo "2: HOST: $HOST"
      #echo "2: HOSTS: $HOSTS"
    fi
    echo
    ;;
  u)  # 处理 -u 选项
    echo "USER: $OPTARG"
    USER=$OPTARG
    ;;
  p)  # 处理 -p 选项
    echo "PASSWORD: $OPTARG"
    PASSWORD=$OPTARG
    ;;
  \?)
    echo "无效参数：-$OPTARG" >&2
    ;;
  esac
done

#echo "3: HOST: $HOST"
#echo "3: HOSTS: $HOSTS"
for host in ${HOSTS[@]}; do 
  echo $host; 
  HOST_LIST+=" $host"
done
echo "$HOST_LIST"

if [[ -z "$HOST_LIST" || -z "$USER" || -z "$PASSWORD" ]]; then
  echo "请设置EMAIL, HOST，USER，PASSWORD参数"
  echo "  -e EMAIL"
  echo "  -h HOST"
  echo "  -u USER"
  echo "  -p PASSWORD"
  echo
  exit 1
fi

if [ ! -d "$TEMPDIR" ]; then
  mkdir -p "$TEMPDIR"
fi
cd "$TEMPDIR"

BIN_DIR="/usr/local/bin"
NAIVE_CONFIG_FILE="/etc/naive/config.json"
NAIVE_SERVICE_FILE="/lib/systemd/system/naive.service"
CADDY_SERVICE_FILE="/lib/systemd/system/caddy.service"

install_naive_service() {
  echo "安装naive.service ..."
  echo

# config.json
  if [ ! -d /etc/naive ]; then mkdir /etc/naive; fi
  cat > $NAIVE_CONFIG_FILE <<-EOF
{
  "listen": "http://127.0.0.1:54321",
  "padding": false
}
EOF

  cat > $NAIVE_SERVICE_FILE <<-EOF
[Unit]
Description=Naive Service
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
NoNewPrivileges=true
ExecStart=/usr/local/bin/naive /etc/naive/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
  systemctl enable naive
  systemctl start naive
  systemctl list-units | grep naive
}

install_caddy_service() {
  echo "安装caddy.service ..."
  echo

# caddy.naive
  if [ ! -d /etc/caddy ]; then mkdir /etc/caddy; fi
  if [ -z "$(grep 'order' /etc/caddy/Caddyfile)" ] ; then 
echo "    
{
  order forward_proxy before reverse_proxy
  order forward_proxy before handle_path
}
$(cat /etc/caddy/Caddyfile)" > /etc/caddy/Caddyfile
  fi 

  cat >/etc/caddy/sites/Caddyfile.naive <<-EOF
:443, $HOST_LIST {
  tls $EMAIL
  forward_proxy {
    basic_auth $USER $PASSWORD # 用户名、密码
    hide_ip
    hide_via
    probe_resistance
    upstream http://127.0.0.1:54321
  }  
}
EOF
# caddy.service
  cat > $CADDY_SERVICE_FILE <<-EOF
# Refer to: https://github.com/caddyserver/dist/blob/master/init/caddy.service
# CADDY_SERVICE_FILE="/lib/systemd/system/caddy.service"
[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
User=root
Group=root
ExecStart=/usr/local/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/local/bin/caddy reload --config /etc/caddy/Caddyfile
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full

[Install]
WantedBy=multi-user.target
EOF
  systemctl enable caddy
  systemctl start caddy
  systemctl list-units | grep caddy
}

download_naive() {
  NAIVE_SERVICE="$(systemctl list-unit-files | grep naive)"
  if [ ! -z "$NAIVE_SERVICE" ] ; then
    #echo $NAIVE_SERVICE
    systemctl disable naive
    systemctl stop naive
  fi
  sudo apt install xz-utils
  API_URL="https://api.github.com/repos/klzgrad/naiveproxy/releases/latest?v=$RANDOM"
  #echo NAIVE_VERSION="$(curl -s $API_URL | awk -F '"' '/"tag_name"/{print $4}')"
  NAIVE_VERSION="$(curl -s $API_URL | awk -F '"' '/"tag_name"/{print $4}')"
  echo $NAIVE_VERSION
  DOWN_URL="https://github.com/klzgrad/naiveproxy/releases/download"
  DOWN_URL="$DOWN_URL/$NAIVE_VERSION/naiveproxy-$NAIVE_VERSION-linux-x64.tar.xz"
  echo wget -c $DOWN_URL
  wget -c $DOWN_URL
  tar xJvf naiveproxy-$NAIVE_VERSION-linux-x64.tar.xz
  cp naiveproxy-$NAIVE_VERSION-linux-x64/naive /usr/local/bin/
}

download_caddy() {
  CADDY_SERVICE="$(systemctl list-unit-files | grep naive)"
  if [ ! -z "$CADDY_SERVICE" ] ; then
  #  echo $CADDY_SERVICE
    systemctl disable caddy
    systemctl stop caddy
  fi
  API_JSON="api.json"
  GITHUB_USER="klzgrad"
  REPO_NAME="forwardproxy"
  API_URL="https://api.github.com/repos/$GITHUB_USER/$REPO_NAME/releases/latest?v=$RANDOM"
  echo $API_URL 
  curl -s $API_URL > $API_JSON
  #cat $API_JSON
  RELEASE_VERSION="$(awk -F '"' '/"tag_name"/{print $4}' $API_JSON)"
  echo "RELEASE_VERSION=$RELEASE_VERSION"
  DOWN_URL="$(awk -F '"' '/"browser_download_url"/{print $4}' $API_JSON)"
  echo "DOWN_URL=$DOWN_URL"
  FILE_NAME="$(echo "$DOWN_URL" | sed 's/.*[!/]//')"
  echo "FILE_NAME=$FILE_NAME"
  PATH_NAME="$(echo $FILE_NAME | sed 's/.tar.xz//')"
  echo "PATH_NAME=$PATH_NAME"
  echo wget -c $DOWN_URL
  wget -c $DOWN_URL
  echo tar xJvf $FILE_NAME
  tar xJvf $FILE_NAME
  echo cp $PATH_NAME/caddy /usr/local/bin/
  cp $PATH_NAME/caddy /usr/local/bin/
}

show_info() {
  echo
  #for host in "$HOSTS"; do
  for host in ${HOSTS[@]}; do
    #echo "Host: $host"
    ALIAS=$(echo $host | awk -F '.' '{print $1}')
    echo "naive+https://$USER:$PASSWORD@$host:443?padding=false#$ALIAS"
  done
  echo
}

remove_tmp_files() {
  rm -rf api.json
  rm -rf naive*
  rm -rf caddy*
  cd -
}

download_naive
install_naive_service
download_caddy
install_caddy_service
show_info
remove_tmp_files