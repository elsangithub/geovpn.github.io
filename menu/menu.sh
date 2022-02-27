#!/bin/bash
MYIP=$(curl -sS ipv4.icanhazip.com)
#########################
IZIN=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | awk '{print $4}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
else
echo -e "\e[31mPermission Denied!\e[0m";
echo -e "\e[31mDaftar IP dalam github lok sayang okay? mun dah daftar tapi masih juak permission denied refresh dolok website ya hehe. Love you #\e[0m"
exit 0
fi
#EXPIRED
expired=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | grep $MYIP | awk '{print $3}')
echo $expired > /root/expired.txt
today=$(date -d +1day +%Y-%m-%d)
while read expired
do
	exp=$(echo $expired | curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | grep $MYIP | awk '{print $3}')
	if [[ $exp < $today ]]; then
		Exp2="\033[1;31mExpired\033[0m"
        else
        Exp2=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | grep $MYIP | awk '{print $3}')
	fi
done < /root/expired.txt
rm /root/expired.txt
Name=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | grep $MYIP | awk '{print $2}')
# Color Validation
#DF='\e[39m'
#Bold='\e[1m'
#Blink='\e[5m'
#yell='\e[33m'
#red='\e[31m'
#green='\e[32m'
#blue='\e[34m'
#PURPLE='\e[35m'
#cyan='\e[36m'
#Lred='\e[91m'
#Lgreen='\e[92m'
#Lyellow='\e[93m'
#NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
#yl='\e[32;1m'
#bl='\e[36;1m'
#gl='\e[32;1m'
#rd='\e[31;1m'
#mg='\e[0;95m'
#blu='\e[34m'
#op='\e[35m'
#or='\033[1;33m'
bd='\e[1m'
color1='\e[031;1m'
color2='\e[34;1m'
color3='\e[0m'
# VPS Information
#Domain
domain=$(cat /etc/xray/domain)
#Status certificate
#modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Download
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
#Sver=$(cat /home/version)
#tele=$(cat /home/contact)
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
IPVPS=$(curl -s ipinfo.io/ip )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
clear 
echo -e ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[44;1;39m                     ⇱ INFORMASI VPS ⇲                        \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e " ❇️$bd CPU Model            ${color1}•${color3}$bd $cname"
echo -e " ❇️$bd CPU Frequency        ${color1}•${color3}$bd $freq MHz"
echo -e " ❇️$bd Number Of Cores      ${color1}•${color3}$bd  $cores"
echo -e " ❇️$bd CPU Usage            ${color1}•${color3}$bd  $cpu_usage"
echo -e " ❇️$bd Operating System     ${color1}•${color3}$bd  "`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`	
echo -e " ❇️$bd Kernel               ${color1}•${color3}$bd  `uname -r`"
echo -e " ❇️$bd Total Amount Of RAM  ${color1}•${color3}$bd  $tram MB"
echo -e " ❇️$bd Used RAM             ${color1}•${color3}$bd $red $uram\e[0m MB"
echo -e " ❇️$bd Free RAM             ${color1}•${color3}$bd  $fram MB"
echo -e " ❇️$bd System Uptime        ${color1}•${color3}$bd  $uptime "
echo -e " ❇️$bd Isp Name             ${color1}•${color3}$bd  $ISP"
echo -e " ❇️$bd Domain               ${color1}•${color3}$bd  $domain"	
echo -e " ❇️$bd Ip Vps               ${color1}•${color3}$bd  $IPVPS"	
echo -e " ❇️$bd City                 ${color1}•${color3}$bd  $CITY"
echo -e " ❇️$bd Time                 ${color1}•${color3}$bd  $WKT"
echo -e " ❇️$bd Day                  ${color1}•${color3}$bd  $DAY"
echo -e " ❇️$bd Date                 ${color1}•${color3}$bd  $DATE"
echo -e " ❇️$bd Telegram             ${color1}•${color3}$bd  @sampiiiiu"
#echo -e " ❇️$bd Script Version       ${color1} •${color3}$bd  $Sver"
echo -e " ❇️$bd Certificate status   ${color1}•${color3}$bd  \e[33mExpired in ${tlsStatus} days\e[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e " ❇️$bd Traffic\e[0m       \e[33mToday      Yesterday     Month   "
echo -e " ❇️$bd Download\e[0m      $dtoday    $dyest       $dmon   \e[0m"
echo -e " ❇️$bd Upload\e[0m        $utoday    $uyest       $umon   \e[0m"
echo -e " ❇️$bd Total\e[0m       \033[0;36m  $ttoday    $tyest       $tmon  \e[0m "
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[44;1;39m                     ⇱ MENU  OPTIONS ⇲                        \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "
[${GREEN} 1 ${NC}]${color1} •${color3}$bd SSH & OpenVPN Section (${color2}menu-ssh${color3})
[${GREEN} 2 ${NC}]${color1} •${color3}$bd SSTP - L2TP - PPTP - Wireguard Section (${color2}menu-vpn${color3})
[${GREEN} 3 ${NC}]${color1} •${color3}$bd Shadowsocks & ShadowsocksR Section (${color2}menu-shadowsocks${color3})
[${GREEN} 4 ${NC}]${color1} •${color3}$bd V2ray Vmess & Vless Section (${color2}menu-v2ray${color3})
[${GREEN} 5 ${NC}]${color1} •${color3}$bd Trojan & TrojanGO Section (${color2}menu-trojan${color3})
[${GREEN} 6 ${NC}]${color1} •${color3}$bd Backup Section (${color2}menu-backup${color3})
[${GREEN} 7 ${NC}]${color1} •${color3}$bd Trial Account Section (${color2}menu-trial${color3})
[${GREEN} 8 ${NC}]${color1} •${color3}$bd System Tools Section (${color2}menu-tools${color3})

[${green}00${NC}]${color1} •${color3}$bd Back to exit Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[44;1;39m                     ⇱ GEOVPN PROJECT ⇲                       \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e " \e[33mClient Name    ${color1}•${color3}$bd $Name"
echo -e " \e[33mScript Expired ${color1}•${color3}$bd $Exp2"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e  ""
 read -p "  Select menu :  " menu
echo -e   ""
case $menu in
1)
menu-ssh
;;
2)
menu-vpn
;;
3)
menu-shadowsocks
;;
4)
menu-v2ray
;;
5)
menu-trojan
;;
6)
menu-backup
;;
7)
menu-trial
;;
8)
menu-tools
;;
9)
installbot
;;
0 | 00)
exit
;;
*)
menu
;;
esac
