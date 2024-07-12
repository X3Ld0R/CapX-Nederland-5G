# Installation Guide for CapX Core
CapX Core: A Tailored EPC for Private LTE and 5G
The CapX Core represents a cutting-edge Evolved Packet Core (EPC) solution designed to meet the specific needs of Private LTE and 5G networks. Built on the robust foundation of the Open5GS core, the CapX Core is meticulously tailored to integrate seamlessly with CapX products, offering unparalleled performance, flexibility, and security for enterprise and industrial applications.

# Prerequisites
# Before starting, ensure you have the following:

# 1- A server with Ubuntu 22.04
# 2- Git installed on the server
# 3- Sufficient permissions to execute scripts
Step 1: Clone the Repository
# Open your terminal and run the following command to clone the repository:
git clone https://github.com/X3Ld0R/CapX-Nederland-5G.git
# Navigate to the cloned directory:
cd CapX-Nederland-5G
# Step 3: Run the Install Script
# Make the install script executable:
chmod +x Install_CapXCore.sh
# Run the install script:
./Install_CapXCore.sh
# follow the steps 

#The script verifies that the operating system is Ubuntu 22.04. If the OS is not supported, the script will exit with an error message.
#The script generates a netplan configuration file with the provided IP addresses and network settings.
#The script will prompt you for several pieces of information during its execution. Be prepared to provide the following:

Interface name (e.g., enp0s25)
IP addresses for s1ap, gtpu, upf, and gateway
DNS servers
APN pool IP and gateway
# Example Configuration:
When prompted, you will enter values like these:

Interface Name: enp0s25
s1ap IP Address: 10.100.100.2/23
gtpu IP Address: 10.100.100.6/23
upf IP Address: 10.100.100.7/23
Gateway IP Address: 10.100.100.254
DNS1 IP Address: 1.0.0.1
DNS2 IP Address: 1.1.1.1
APN1 Pool IP: 10.45.0.1/16
APN1 Gateway IP: 10.45.0.1
# After the installation is complete, the script will display the following message:
echo "Install complete -- Please connect your browser to port 9999"
# Additionally, you will be prompted to restart your server:
RESTART_OUTPUT="Please restart this server by running 'reboot'"
echo $RESTART_OUTPUT

