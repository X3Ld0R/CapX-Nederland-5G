#!/bin/bash
# CapX Core 2024 by Jeffrey Timmer | Forat Selman | Philip Prins
# Based on opensource core

issue=`head -1 /etc/issue 2>/dev/null`
case $issue in
    Ubuntu\ 22.04*)
        OS=ubuntu2204
        ;;
esac

if [ -z $OS ]
then
    >&2 echo "Unsupported OS"
    exit
fi

if [ "$OS" = "ubuntu2204" ]
then
    apt update
    apt install -y vim net-tools ca-certificates curl gnupg nodejs iputils-ping git
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo y
    echo
    NODE_MAJOR=20
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    echo y | "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    apt update
    sudo apt install mongodb-org nodejs -y
    add-apt-repository ppa:open5gs/latest
    apt update
    apt install open5gs
    curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -
    systemctl restart mongod
    git clone https://github.com/X3Ld0R/CapX-Nederland-5G.git
    cp -fR /root/CapX-Nederland-5G/usr/lib/node_modules/open5gs/next/* /usr/lib/node_modules/open5gs/.next/
    cp -fR /root/CapX-Nederland-5G/Open5GS/* /etc/open5gs/ 
    cp -fR /root/CapX-Nederland-5G/open5gs-webui.service /lib/systemd/system/
fi

systemctl enable open5gs-mmed
systemctl enable open5gs-sgwud
systemctl enable open5gs-mmed
systemctl enable open5gs-sgwcd
systemctl enable open5gs-smfd
systemctl enable open5gs-amfd
systemctl enable open5gs-sgwud
systemctl enable open5gs-upfd
systemctl enable open5gs-hssd
systemctl enable open5gs-pcrfd
systemctl enable open5gs-nrfd
systemctl enable open5gs-scpd
systemctl enable open5gs-seppd
systemctl enable open5gs-ausfd
systemctl enable open5gs-udmd
systemctl enable open5gs-pcfd
systemctl enable open5gs-nssfd
systemctl enable open5gs-bsfd
systemctl enable open5gs-udrd
systemctl enable open5gs-webui
systemctl enable mongod

echo 
echo "Install complete -- Please connect your browser to port 9999"

RESTART_OUTPUT="Please restart this server by running 'reboot'"
echo $RESTART_OUTPUT

