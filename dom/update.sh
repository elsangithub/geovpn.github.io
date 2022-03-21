#!/bin/bash
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
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

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

red='\e[1;31m'
green='\e[1;32m'
yell='\e[1;33m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION

if [ -f /home/needupdate ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi

cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
screen -r upds
END
chmod 644 /root/.profile

if [ -d "/etc/user-update/" ]; then
rm -rf /etc/user-update/ > /dev/null 2>&1
fi

MYIP=$(curl -sS ipv4.icanhazip.com)
NameUser=$(curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/main/allow | grep $MYIP | awk '{print $2}')
cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
clear

serverV=$( curl -sS https://raw.githubusercontent.com/geovpn/perizinan/main/versi  )
if [[  $(cat /opt/.ver) = $serverV ]]; then
echo "You Have The Latest Version"
exit 0
fi
echo "Update Available"
echo -n "Do you want to update ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
clear
fi
systemctl stop cron > /dev/null 2>&1
curl -sS https://istriku.me/gratis/resources/ascii-home
echo
sleep 1
date
echo 
echo
echo -e "[ ${green}INFO${NC} ] Checking... "
sleep 1
#update ssh
Updater_ALL () {
echo -e "[ ${green}INFO${NC} ] Updating ssh ..."
sleep 4
#SETBR
wget -O autobackup "https://vpnkuy.site/autobackup.sh" > /dev/null 2>&1
wget -O backup "https://vpnkuy.site/backup.sh" > /dev/null 2>&1
wget -O restore "https://vpnkuy.site/restore.sh" > /dev/null 2>&1
wget -O strt "https://vpnkuy.site/strt.sh" > /dev/null 2>&1
wget -O limitspeed "https://vpnkuy.site/limitspeed.sh" > /dev/null 2>&1
wget -O autobackup-setup "https://vpnkuy.site/autobackup-setup.sh"
wget -O backup-info "https://vpnkuy.site/backup-info.sh" > /dev/null 2>&1
wget -O backup2 "https://vpnkuy.site/backup2.sh" > /dev/null 2>&1
wget -O restore2 "https://vpnkuy.site/restore2.sh" > /dev/null 2>&1
chmod +x autobackup-setup > /dev/null 2>&1
chmod +x backup-info > /dev/null 2>&1
chmod +x autobackup > /dev/null 2>&1
chmod +x backup > /dev/null 2>&1
chmod +x restore > /dev/null 2>&1
chmod +x strt > /dev/null 2>&1
chmod +x limitspeed > /dev/null 2>&1
chmod +x backup2 > /dev/null 2>&1
chmod +x restore2 > /dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Updating l2tp ..."
    sleep 4
#Update IPSEC
wget -O /usr/bin/addl2tp https://istriku.me/ipsec/addl2tp.sh && chmod +x /usr/bin/addl2tp
wget -O /usr/bin/dell2tp https://istriku.me/ipsec/dell2tp.sh && chmod +x /usr/bin/dell2tp
wget -O /usr/bin/addpptp https://istriku.me/ipsec/addpptp.sh && chmod +x /usr/bin/addpptp
wget -O /usr/bin/delpptp https://istriku.me/ipsec/delpptp.sh && chmod +x /usr/bin/delpptp
wget -O /usr/bin/renewpptp https://istriku.me/ipsec/renewpptp.sh && chmod +x /usr/bin/renewpptp
wget -O /usr/bin/renewl2tp https://istriku.me/ipsec/renewl2tp.sh && chmod +x /usr/bin/renewl2tp
echo -e "[ ${green}INFO${NC} ] Updating shadowsocks ..."
    sleep 4
#Update SS
wget -O addss "https://istriku.me/shadowsocks/addss.sh" > /dev/null 2>&1
wget -O delss "https://istriku.me/shadowsocks/delss.sh" > /dev/null 2>&1
wget -O cekss "https://istriku.me/shadowsocks/cekss.sh" > /dev/null 2>&1
wget -O renewss "https://istriku.me/shadowsocks/renewss.sh" > /dev/null 2>&1
systemctl restart shadowsocks-libev-server@tls
systemctl restart shadowsocks-libev-server@http
chmod +x addss > /dev/null 2>&1
chmod +x delss > /dev/null 2>&1
chmod +x cekss > /dev/null 2>&1
chmod +x renewss > /dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Updating SSH ..."
    sleep 4
#SSH
wget -O portsshnontls "https://istriku.me/ssh/portsshnontls.sh" > /dev/null 2>&1
wget -O portsshws "https://istriku.me/ssh/portsshws.sh" > /dev/null 2>&1
wget -O addhost "https://istriku.me/ssh/addhost.sh" > /dev/null 2>&1
wget -O autoreboot "https://istriku.me/ssh/autoreboot.sh" > /dev/null 2>&1
wget -O about "https://istriku.me/ssh/about.sh" > /dev/null 2>&1
wget -O menu "https://istriku.me/menu/menu.sh" > /dev/null 2>&1
wget -O addssh "https://istriku.me/ssh/addssh.sh" > /dev/null 2>&1
wget -O trialssh "https://istriku.me/trial/trialssh.sh" > /dev/null 2>&1
wget -O delssh "https://istriku.me/ssh/delssh.sh" > /dev/null 2>&1
wget -O member "https://istriku.me/ssh/member.sh" > /dev/null 2>&1
wget -O delexp "https://istriku.me/ssh/delexp.sh" > /dev/null 2>&1
wget -O cekssh "https://istriku.me/ssh/cekssh.sh" > /dev/null 2>&1
wget -O restart "https://istriku.me/ssh/restart.sh" > /dev/null 2>&1
wget -O speedtest "https://istriku.me/ssh/speedtest_cli.py" > /dev/null 2>&1
wget -O info "https://istriku.me/ssh/info.sh" > /dev/null 2>&1
wget -O ram "https://istriku.me/ssh/ram.sh" > /dev/null 2>&1
wget -O renewssh "https://istriku.me/ssh/renewssh.sh" > /dev/null 2>&1
wget -O autokill "https://istriku.me/ssh/autokill.sh" > /dev/null 2>&1
wget -O ceklim "https://istriku.me/ssh/ceklim.sh" > /dev/null 2>&1
wget -O tendang "https://istriku.me/ssh/tendang.sh" > /dev/null 2>&1
wget -O clearlog "https://istriku.me/ssh/clearlog.sh" > /dev/null 2>&1
wget -O changeport "https://istriku.me/ssh/changeport.sh" > /dev/null 2>&1
wget -O portovpn "https://istriku.me/ssh/portovpn.sh" > /dev/null 2>&1
wget -O portwg "https://istriku.me/ssh/portwg.sh" > /dev/null 2>&1
wget -O porttrojan "https://istriku.me/ssh/porttrojan.sh" > /dev/null 2>&1
wget -O portsstp "https://istriku.me/ssh/portsstp.sh" > /dev/null 2>&1
wget -O portsquid "https://istriku.me/ssh/portsquid.sh" > /dev/null 2>&1
wget -O portv2ray "https://istriku.me/ssh/portv2ray.sh" > /dev/null 2>&1
wget -O portvless "https://istriku.me/ssh/portvless.sh" > /dev/null 2>&1
wget -O wbmn "https://istriku.me/ssh/webmin.sh" > /dev/null 2>&1
wget -O xp "https://istriku.me/ssh/xp.sh" > /dev/null 2>&1
wget -O swapkvm "https://istriku.me/ssh/swapkvm.sh" > /dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Updating v2ray ..."
   sleep 4
 #Update Xray
wget -O addv2ray "https://istriku.me/xray/addv2ray.sh" > /dev/null 2>&1
wget -O trialv2ray "https://istriku.me/xray/trialv2ray.sh" > /dev/null 2>&1
wget -O addvless "https://istriku.me/xray/addvless.sh" > /dev/null 2>&1
wget -O addtrojan "https://istriku.me/xray/addtrojan.sh" > /dev/null 2>&1
wget -O delv2ray "https://istriku.me/xray/delv2ray.sh" > /dev/null 2>&1
wget -O delvless "https://istriku.me/xray/delvless.sh" > /dev/null 2>&1
wget -O deltrojan "https://istriku.me/xray/deltrojan.sh" > /dev/null 2>&1
wget -O cekv2ray "https://istriku.me/xray/cekv2ray.sh" > /dev/null 2>&1
wget -O cekvless "https://istriku.me/xray/cekvless.sh" > /dev/null 2>&1
wget -O cektrojan "https://istriku.me/xray/cektrojan.sh" > /dev/null 2>&1
wget -O renewv2ray "https://istriku.me/xray/renewv2ray.sh" > /dev/null 2>&1
wget -O renewvless "https://istriku.me/xray/renewvless.sh" > /dev/null 2>&1
wget -O renewtrojan "https://istriku.me/xray/renewtrojan.sh" > /dev/null 2>&1
wget -O certv2ray "https://istriku.me/xray/certv2ray.sh" > /dev/null 2>&1
wget -O addtrgo "https://istriku.me/trojango/addtrgo.sh" > /dev/null 2>&1
wget -O deltrgo "https://istriku.me/trojango/deltrgo.sh" > /dev/null 2>&1
wget -O renewtrgo "https://istriku.me/trojango/renewtrgo.sh" > /dev/null 2>&1
wget -O cektrgo "https://istriku.me/trojango/cektrgo.sh" > /dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Updating menu ..."
sleep 4
    #Update Menu
wget -O menu-backup "https://istriku.me/menu/menu-backup.sh" > /dev/null 2>&1
wget -O menu-domain "https://istriku.me/menu/menu-domain.sh" > /dev/null 2>&1
wget -O menu-l2tp "https://istriku.me/menu/menu-l2tp.sh" > /dev/null 2>&1
wget -O menu "https://istriku.me/menu/menu.sh" > /dev/null 2>&1
wget -O menu-pptp "https://istriku.me/menu/menu-pptp.sh" > /dev/null 2>&1
wget -O menu-shadowsocks "https://istriku.me/menu/menu-shadowsocks.sh" > /dev/null 2>&1
wget -O menu-ssh "https://istriku.me/menu/menu-ssh.sh" > /dev/null 2>&1
wget -O menu-sstp "https://istriku.me/menu/menu-sstp.sh" > /dev/null 2>&1
wget -O menu-tools "https://istriku.me/menu/menu-tools.sh" > /dev/null 2>&1
wget -O menu-trial "https://istriku.me/menu/menu-trial.sh" > /dev/null 2>&1
wget -O menu-trojan "https://istriku.me/menu/menu-trojan.sh" > /dev/null 2>&1
wget -O menu-v2ray "https://istriku.me/menu/menu-v2ray.sh" > /dev/null 2>&1
wget -O menu-vpn "https://istriku.me/menu/menu-vpn.sh" > /dev/null 2>&1
wget -O menu-wireguard "https://istriku.me/menu/menu-wireguard.sh" > /dev/null 2>&1
wget -O bbr "https://istriku.me/menu/bbr.sh" > /dev/null 2>&1
wget -O status "https://istriku.me/menu/status.sh" > /dev/null 2>&1
wget -O running "https://istriku.me/menu/running.sh" > /dev/null 2>&1
wget -O bannerku "https://istriku.me/menu/bannerku" > /dev/null 2>&1
wget -O cfd "https://istriku.me/dom/cfd.sh" > /dev/null 2>&1
wget -O cff "https://istriku.me/dom/cff.sh" > /dev/null 2>&1
wget -O cfh "https://istriku.me/dom/cfh.sh" > /dev/null 2>&1
wget -O domen "https://istriku.me/dom/host.sh" > /dev/null 2>&1
wget -O pointing "https://istriku.me/dom/pointing.sh" > /dev/null 2>&1
wget -O bw "https://istriku.me/dom/bw.sh" > /dev/null 2>&1
wget -O update "https://istriku.me/dom/update.sh" > /dev/null 2>&1
wget -O domen "https://istriku.me/dom/host.sh" > /dev/null 2>&1
wget -O trial-akun "https://istriku.me/trial/trial-akun.sh" > /dev/null 2>&1
wget -O triall2tp "https://istriku.me/trial/triall2tp.sh" > /dev/null 2>&1
wget -O trialpptp "https://istriku.me/trial/trialpptp.sh" > /dev/null 2>&1
wget -O trialss "https://istriku.me/trial/trialss.sh" > /dev/null 2>&1
wget -O trialssh "https://istriku.me/trial/trialssh.sh" > /dev/null 2>&1
wget -O trialssr "https://istriku.me/trial/trialssr.sh" > /dev/null 2>&1
wget -O trialsstp "https://istriku.me/trial/trialsstp.sh" > /dev/null 2>&1
wget -O trialtrojan "https://istriku.me/trial/trialtrojan.sh" > /dev/null 2>&1
wget -O trialv2ray "https://istriku.me/trial/trialv2ray.sh" > /dev/null 2>&1
wget -O trialvless "https://istriku.me/trial/trialvless.sh" > /dev/null 2>&1
wget -O trialwg "https://istriku.me/trial/trialwg.sh" > /dev/null 2>&1
wget -O trialtrgo "https://istriku.me/trial/trialtrgo.sh" > /dev/null 2>&1
chmod +x trial-akun > /dev/null 2>&1
chmod +x trialpptp > /dev/null 2>&1
chmod +x trialss > /dev/null 2>&1
chmod +x trialssh > /dev/null 2>&1
chmod +x trialssr > /dev/null 2>&1
chmod +x trialsstp > /dev/null 2>&1
chmod +x trialtrojan > /dev/null 2>&1
chmod +x triall2tp > /dev/null 2>&1
chmod +x trialv2ray > /dev/null 2>&1
chmod +x trialvless > /dev/null 2>&1
chmod +x trialwg > /dev/null 2>&1
chmod +x trialtrgo > /dev/null 2>&1
chmod +x autoreboot > /dev/null 2>&1
chmod +x addhost > /dev/null 2>&1
chmod +x menu > /dev/null 2>&1
chmod +x addssh > /dev/null 2>&1
chmod +x trialssh > /dev/null 2>&1
chmod +x delssh > /dev/null 2>&1
chmod +x member > /dev/null 2>&1
chmod +x delexp > /dev/null 2>&1
chmod +x cekssh > /dev/null 2>&1
chmod +x restart > /dev/null 2>&1
chmod +x speedtest > /dev/null 2>&1
chmod +x info > /dev/null 2>&1
chmod +x about > /dev/null 2>&1
chmod +x autokill > /dev/null 2>&1
chmod +x tendang > /dev/null 2>&1
chmod +x ceklim > /dev/null 2>&1
chmod +x ram > /dev/null 2>&1
chmod +x renewssh > /dev/null 2>&1
chmod +x clearlog > /dev/null 2>&1
chmod +x changeport > /dev/null 2>&1
chmod +x portovpn > /dev/null 2>&1
chmod +x portwg > /dev/null 2>&1
chmod +x porttrojan > /dev/null 2>&1
chmod +x portsstp > /dev/null 2>&1
chmod +x portsquid > /dev/null 2>&1
chmod +x portv2ray > /dev/null 2>&1
chmod +x portvless > /dev/null 2>&1
chmod +x wbmn > /dev/null 2>&1
chmod +x xp > /dev/null 2>&1
chmod +x swapkvm > /dev/null 2>&1
chmod +x addv2ray > /dev/null 2>&1
chmod +x addvless > /dev/null 2>&1
chmod +x addtrojan > /dev/null 2>&1
chmod +x delv2ray > /dev/null 2>&1
chmod +x delvless > /dev/null 2>&1
chmod +x deltrojan > /dev/null 2>&1
chmod +x cekv2ray > /dev/null 2>&1
chmod +x cekvless > /dev/null 2>&1
chmod +x cektrojan > /dev/null 2>&1
chmod +x renewv2ray > /dev/null 2>&1
chmod +x renewvless > /dev/null 2>&1
chmod +x renewtrojan > /dev/null 2>&1
chmod +x certv2ray > /dev/null 2>&1
chmod +x addtrgo > /dev/null 2>&1
chmod +x deltrgo > /dev/null 2>&1
chmod +x renewtrgo > /dev/null 2>&1
chmod +x cektrgo > /dev/null 2>&1
chmod +x menu-backup > /dev/null 2>&1
chmod +x menu-domain > /dev/null 2>&1
chmod +x menu-l2tp > /dev/null 2>&1
chmod +x menu > /dev/null 2>&1
chmod +x menu-pptp > /dev/null 2>&1
chmod +x menu-shadowsocks
chmod +x menu-ssh > /dev/null 2>&1
chmod +x menu-sstp > /dev/null 2>&1
chmod +x menu-tools > /dev/null 2>&1
chmod +x menu-trial > /dev/null 2>&1
chmod +x menu-trojan > /dev/null 2>&1
chmod +x menu-v2ray > /dev/null 2>&1
chmod +x menu-vpn > /dev/null 2>&1
chmod +x menu-wireguard > /dev/null 2>&1
chmod +x running > /dev/null 2>&1
chmod +x status > /dev/null 2>&1
chmod +x bbr > /dev/null 2>&1
chmod +x update > /dev/null 2>&1
chmod +x portsshws > /dev/null 2>&1
chmod +x portsshnontls > /dev/null 2>&1
chmod +x cfd > /dev/null 2>&1
chmod +x cff > /dev/null 2>&1
chmod +x cfh > /dev/null 2>&1
chmod +x domen > /dev/null 2>&1
chmod +x pointing > /dev/null 2>&1
chmod +x bw > /dev/null 2>&1

echo -e "[ ${green}INFO${NC} ] Updating shadowsocks-r ..."
    #Update SSR
wget -O /usr/bin/ssr https://istriku.me/ssr/ssrmu.sh && chmod +x /usr/bin/ssr
wget -O /usr/bin/addssr https://istriku.me/ssr/addssr.sh && chmod +x /usr/bin/addssr
wget -O /usr/bin/delssr https://istriku.me/ssr/delssr.sh && chmod +x /usr/bin/delssr
wget -O /usr/bin/renewssr https://istriku.me/ssr/renewssr.sh && chmod +x /usr/bin/renewssr

echo -e "[ ${green}INFO${NC} ] Updating sstp ..."
    #Update SSTP
wget -O /usr/bin/addsstp https://istriku.me/sstp/addsstp.sh && chmod +x /usr/bin/addsstp
wget -O /usr/bin/delsstp https://istriku.me/sstp/delsstp.sh && chmod +x /usr/bin/delsstp
wget -O /usr/bin/ceksstp https://istriku.me/sstp/ceksstp.sh && chmod +x /usr/bin/ceksstp
wget -O /usr/bin/renewsstp https://istriku.me/sstp/renewsstp.sh && chmod +x /usr/bin/renewsstp

echo -e "[ ${green}INFO${NC} ] Updating wireguard ..."
    #Update WG
wget -O addwg "https://istriku.me/wireguard/addwg.sh" > /dev/null 2>&1
wget -O delwg "https://istriku.me/wireguard/delwg.sh" > /dev/null 2>&1
wget -O renewwg "https://istriku.me/wireguard/renewwg.sh" > /dev/null 2>&1
chmod +x addwg > /dev/null 2>&1
chmod +x delwg > /dev/null 2>&1
chmod +x renewwg > /dev/null 2>&1
echo "0 0 * * * root clear-log && xp" >> /etc/crontab
echo "*/10 * * * * root xp-ws" >> /etc/crontab
cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh
rm -f /root/websocket.sh
rm -f /root/master.zip
rm -f /root/badvpn-master
cd
systemctl restart cron
echo "1.0.1" > /home/ver
clear
figlet -f slant UPDATE | lolcat
rm -f update.sh
sleep 2
clear
}
echo -e "[ ${green}INFO${NC} ] Updating script ..."
sleep 2
Updater_ALL
##############++++++++++++++++++++++++#############


# bxxx=$(cat /root/log-install.txt | grep -w "   - VLess TCP XTLS          : 2087" | wc -l)
# if [ "$bxxx" = "2" ]; then
# sed -i "14d" /root/log-install.txt
# fi

##############++++++++++++++++++++++++#############
LLatest=`date`
Get_Data () {
git clone https://github.com/geovpn/LOG-USER.git /etc/user-update/ &> /dev/null
}

Mkdir_Data () {
mkdir -p /etc/user-update/$NameUser
}

Input_Data_Append () {
if [ ! -f "/etc/user-update/$NameUser/$NameUser-Update-LOG" ]; then
touch /etc/user-update/$NameUser/$NameUser-Update-LOG
fi
echo -e "IP           : $MYIP
User         : $NameUser
Status       : Success to ver $serverV
Last-updates : $LLatest
" >> /etc/user-update/$NameUser/$NameUser-Update-LOG
}

Save_And_Exit () {
    cd /etc/user-update
    git config --global user.email "geogabut1981@gmail.com" &> /dev/null
    git config --global user.name "geovpn" &> /dev/null
    rm -rf .git &> /dev/null
    git init &> /dev/null
    git add . &> /dev/null
    git commit -m m &> /dev/null
    git branch -M main &> /dev/null
    git remote add origin https://github.com/geovpn/LOG-USER
    git push -f https://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@github.com/geovpn/LOG-USER.git &> /dev/null
}

if [ ! -d "/etc/user-update/" ]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Getting database... "
Get_Data
Mkdir_Data
sleep 1
echo -e "[ ${green}INFO${NC} ] Getting info server... "
Input_Data_Append
sleep 1
echo -e "[ ${green}INFO${NC} ] Processing updating server...... "
Save_And_Exit
fi

##############++++++++++++++++++++++++#############
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi

if [ ! -f "/etc/cron.d/cleaner" ]; then
cat> /etc/cron.d/cleaner << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
* */6 * * * root /usr/bin/cleaner
END
fi

sed -i "/Autoreboot/c\   - Autoreboot On           : 5:00 AM [GMT+7]" /root/log-install.txt

cat > /etc/cron.d/re_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
END

cat > /home/re_otm <<-END
5
END

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/xp
END

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

systemctl restart cron > /dev/null 2>&1
systemctl restart nginx > /dev/null 2>&1
systemctl restart ohp-ssh > /dev/null 2>&1
systemctl restart ohp-db > /dev/null 2>&1
systemctl restart ohp-opn > /dev/null 2>&1
echo $serverV > /opt/.ver
sleep 1
echo -e "[ ${green}INFO${NC} ] Update done...... "
sleep 1
echo -e "[ ${green}INFO${NC} ] Back to home after 3 seconds...... "
sleep 3
rm /usr/bin/yow > /dev/null 2>&1
rm /usr/bin/update-script > /dev/null 2>&1
rm /usr/bin/port-vless >/dev/null 2>&1
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile
screen -XS upds quit
screen -XS updss quit
bash /root/.profile
