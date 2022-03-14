#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
token="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"
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
MYIP=$(curl -sS ipv4.icanhazip.com)
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
    MYIP=$(curl -sS ipv4.icanhazip.com)
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

mkdir -p /var/lib/scrz-prem >/dev/null 2>&1
echo "IP=" >> /var/lib/scrz-prem/ipvps.conf

x="ok"
while true $x != "ok"
do
echo -e "[ ${green}INFO${NC} ] Select core : " 
echo -e "[ ${yell}*${NC} ] 1. V2RAY"
echo -e "[ ${yell}*${NC} ] 2. XRAY"
echo " =--------------="
echo -ne "[ ${red}#${NC} ] Choice : "; read x
case "$x" in
   1)
   coreselect="v2ray"
   green "V2RAY Selected"
   sleep 3
   break
   ;;
   2)
   coreselect="xray"
   green "XRAY Selected"
   sleep 3
   break
   ;;
   *)
   echo -e "\n\033[1;31mNot Valid!\033[0m"
   sleep .1
esac
done

if [ -f "/etc/$coreselect/domain" ]; then
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

echo ""
wget -q https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dependencies
chmod +x dependencies 
screen -S depen ./dependencies
rm dependencies


if [ -f "/etc/$coreselect/domain" ]; then
clear
echo ""
domainbefore=`cat /etc/$coreselect/domain`
echo -e "[ ${green}INFO${NC} ] Current domain : $domainbefore"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to change your domain before ? (y/n)? "
read answer
    if [ "$answer" == "${answer#[Yy]}" ] ;then
        echo -ne
        cp /etc/$coreselect/domain /root/scdomain
        cp /etc/$coreselect/domain /root/domain
    else
        clear
        yellow "Change Domain for vmess/vless/trojan dll"
        echo " "
        read -rp "Input ur domain : " -e pp
            if [ -z $pp ]; then
                echo -e "
                Nothing input for domain!
                Then a random domain will be created
                "
                sleep 2
                sub=scvps`</dev/urandom tr -dc a-z0-9 | head -c4`
                echo "peler=${sub}" > /root/scdomain
            else
                echo "peler=$pp" > /root/scdomain
            fi
        curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/cf.sh" && chmod +x cf.sh && ./cf.sh
    fi
else
clear
yellow "Add Domain for vmess/vless/trojan dll"
echo " "
read -rp "Input ur domain : " -e pp
    if [ -z $pp ]; then
        echo -e "
        Nothing input for domain!
        Then a random domain will be created
        "
        sleep 2
        sub=scvps`</dev/urandom tr -dc a-z0-9 | head -c4`
        echo "peler=${sub}" > /root/scdomain
    else
        echo "peler=$pp" > /root/scdomain
    fi
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/cf.sh" && chmod +x cf.sh && ./cf.sh
fi

curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/newmenu.sh" && mv newmenu.sh /usr/bin/menu  && chmod +x /usr/bin/menu
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/ssh/ssh-vpn.sh" && chmod +x ssh-vpn.sh && screen -S sshvpn ./ssh-vpn.sh
if [ "$coreselect" = "v2ray" ]; then
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/v2ray/ins-vt.sh" && chmod +x ins-vt.sh && screen -S insvt ./ins-vt.sh
elif [ "$coreselect" = "xray" ]; then
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/xray/ins-xray.sh" && chmod +x ins-xray.sh && screen -S insxray ./ins-xray.sh
fi
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/wireguard/wg.sh" && chmod +x wg.sh && screen -S wg ./wg.sh
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/sstp/sstp.sh" && chmod +x sstp.sh && screen -S sstp ./sstp.sh
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/ipsec/ipsec.sh" && chmod +x ipsec.sh && screen -S ipsec ./ipsec.sh
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/shadowsocks/ss.sh" && chmod +x ss.sh && screen -S ss ./ss.sh
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/shadowsocks/ssr.sh" && chmod +x ssr.sh && screen -S ssr ./ssr.sh
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/system/set-br.sh" && chmod +x set-br.sh && screen -S sbr ./set-br.sh
#extension
clear
sleep 1
echo -e "[ ${green}INFO${NC} ] Downloading extension !!"
sleep 1
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/xray/xtls.sh" && mv xtls.sh /usr/bin/xtls && chmod +x /usr/bin/xtls && xtls && rm -f /usr/bin/xtls
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/menu_all/setting-menu.sh" && mv setting-menu.sh /usr/bin/setting-menu && chmod +x /usr/bin/setting-menu
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/menu_all/autokill-menu.sh" && mv autokill-menu.sh /usr/bin/autokill-menu && chmod +x /usr/bin/autokill-menu
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/menu_all/info-menu.sh" && mv info-menu.sh /usr/bin/info-menu && chmod +x /usr/bin/info-menu
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/menu_all/system-menu.sh" && mv system-menu.sh /usr/bin/system-menu && chmod +x /usr/bin/system-menu
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/menu_all/trial-menu.sh" && mv trial-menu.sh /usr/bin/trial-menu && chmod +x /usr/bin/trial-menu


curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/kill-by-user.sh" && mv kill-by-user.sh /usr/bin/kill-by-user && chmod +x /usr/bin/kill-by-user
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/toolkit.sh" && mv toolkit.sh /usr/bin/importantfile && chmod +x /usr/bin/importantfile
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/status.sh" && mv status.sh /usr/bin/status && chmod +x /usr/bin/status
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/autoreboot.sh" && mv autoreboot.sh /usr/bin/autoreboot && chmod +x /usr/bin/autoreboot
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/limit-speed.sh" && mv limit-speed.sh /usr/bin/limit-speed && chmod +x /usr/bin/limit-speed
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/add-host.sh" && mv add-host.sh /usr/bin/add-host && chmod +x /usr/bin/add-host
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/akill-ws.sh" && mv akill-ws.sh /usr/bin/akill-ws && chmod +x /usr/bin/akill-ws
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/autokill-ws.sh" && mv autokill-ws.sh /usr/bin/autokill-ws && chmod +x /usr/bin/autokill-ws
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/restart-service.sh" && mv restart-service.sh /usr/bin/restart-service && chmod +x /usr/bin/restart-service
 
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/bot_panel/installer.sh" && mv installer.sh /usr/bin/installbot && chmod +x /usr/bin/installbot
curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/bot_panel/bbt.sh" && mv bbt.sh /usr/bin/bbt && chmod +x /usr/bin/bbt

sleep 2
echo -e "[ ${green}INFO${NC} ] Installing Successfully!!"
sleep 1
echo -e "[ ${green}INFO${NC} ] Dont forget to reboot later"
#=======[ end ] ======
curl -s -O https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/xp.sh && mv xp.sh /usr/bin/xp && chmod +x /usr/bin/xp
curl -s -O https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/dll/info.sh && mv info.sh /usr/bin/info && chmod +x /usr/bin/info

curl -s -O "https://${token}@raw.githubusercontent.com/geovpn/geovpn.github.io/main/xray/scz/resources/ascii-home" && mv ascii-home /usr/bin/.ascii-home 
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
curl -sS ifconfig.me > /etc/myipvps
echo " "
echo "=====================-[ SCVPS Premium ]-===================="
echo ""
echo "------------------------------------------------------------"
echo ""
echo ""
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - SSH Websocket           : 2082 [OFF]" | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 222" | tee -a log-install.txt
echo "   - OHP SSH                 : 6967" | tee -a log-install.txt
echo "   - OHP DBear               : 6968" | tee -a log-install.txt
echo "   - OHP OpenVPN             : 6969" | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200, SSL 442"  | tee -a log-install.txt
echo "   - Stunnel4                : 447, 777" | tee -a log-install.txt
echo "   - Dropbear                : 109, 143" | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8080" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7900" | tee -a log-install.txt
echo "   - Nginx                   : 81" | tee -a log-install.txt
echo "   - VLess TCP XTLS          : 2087" | tee -a log-install.txt
if [ "$coreselect" = "v2ray" ]; then
echo "   - V2RAY Vmess TLS         : 443" | tee -a log-install.txt
echo "   - V2RAY Vmess None TLS    : 80" | tee -a log-install.txt
echo "   - V2RAY Vless TLS         : 443" | tee -a log-install.txt
echo "   - V2RAY Vless None TLS    : 80" | tee -a log-install.txt
elif [ "$coreselect" = "xray" ]; then
echo "   - XRAY  Vmess TLS         : 443" | tee -a log-install.txt
echo "   - XRAY  Vmess None TLS    : 80" | tee -a log-install.txt
echo "   - XRAY  Vless TLS         : 443" | tee -a log-install.txt
echo "   - XRAY  Vless None TLS    : 80" | tee -a log-install.txt
fi

echo "   - Trojan                  : 8443" | tee -a log-install.txt
echo "   - Trojan Go               : 2096" | tee -a log-install.txt
echo "   - Wireguard               : 7070" | tee -a log-install.txt
echo "   - SSTP VPN                : 444" | tee -a log-install.txt
echo "   - L2TP/IPSEC VPN          : 1701" | tee -a log-install.txt
echo "   - PPTP VPN                : 1732" | tee -a log-install.txt
echo "   - SS-OBFS TLS             : 2443-2543" | tee -a log-install.txt
echo "   - SS-OBFS HTTP            : 3443-3543" | tee -a log-install.txt
echo "   - Shadowsocks-R           : 1443-1543" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On           : $aureb:00 $gg GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully automatic script" | tee -a log-install.txt
echo "   - VPS settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Change port" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""
echo ""
echo "------------------------------------------------------------"
echo ""
echo "===============-[ Script Created By SC-VPS ]-==============="
echo -e ""
echo ""
echo "" | tee -a log-install.txt
systemctl restart ohp-ssh > /dev/null 2>&1
systemctl restart ohp-db > /dev/null 2>&1
systemctl restart ohp-opn > /dev/null 2>&1
rm /root/cf.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /usr/bin/port-vless >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e "
"
systemctl restart ssrmu > /dev/null 2>&1
echo -ne "[ ${yell}WARNING${NC} ] Do you want to reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
