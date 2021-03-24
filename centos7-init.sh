#!/bin/sh

echo "正在更新系统版本......"
yum update -y

echo "正在安装常用工具......"
yum install -y vim* net-tools unzip wget yum-utils telnet xinetd git

echo "正在关闭防火墙........"
systemctl stop firewalld
systemctl disable firewalld.service
firewall-cmd --state

echo "CentOS7初始化完成....."

echo "系统信息如下.........."
echo "主机名："`hostname`

echo "IP地址："`ifconfig | grep broadcast | awk "NR==1" | awk -F" " '{print $2}'`
exit 0
