#!/bin/bash

# 确认继续执行的函数
confirm_step() {
    while true; do
        read -p "步骤 $1 完成。是否继续执行下一步？(y/n/r，默认是 y): " yn
        yn=${yn:-y}
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            [Rr]* ) return 1;;
            * ) echo "请输入 yes (y), no (n), 或 retry (r)。";;
        esac
    done
}

# 自动化输入的函数
run_ddns_script() {
    expect <<EOF
spawn bash -c "bash <(wget -qO- https://raw.githubusercontent.com/mocchen/cssmeihua/mochen/shell/ddns.sh)"
expect "邮箱地址: " {send "yooyu@msn.com\r"}
expect "Token: " {send "e80a9bfb256d5d060aa8a4f55a7da43fdf135\r"}
expect "Telegram_bot_token: " {send "7486335088:AAHgyVaIkb2sO_p7rdhnUZALXHAW0bXAKM0\r"}
expect "Telegram_chat_id: " {send "6653302268\r"}
expect eof
EOF
}

# 第一步：更新包列表并升级所有已安装的软件包
while true; do
    sudo apt update && sudo apt upgrade -y 
    confirm_step 1 && break
done

# 第二步：切换到 root 用户
while true; do
    sudo -i
    confirm_step 2 && break
done

# 第三步：选择输入国家
while true; do
    read -p "请输入国家代码 (in/sg): " country
    if [[ "$country" == "in" || "$country" == "sg" ]]; then
        break
    else
        echo "输入无效。请输入 'in' 或 'sg'。"
    fi
done
confirm_step 3

# 第四步：禁用防火墙
while true; do
    sudo ufw disable
    confirm_step 4 && break
done

# 第五步：下载并运行 pei-zhi-huan-jing.sh 脚本
while true; do
    wget -N --no-check-certificate "https://raw.githubusercontent.com/w243420707/-/main/pei-zhi-huan-jing.sh" && chmod +x pei-zhi-huan-jing.sh && ./pei-zhi-huan-jing.sh
    confirm_step 5 && break
done

# 第六步：下载并运行 add_swap.sh 脚本
while true; do
    wget -N --no-check-certificate "https://raw.githubusercontent.com/w243420707/-/main/add_swap.sh" && chmod +x add_swap.sh && ./add_swap.sh
    confirm_step 6 && break
done

# 新增步骤：下载并运行 ddns.sh 脚本并输入参数
while true; do
    run_ddns_script
    confirm_step 6.5 && break
done

# 第七步：下载并运行 menu.sh 脚本，选择选项 6
while true; do
    wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh 6
    confirm_step 7 && break
done

# 第八步：运行 warp
while true; do
    warp <<EOF
11
EOF    
    confirm_step 8 && break
done

# 第九步：下载并运行 install.sh 脚本
while true; do
    wget -N https://raw.githubusercontent.com/wyx2685/V2bX-script/master/install.sh && bash install.sh
    confirm_step 9 && break
done

# 第十步：根据国家下载并运行 nezha.sh 脚本
while true; do
    if [[ "$country" == "in" ]]; then
        curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh install_agent vpsip.flywhaler.com 5555 lA6WODakEauns1eiEv
    elif [[ "$country" == "sg" ]]; then
        curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh install_agent vpsip.flywhaler.com 5555 geKH2HPwo8NCviE6zJ
    fi    
    confirm_step 10 && break
done

# 第十一步：删除 config.json 文件并根据国家下载新的配置文件
while true; do
    sudo rm -f /etc/V2bX/config.json
    if [[ "$country" == "in" ]]; then
        sudo wget -O /etc/V2bX/config.json https://raw.githubusercontent.com/w243420707/20240725/main/config/in.json
    elif [[ "$country" == "sg" ]]; then
        sudo wget -O /etc/V2bX/config.json https://raw.githubusercontent.com/w243420707/20240725/main/config/sg.json
    fi  
    sudo chmod -R 777 /etc/  
    confirm_step 11 && break
done

# 第十二步：下载并运行 tcp.sh 脚本，默认选择 11
while true; do
    wget -O tcp.sh "https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh <<EOF
11
EOF
    confirm_step 12 && break
done

# 第十三步：重启系统
while true; do
    reboot
done
