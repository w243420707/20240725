#!/bin/bash

# 确认继续执行的函数
confirm_step() {
    while true; do
        read -p "步骤 $1 完成。是否继续执行下一步？(y/n/r，默认是 y): " yn
        yn=${yn:-y}
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit 1;;
            [Rr]* ) return 1;;
            * ) echo "请输入 yes (y), no (n), 或 retry (r)。";;
        esac
    done
}

# 第一步：更新包列表并升级所有已安装的软件包
while true; do
    sudo apt update && sudo apt upgrade -y
    confirm_step 1 && break
done

# 第二步：禁用防火墙
while true; do
    sudo ufw disable
    confirm_step 2 && break
done

# 第三步：下载并运行 pei-zhi-huan-jing.sh 脚本
while true; do
    wget -N --no-check-certificate "https://raw.githubusercontent.com/w243420707/-/main/pei-zhi-huan-jing.sh" -O pei-zhi-huan-jing.sh && chmod +x pei-zhi-huan-jing.sh && ./pei-zhi-huan-jing.sh
    confirm_step 3 && break
done

# 第四步：下载并运行 add_swap.sh 脚本
while true; do
    wget -N --no-check-certificate "https://raw.githubusercontent.com/w243420707/-/main/add_swap.sh" -O add_swap.sh && chmod +x add_swap.sh && ./add_swap.sh
    confirm_step 4 && break
done

# 第五步：执行 ddns.sh 脚本
while true; do
    bash <(wget -qO- https://raw.githubusercontent.com/mocchen/cssmeihua/mochen/shell/ddns.sh) <<EOF
yooyu@msn.com
e80a9bfb256d5d060aa8a4f55a7da43fdf135
7486335088:AAHgyVaIkb2sO_p7rdhnUZALXHAW0bXAKM0
6653302268
EOF
    confirm_step 5 && break
done

# 第六步：下载并运行 menu.sh 脚本，选择选项 6
while true; do
    wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh -O menu.sh && bash menu.sh 6 <<EOF
2
1
1
3
EOF
    confirm_step 6 && break
done

# 第七步：运行 warp
while true; do
    warp <<EOF
11
1
1
EOF
    confirm_step 7 && break
done

# 第八步：下载并运行 install.sh 脚本
while true; do
    wget -N https://raw.githubusercontent.com/wyx2685/V2bX-script/master/install.sh -O install.sh && bash install.sh <<EOF
n
EOF
    confirm_step 8 && break
done

# 第九步：删除 config.json 文件并根据国家下载新的配置文件
while true; do
    sudo rm -f /etc/V2bX/config.json
    case "$country" in
        "in") url="https://raw.githubusercontent.com/w243420707/20240725/main/config/in.json";;
        "sg") url="https://raw.githubusercontent.com/w243420707/20240725/main/config/sg.json";;
        *) echo "未知国家配置"; exit 1;;
    esac
    sudo wget -O /etc/V2bX/config.json "$url"
    sudo chmod -R 777 /etc/
    confirm_step 9 && break
done

# 第十步：下载并运行 tcp.sh 脚本，默认选择 11
while true; do
    wget -O tcp.sh "https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh <<EOF
11
EOF
    confirm_step 10 && break
done

# 第十一步：切换配置文件
while true; do
    wget -N --no-check-certificate "https://github.com/w243420707/20240725/raw/main/dlconfig" -O dlconfig.sh && chmod +x dlconfig.sh && ./dlconfig.sh
    confirm_step 11 && break
done
