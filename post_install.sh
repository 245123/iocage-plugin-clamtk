#!/bin/sh -x
IP_ADDRESS=$(ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}')

# Enable the service
sysrc clamav_freshclam_enable="YES"
sysrc clamav_clamd_enable="YES"

#update database before start
freshclam 

# Start the service
service clamav-freshclam start 2>/dev/null
service clamav-clamd start 2>/dev/null

ln -s /usr/local/bin/python3.8 /usr/local/bin/python

ln -s /usr/local/libexec/novnc/vnc_lite.html /usr/local/libexec/novnc/index.html

openssl req -new -x509 -days 365 -nodes -out self.pem -keyout /usr/local/libexec/novnc/utils/websockify/self.pem -subj "/C=CA/ST=ONTARIO/L=TORONTO/O=Global Security/OU=IT Department/CN=vnc"

VNC_PASS=$(openssl rand -base64 20 | md5 | head -c20)
USER_PASS=$(openssl rand -base64 20 | md5 | head -c6)

sysrc websockify_enable=YES
service websockify start 2>/dev/null

sysrc x11vnc_enable=YES
service x11vnc start 2>/dev/null

echo -e "ClamTK now installed.\n" > /root/PLUGIN_INFO
echo -e "\nGo to http://$IP_ADDRESS:6080\n" >> /root/PLUGIN_INFO