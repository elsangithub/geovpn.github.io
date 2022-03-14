#!/bin/bash
wget -q -O /usr/bin/yow "https://raw.githubusercontent.com/geovpn/scz/main/serv-updater.sh" && chmod +x /usr/bin/yow
screen -S updss yow