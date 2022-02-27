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
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
chck_pid(){
	PID=`ps -ef |grep -v grep | grep wg0 |awk '{print $2}'`
	if [[ ! -z "${PID}" ]]; then
			echo -e "Current status: ${Green_font_prefix} Installed${Font_color_suffix} & ${Green_font_prefix}Running${Font_color_suffix}"
		else
			echo -e "Current status: ${Green_font_prefix} Installed${Font_color_suffix} but ${Red_font_prefix}Not Running${Font_color_suffix}"
		fi
}

while true $x != "ok"
do
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo -e "\E[44;1;39m                      ⇱ WIREGUARD MENU ⇲                      \E[0m"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
chck_pid
echo -e "
[${GREEN}01${NC}] ${color1} •${color3}$bd Create Wireguard Account
[${GREEN}02${NC}] ${color1} •${color3}$bd Deleting Wireguard Account
[${GREEN}03${NC}] ${color1} •${color3}$bd Cek User Login Wireguard
[${GREEN}04${NC}] ${color1} •${color3}$bd Extending Wireguard Account Active Life
[${GREEN}05${NC}] ${color1} •${color3}$bd Check Wireguard User Interface

[00] • Back to Main Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m${NC}"
echo ""
echo -ne "Select menu : "; read x

case "$x" in 
   1 | 01)
   clear
   addwg
   break
   ;;
   2 | 02)
   clear
   delwg
   break
   ;;
   3 | 03)
   clear
   cekwg
   break
   ;;
   4 | 04)
   clear
   renewwg
   break
   ;;
   5 | 05)
   clear
   wg show
   read -n 1 -s -r -p "Press any key to back on menu"
   menu-wireguard
   break
   ;;
   0 | 00)
   clear
   menu-vpn
   break
   ;;
   *)
   clear
esac
done
#fim
