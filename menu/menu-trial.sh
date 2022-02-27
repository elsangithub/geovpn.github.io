#!/bin/bash
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
yl='\e[32;1m'
bl='\e[36;1m'
gl='\e[32;1m'
rd='\e[31;1m'
mg='\e[0;95m'
blu='\e[34m'
op='\e[35m'
or='\033[1;33m'
bd='\e[1m'
color1='\e[031;1m'
color2='\e[34;1m'
color3='\e[0m'
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
CEKEXPIRED () {
    today=$(date -d +1day +%Y-%m-%d)
    Exp1=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | grep $MYIP | awk '{print $3}')
    if [[ $today < $Exp1 ]]; then
    echo -e "\e[32mSTATUS SCRIPT AKTIF...\e[0m"
    else
    echo -e "\e[31mSCRIPT ANDA EXPIRED!\e[0m";
    echo -e "\e[31mRenew IP letak tempoh banyak kit okay? hehe syg ktk #\e[0m"
    exit 0
fi
}
IZIN=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | awk '{print $4}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
CEKEXPIRED
else
echo -e "\e[31mPermission Denied!\e[0m";
echo -e "\e[31mDaftar Atau Renew IP VPS Dulu ke ADMIN#\e[0m"
exit 0
fi
clear 
x="ok"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[44;1;39m                    ⇱ TRIAL MENU GENERATOR ⇲                  \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\033[1;37mNB: Trial account will not logged into create log user\033[0m
\033[1;32mTrial-Generator\033[0m :

[${GREEN}01${NC}] ${color1} •${color3}$bd Generate Trial SSH & OpenVPN
[${GREEN}02${NC}] ${color1} •${color3}$bd Generate Trial Wireguard
[${GREEN}03${NC}] ${color1} •${color3}$bd Generate Trial L2TP
[${GREEN}04${NC}] ${color1} •${color3}$bd Generate Trial PPTP
[${GREEN}05${NC}] ${color1} •${color3}$bd Generate Trial SSTP
[${GREEN}06${NC}] ${color1} •${color3}$bd Generate Trial Shadowsocks-R
[${GREEN}07${NC}] ${color1} •${color3}$bd Generate Trial Shadowsocks
[${GREEN}08${NC}] ${color1} •${color3}$bd Generate Trial Vmess
[${GREEN}09${NC}] ${color1} •${color3}$bd Generate Trial VLESS
[${GREEN}10${NC}] ${color1} •${color3}$bd Generate Trial Trojan-GFW
[${GREEN}11${NC}] ${color1} •${color3}$bd Generate Trial Trojan-GO

[00] • Back to Main Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo ""
echo -ne "Select menu : "; read x

case "$x" in 
   1 | 01)
   clear
   trialssh
   ;;
   2 | 02)
   clear
   trialwg
   ;;
   3 | 03)
   clear
   triall2tp
   ;;
   4 | 04)
   clear
   trialpptp
   ;;
   5 | 05)
   clear
   trialsstp
   ;;
   6 | 06)
   clear
   trialssr
   ;;
   7 | 07)
   clear
   trialss
   ;;
   8 | 08)
   clear
   trialv2ray
   ;;
   9 | 09)
   clear
   trialvless
   ;;
   10)
   clear
   trialtrojan
   ;;
   11)
   clear
   trialtrgo
   ;;
   0 | 00)
   clear
   menu
   ;;
   *)
   menu
esac

#fim

