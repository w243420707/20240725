#!/bin/bash

# 绿色文本的ANSI转义码
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 确认继续执行的函数
confirm_step() {
    while true; do
        read -p "步骤 $1 完成。是否继续执行下一步？(y/n/r，默认是 y): " yn
        yn=${yn:-y}
        case $yn in
            [Yy]* ) return 0;;  # 继续执行
            [Nn]* ) exit 1;;    # 退出
            [Rr]* ) return 1;;  # 重试
            * ) echo "请输入 yes (y), no (n), 或 retry (r)。";;
        esac
    done
}

# 执行命令并确认步骤
execute_step() {
    local step=$1
    local command=$2
    local success_message=$3
    local retry_message=$4

    while true; do
        eval "$command"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}${success_message}${NC}"
            confirm_step $step && break
        else
            echo "$retry_message"
        fi
    done
}

# 启动进度条的函数
show_progress() {
    local duration=$1
    echo -n "正在执行，请稍候: "
    seq $duration | pv -n -s $duration | awk '{ printf("\r进度: [%s%s] %.2f%%", str_repeat("█", int($1*50/$duration)), str_repeat("░", 50-int($1*50/$duration)), $1*100/$duration) }'
    echo ""
}

# 显示日志文件内容的函数
display_log() {
    local log_file=$1
    echo -e "${GREEN}显示日志: ${log_file}${NC}"
    cat "$log_file"
}

# 第二步：禁用防火墙
execute_step 2 "sudo ufw disable" "防火墙已禁用。" "禁用防火墙失败，请重试。"

# 第三步：下载并运行 pei-zhi-huan-jing.sh 脚本
execute_step 3 "wget -N --no-check-certificate 'https://raw.githubusercontent.com/w243420707/-/main/pei-zhi-huan-jing.sh' -O pei-zhi-huan-jing.sh && chmod +x pei-zhi-huan-jing.sh && ./pei-zhi-huan-jing.sh" "脚本 pei-zhi-huan-jing.sh 执行成功。" "下载或执行脚本 pei-zhi-huan-jing.sh 失败，请重试。"

# 第四步：下载并运行 add_swap.sh 脚本
execute_step 4 "wget -N --no-check-certificate 'https://raw.githubusercontent.com/w243420707/-/main/add_swap.sh' -O add_swap.sh && chmod +x add_swap.sh && ./add_swap.sh" "脚本 add_swap.sh 执行成功。" "下载或执行脚本 add_swap.sh 失败，请重试。"

# 第五步：执行 ddns.sh 脚本
execute_step 5 "
{
    wget -qO- https://raw.githubusercontent.com/mocchen/cssmeihua/mochen/shell/ddns.sh > ddns.sh &&
    chmod +x ddns.sh &&
    ./ddns.sh <<EOF
yooyu@msn.com
e80a9bfb256d5d060aa8a4f55a7da43fdf135
7486335088:AAHgyVaIkb2sO_p7rdhnUZALXHAW0bXAKM0
6653302268
EOF
} > ddns.log 2>&1" "脚本 ddns.sh 执行成功。" "执行脚本 ddns.sh 失败，请重试。请查看 ddns.log 文件以获取详细错误信息。"

# 第六步：下载并运行 menu.sh 脚本，选择选项 6
execute_step 6 "
{
    wget -qO menu.sh https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh &&
    bash menu.sh 6 <<EOF
2
1
1
3
EOF
} > menu.log 2>&1

# 显示菜单日志内容
display_log 'menu.log'
" "脚本 menu.sh 执行成功。" "下载或执行脚本 menu.sh 失败，请重试。请查看 menu.log 文件以获取详细错误信息。"

# 第七步：运行 warp
execute_step 7 "
{
    warp <<EOF
11
1
1
EOF
} > warp.log 2>&1" "warp 运行成功。" "运行 warp 失败，请重试。请查看 warp.log 文件以获取详细错误信息。"

# 第八步：下载并运行 install.sh 脚本
execute_step 8 "
{
    wget -N https://raw.githubusercontent.com/wyx2685/V2bX-script/master/install.sh -O install.sh &&
    bash install.sh <<EOF
n
EOF
} > install.log 2>&1" "脚本 install.sh 执行成功。" "下载或执行脚本 install.sh 失败，请重试。请查看 install.log 文件以获取详细错误信息。"

# 第十步：下载并运行 tcp.sh 脚本，默认选择 11
execute_step 10 "
{
    wget -O tcp.sh 'https://github.com/ylx2016/Linux-NetSpeed/raw/master/tcp.sh' &&
    chmod +x tcp.sh &&
    ./tcp.sh <<EOF
11
EOF
} > tcp.log 2>&1" "脚本 tcp.sh 执行成功。" "下载或执行脚本 tcp.sh 失败，请重试。请查看 tcp.log 文件以获取详细错误信息。"

# 第十一步：切换配置文件
execute_step 11 "
wget -N --no-check-certificate 'https://github.com/w243420707/20240725/raw/main/dlconfig' -O dlconfig.sh &&
chmod +x dlconfig.sh &&
./dlconfig.sh

