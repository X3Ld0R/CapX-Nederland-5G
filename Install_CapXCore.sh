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

# Vraag de interface naam
read -p "Enter the interface name (e.g., enp0s25): " interface

# Vraag de IP-adressen en labels voor de verschillende services
read -p "Enter the IP address for s1ap (e.g., 10.100.100.2/23): " s1ap_ip
read -p "Enter the IP address for gtpu (e.g., 10.100.100.6/23): " gtpu_ip
read -p "Enter the IP address for upf (e.g., 10.100.100.7/23): " upf_ip
read -p "Enter the gateway IP (e.g., 10.100.100.254): " gateway

# Netplan configuratiebestand maken
cat <<EOL > /etc/netplan/00-installer-config.yaml
network:
  ethernets:
    $interface:
      dhcp4: no
      addresses:
       - $s1ap_ip
       - $gtpu_ip
       - $upf_ip
      routes:
        - to: default
          via: $gateway
      nameservers:
       addresses: [1.0.0.1, 1.1.1.1]
  version: 2
EOL
    netplan apply
    cp -fR /root/CapX-Nederland-5G/00-installer-config.yaml /etc/netplan/
    apt update
    apt install -y vim net-tools ca-certificates curl gnupg nodejs iputils-ping git
    add-apt-repository ppa:open5gs/latest
    sudo apt update && sudo apt upgrade
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor    echo y
    apt update
    sudo apt install mongodb-org nodejs -y
    systemctl start mongod
    systemctl enable mongod 
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo NODE_MAJOR=20
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    apt update
    apt install nodejs -y
    curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -
    git clone https://github.com/X3Ld0R/CapX-Nederland-5G.git
    cp -fR /root/CapX-Nederland-5G/restart.sh /root/
    cp -fR /root/CapX-Nederland-5G/usr/lib/node_modules/open5gs/next/* /usr/lib/node_modules/open5gs/.next/
    cp -fR /root/CapX-Nederland-5G/Open5GS/* /etc/open5gs/ 
    cp -fR /root/CapX-Nederland-5G/open5gs-webui.service /lib/systemd/system/
    sysctl -w net.ipv4.ip_forward=1
    sysctl -w net.ipv6.conf.all.forwarding=1
    iptables -t nat -A POSTROUTING -s 10.45.0.1/16 ! -o ogstun -j MASQUERADE
    ip6tables -t nat -A POSTROUTING -s 2001:db8:cafe::/48 ! -o ogstun -j MASQUERADE
    iptables -I INPUT -i ogstun -j ACCEPT
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

