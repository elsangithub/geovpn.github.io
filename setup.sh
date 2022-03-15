#!/bin/bash
# ==========================================
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
# https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow 
MYIP=$(curl -sS ipinfo.io/ip)
Name=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipinfo.io/ip)
    IZIN=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}

clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi

echo -e "[ ${tyblue}NOTES${NC} ] Before we go.. "
sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] I need check your headers first.."
sleep 2
echo -e "[ ${green}INFO${NC} ] Checking headers"
sleep 1
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  sleep 2
  echo -e "[ ${yell}WARNING${NC} ] Try to install ...."
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  apt-get --yes install $REQUIRED_PKG
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] If error you need.. to do this"
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 1. apt update -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 2. apt upgrade -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 3. apt dist-upgrade -y"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] 4. reboot"
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] After rebooting"
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] Then run this script again"
  echo -e "[ ${tyblue}NOTES${NC} ] if you understand then tap enter now"
  read
else
  echo -e "[ ${green}INFO${NC} ] Oke installed"
fi

ttet=`uname -r`
ReqPKG="linux-headers-$ttet"
if ! dpkg -s $ReqPKG  >/dev/null 2>&1; then
  rm /root/setup.sh >/dev/null 2>&1 
  exit
else
  clear
fi


secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
screen -r setup
END
chmod 644 /root/.profile

echo -e "[ ${green}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Aight good ... installation file is ready"
sleep 2
echo -ne "[ ${green}INFO${NC} ] Check permission : "

PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
green "Permission Accepted!"
else
red "Permission Denied!"
rm setup.sh > /dev/null 2>&1
sleep 10
exit 0
fi

sleep 3
# ==========================================
# Link Hosting Kalian Untuk Ssh Vpn
geovpn="geovpn.github.io/ssh"
# Link Hosting Kalian Untuk Sstp
geovpnn="geovpn.github.io/sstp"
# Link Hosting Kalian Untuk Ssr
geovpnnn="geovpn.github.io/ssr"
# Link Hosting Kalian Untuk Shadowsocks
geovpnnnn="geovpn.github.io/shadowsocks"
# Link Hosting Kalian Untuk Wireguard
geovpnnnnn="geovpn.github.io/wireguard"
# Link Hosting Kalian Untuk Xray
geovpnnnnnn="geovpn.github.io/xray"
# Link Hosting Kalian Untuk Ipsec
geovpnnnnnnn="geovpn.github.io/ipsec"
# Link Hosting Kalian Untuk Backup
geovpnnnnnnnn="geovpn.github.io/backup"
# Link Hosting Kalian Untuk Websocket
geovpnnnnnnnnn="geovpn.github.io/websocket"
# Link Hosting Kalian Untuk Ohp
geovpnnnnnnnnnn="geovpn.github.io/ohp"
#######################################################
if [ -f "/etc/xray/domain" ]; then
echo "Script Already Installed"
exit 0
fi
echo ""
echo -e "[ ${green}INFO${NC} ] Script Already Installed"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to install again ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
rm setup.sh
sleep 10
exit 0
else
clear
fi
fi

apt-get update -y > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
#install figlet & lolcat
apt-get install figlet -y > /dev/null 2>&1
apt-get install ruby -y > /dev/null 2>&1
gem install lolcat > /dev/null 2>&1
clear
sudo hostnamectl set-hostname Geo-Project
clear
mkdir /var/lib/geovpnstore;
echo "IP=" >> /var/lib/geovpnstore/ipvps.conf
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation CLOUDFLARE${NC}"
sleep 5
wget https://${geovpn}/cf.sh && chmod +x cf.sh && ./cf.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "CLOUDFLARE Successfully Installed..."
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation XRAY${NC}"
sleep 5
wget https://${geovpnnnnnn}/ins-xray.sh && chmod +x ins-xray.sh && screen -S xray ./ins-xray.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "XRAY Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation SSH OVPN${NC}"
sleep 5
wget https://${geovpn}/ssh-vpn.sh && chmod +x ssh-vpn.sh && screen -S ssh-vpn ./ssh-vpn.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "SSH OVPN Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation SSTP${NC}"
sleep 5
wget https://${geovpnn}/sstp.sh && chmod +x sstp.sh && screen -S sstp ./sstp.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "SSTP Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation SHADOWSOCKSR${NC}"
sleep 5
wget https://${geovpnnn}/ssr.sh && chmod +x ssr.sh && screen -S ssr ./ssr.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "SHADOWSOCKSR Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation SHADOWSOCKS${NC}"
sleep 5
wget https://${geovpnnnn}/sodosok.sh && chmod +x sodosok.sh && screen -S ss ./sodosok.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "SHADOWSOCKS-OBFS Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation WIREGUARD${NC}"
sleep 5
wget https://${geovpnnnnn}/wg.sh && chmod +x wg.sh && screen -S wg ./wg.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "WIREGUARD Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation L2TP VPN${NC}"
sleep 5
wget https://${geovpnnnnnnn}/ipsec.sh && chmod +x ipsec.sh && screen -S ipsec ./ipsec.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "L2TP Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation SET-BR${NC}"
sleep 5
wget https://${geovpnnnnnnnn}/set-br.sh && chmod +x set-br.sh && ./set-br.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "SET-BR Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo " "
echo -e " ${GREEN}S E T T I N G UP${NC}"
sleep 1
echo " "
echo -e " ${CYAN}P R O G R E S S I O N ${NC}"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation WEBSOCKET CDN${NC}"
sleep 5
wget https://${geovpnnnnnnnnn}/edu.sh && chmod +x edu.sh && ./edu.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "WEBSOCKET CDN Successfully Installed..."
sleep 1
clear
curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home
sleep 1
echo -e "[ ${GREEN}S E T T I N G UP${NC} ]"
sleep 1
echo " "
echo -e "[ ${CYAN}P R O G R E S S I O N${NC} ]"
sleep 1
echo " "
echo -e "[ ${GREEN}P R O C E S S I N G${NC} ]       ${ORANGE}Installation OHP${NC}"
sleep 5
echo " "
wget https://${geovpnnnnnnnnnn}/ohp.sh && chmod +x ohp.sh && ./ohp.sh > /dev/null 2>&1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
yellow "Open HTTP Puncher Successfully Installed..."
sleep 1
clear
rm -f /root/ssh-vpn.sh
rm -f /root/sstp.sh
rm -f /root/wg.sh
rm -f /root/ss.sh
rm -f /root/ssr.sh
rm -f /root/ins-xray.sh
rm -f /root/ipsec.sh
rm -f /root/set-br.sh
rm -f /root/edu.sh
rm -f /root/ohp.sh
cat <<EOF> /etc/systemd/system/autosett.service
[Unit]
Description=autosetting
Documentation=https://t.me/sampiiiiu

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/set.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable autosett
wget -O /etc/set.sh "https://${geovpn}/set.sh"
chmod +x /etc/set.sh
wget -q -O /usr/bin/.ascii-home "https://raw.githubusercontent.com/geovpn/perizinan/main/ascii-home"
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
importantfile
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/versi  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
echo " "
echo "=================-geovpn Project-==================" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "================================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 443, 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200, SSL 990"  | tee -a log-install.txt
echo "   - Stunnel5                : 443, 445, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 443, 109, 143"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8080"  | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 89"  | tee -a log-install.txt
echo "   - Wireguard               : 7070"  | tee -a log-install.txt
echo "   - L2TP/IPSEC VPN          : 1701"  | tee -a log-install.txt
echo "   - PPTP VPN                : 1732"  | tee -a log-install.txt
echo "   - SSTP VPN                : 444"  | tee -a log-install.txt
echo "   - Shadowsocks-R           : 1443-1543"  | tee -a log-install.txt
echo "   - SS-OBFS TLS             : 2443-2543"  | tee -a log-install.txt
echo "   - SS-OBFS HTTP            : 3443-3543"  | tee -a log-install.txt
echo "   - XRAYS Vmess TLS         : 8443"  | tee -a log-install.txt
echo "   - XRAYS Vmess None TLS    : 80"  | tee -a log-install.txt
echo "   - XRAYS Vless TLS         : 2083"  | tee -a log-install.txt
echo "   - XRAYS Vless None TLS    : 2095"  | tee -a log-install.txt
echo "   - XRAYS Trojan            : 2087"  | tee -a log-install.txt
echo "   - Websocket TLS           : 443"   | tee -a log-install.txt
echo "   - Websocket None TLS      : 8880"  | tee -a log-install.txt
echo "   - Websocket Ovpn          : 2086"  | tee -a log-install.txt
echo "   - OHP_SSH                 : 8181"  | tee -a log-install.txt
echo "   - OHP_Dropbear            : 8282"  | tee -a log-install.txt
echo "   - OHP_OpenVPN             : 8383"  | tee -a log-install.txt
echo "   - Tr Go                   : 2053"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 05.00 GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   - Dev/Main                : Adit Anak Sumbawa"  | tee -a log-install.txt
echo "   - Recode                  : Adit Ardiansyah" | tee -a log-install.txt
echo "   - Telegram                : T.me/sampiiiiu"  | tee -a log-install.txt
echo "   - Instagram               : @geo_gabuter"  | tee -a log-install.txt
echo "   - Whatsapp                : 082339191527"  | tee -a log-install.txt
echo "   - Facebook                : Ardiansyah" | tee -a log-install.txt
echo "=======-Script Created By GeoVPN Project-=======" | tee -a log-install.txt
echo -ne "[ ${yell}WARNING${NC} ] Do you want to reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
