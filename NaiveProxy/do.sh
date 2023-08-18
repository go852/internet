#!/bin/bash

shell_renew(){
    curl -o /root/.naive.sh https://raw.githubusercontent.com/852us/NaiveProxy/main/naive.sh
    chmod +x /root/.naive.sh
    ln -s /root/.naive.sh /bin/naive
    echo
    echo " naive 命令安装完毕，请使用naive进行操作。"
}

shell_renew
