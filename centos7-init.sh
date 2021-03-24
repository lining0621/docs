#!/bin/sh

echo -e "\033[41;37m正在更新系统版本......\033[0m"
yum update -y

echo -e "\033[41;37m正在安装常用工具......\033[0m"
yum install -y vim* net-tools unzip wget yum-utils telnet xinetd git

echo -e "\033[41;37m正在关闭防火墙........\033[0m"
systemctl stop firewalld
systemctl disable firewalld.service
firewall-cmd --state

echo -e "\033[41;37mCentOS7初始化完成.....\033[0m"

echo -e "\033[41;37m系统信息如下..........\033[0m"
echo -e "\033[41;37m主机名："`hostname`"\033[0m"

echo -e "\033[41;37mIP地址："`ifconfig | grep broadcast | awk "NR==1" | awk -F" " '{print $2}'`"\033[0m"
exit 0
