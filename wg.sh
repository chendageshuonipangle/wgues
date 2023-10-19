apt update
#reguard软件
apt install wireguard resolvconf -y
#开启IP转发
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
cd /etc/wireguard/
chmod 0777 /etc/wireguard
#调整目录默认权限
umask 077
echo "[Interface]
PrivateKey = 0HD57ktlgvGV9Mx0+QzCB3T29iSAh3pXW+h3Jg/dzWs=
# 填写本机的privatekey 内容
Address = 10.0.8.1 #本机虚拟局域网IP
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
#注意eth0需要为本机网卡名称
ListenPort = 51820 # 监听端口
DNS = 8.8.8.8
MTU = 1420
[Peer]
PublicKey = y55OXzgXSozKykJDlDFzdk0RpyZYVny5xroGM5Szm20=
#自动client1的公钥
AllowedIPs = 10.0.8.9/32 #客户端所使用的IP
[Peer]
PublicKey = ojCPNcbG4dp9OA4pgb7IVh2XFISHhfsqrp6ixpBVblI=
#自动client1的公钥
AllowedIPs = 10.0.8.10/32 #客户端所使用的IP" > wg0.conf
systemctl enable wg-quick@wg0
wg-quick up wg0
wg
