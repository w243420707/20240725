#!/bin/bash

# 绿色文本的ANSI转义码
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 读取用户输入的国家/地区
read -p "请输入国家代码 (例如: SG, AU, IN, CA): " COUNTRY

# 确保输入的国家代码是大写
COUNTRY=$(echo "$COUNTRY" | tr '[:lower:]' '[:upper:]')

echo -e "${GREEN}选择的国家: ${COUNTRY}${NC}"

# 根据国家设置相关变量
case "$COUNTRY" in
    SG|SGP)
        DOMAIN="hy-sg-l4ehusajhz18.fly64jfgwhale.xyz"
        CONFIG_URL="https://raw.githubusercontent.com/w243420707/20240725/main/config/sg.json"
        AGENT_KEY="geKH2HPwo8NCviE6zJ"
        ;;
    AU|AUS)
        DOMAIN="hy-au-l4ehusajhz18.fly64jfgwhale.xyz"
        CONFIG_URL="https://raw.githubusercontent.com/w243420707/20240725/main/config/au.json"
        AGENT_KEY="rYchIL1LTRzjZbDyVw"
        ;;
    CA)
        DOMAIN="hy-ca-l4ehusajhz18.fly64jfgwhale.xyz"
        CONFIG_URL="https://raw.githubusercontent.com/w243420707/20240725/main/config/ca.json"
        AGENT_KEY="ItTR1fQMAfgTTnPVCa"
        ;;        
    IN|IND)
        DOMAIN="hy-in-l14ehusajhz18.fly64jfgwhale.xyz"
        CONFIG_URL="https://raw.githubusercontent.com/w243420707/20240725/main/config/in.json"
        AGENT_KEY="lA6WODakEauns1eiEv"
        ;;
esac

# 执行命令并输出成功消息
execute_step() {
    local step=$1
    local command=$2
    local success_message=$3
    local retry_message=$4

    echo "执行步骤 $step..."
    echo "执行命令: $command"
    eval "$command"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${success_message}${NC}"
    else
        echo "$retry_message"
    fi
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
$DOMAIN
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
case "$COUNTRY" in
    SG|SGP)
        AGENT_URL="https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh"
        ;;
    AU|AUS)
        AGENT_URL="https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh"
        ;;
    IN|IND)
        AGENT_URL="https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh"
        ;;
    CA)
        AGENT_URL="https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh"
        ;;        
esac

execute_step 11 "
{
    echo '下载并执行 nezha.sh...'
    curl -L $AGENT_URL -o nezha.sh
    if [ $? -ne 0 ]; then
        echo '下载 nezha.sh 失败。'
        exit 1
    fi

    chmod +x nezha.sh
    if [ $? -ne 0 ]; then
        echo '设置 nezha.sh 执行权限失败。'
        exit 1
    fi

    echo '执行 nezha.sh...'
    sudo ./nezha.sh install_agent vpsip.flywhaler.com 5555 $AGENT_KEY
    if [ $? -ne 0 ]; then
        echo '执行 nezha.sh 失败。'
        exit 1
    fi

    echo '更新配置文件...'
    curl -s $CONFIG_URL -o /etc/V2bX/config.json
    if [ $? -ne 0 ]; then
        echo '下载配置文件失败。'
        exit 1
    fi

    chmod +x /etc/V2bX/config.json
    if [ $? -ne 0 ]; then
        echo '设置配置文件权限失败。'
        exit 1
    fi

    echo '下载并设置 hy2config.yaml...'
    curl -s https://github.com/w243420707/20240725/raw/main/hy2config.yaml -o /etc/V2bX/hy2config.yaml
    if [ $? -ne 0 ]; then
        echo '下载 hy2config.yaml 失败。'
        exit 1
    fi

    chmod 777 /etc/V2bX/hy2config.yaml
    if [ $? -ne 0 ]; then
        echo '设置 hy2config.yaml 权限失败。'
        exit 1
    fi

    echo '第十一步完成。'



    echo '下载并设置 route.json...'
    curl -s https://github.com/w243420707/20240725/raw/main/route.json -o /etc/V2bX/route.json
    if [ $? -ne 0 ]; then
        echo '下载 route.json 失败。'
        exit 1
    fi

    chmod 777 /etc/V2bX/route.json
    if [ $? -ne 0 ]; then
        echo '设置 route.json 权限失败。'
        exit 1
    fi

    echo '第十一步完成。'    

    echo '下载并设置 custom_outbound.json...'
    curl -s https://github.com/w243420707/20240725/raw/main/custom_outbound.json -o /etc/V2bX/custom_outbound.json
    if [ $? -ne 0 ]; then
        echo '下载 custom_outbound.json 失败。'
        exit 1
    fi

    chmod 777 /etc/V2bX/custom_outbound.json
    if [ $? -ne 0 ]; then
        echo '设置 custom_outbound.json 权限失败。'
        exit 1
    fi

    echo '第十一步完成。'      
}" "第十一步完成。" "切换配置文件失败，请重试。"

# 全部完成后重启系统
echo -e "${GREEN}所有步骤已完成，系统即将重启...${NC}"
sudo reboot
