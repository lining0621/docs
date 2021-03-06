#!/bin/bash
#********************************************************************
#Author: Andy
#IBM: CCBFT
#Date： 2021-03-14
#FileName： centos7-docker-install.sh
#URL： 
#Description： Annotated script
#********************************************************************

echo -e "\033[41;37m卸载旧版本docker...........\033[0m"
yum remove -y docker docker-client docker-client-latest docker-common docker-latest 
yum remove -y docker-latest-logrotate docker-logrotate docker-engine
yum remove -y containerd.io.x86_64
yum remove -y docker-engine.x86_64 
yum remove -y docker-ce-cli.x86_64
yum remove -y docker-ce.x86_64 
rm -rf /var/lib/docker
yum clean headers  #清理/var/cache/yum的headers清理
yum clean packages #清理/var/cache/yum下的软件包
yum clean metadata

echo -e "\033[41;37m开始安装docker\033[0m"
cd pkg
rpm -Uvh *.rpm --nodeps --force
cd ..
rpm -Uvh container-selinux-*.noarch.rpm
rpm -Uvh containerd.io-1.4.4-3.1.el7.x86_64.rpm
rpm -Uvh docker-ce-*.x86_64.rpm

echo -e "\033[41;37mdocker安装完成，服务启动中\033[0m"
systemctl enable docker.service
systemctl start docker
systemctl status docker

echo -e "\033[41;37mdocker信息如下:\033[0m"
docker version
docker ps
cp docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo -e "\033[41;37m运行测试容器hello-world\033[0m"
docker run library/hello-world

read -p "是否启动portainer服务y/N: " portainer
if [ $portainer == "y" ] ; then 
  PORTAINER_PORT=49000
  PORTAINER_HOME=/software/docker/portainer
  PORTAINER_CONTAINER_NAME=base-01-portainer
  mkdir -p $PORTAINER_HOME
  echo "正在启动portainer.........."
  docker run -d --restart=always --name $PORTAINER_CONTAINER_NAME -p $PORTAINER_PORT:9000 -v /var/run/docker.sock:/var/run/docker.sock -v $PORTAINER_HOME:/data portainer/portainer:latest
  echo "portainer部署完成"
  echo "\033[41;37m完成portainer启动，请通过: "`ifconfig | grep broadcast | awk "NR==2" | awk -F" " '{print $2}'`":"$PORTAINER_PORT"访问\033[0m"
fi

# 部署MySQL
read -p "是否启动MySQL服务y/N: " mysql
if [ $mysql == "y" ] ; then 
  MYSQL_HOME=/software/docker/mysql8/data
  MYSQL_CONTAINER_NAME=base-02-mysql
  MYSQL_PORT=43306
  mkdir -p $MYSQL_HOME
  echo "正在启动MySQL.............."
  docker run -d --restart=always --name $MYSQL_CONTAINER_NAME -p $MYSQL_PORT:3306 -v $MYSQL_HOME:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=1qaz@WSX3edc mysql:latest 
  echo "\033[41;37m完成MySQL启动，请通过: "`ifconfig | grep broadcast | awk "NR==2" | awk -F" " '{print $2}'`":"$MYSQL_PORT"访问\033[0m"
  echo "开户远程访问"
  echo "docker exec -it base-02-mysql"
  echo "进入mysql"
  echo "mysql -u root -p"
  echo "授权"
  echo "grant all privileges on *.*  to 'root'@'%';"
  echo "flush privileges;"
  echo "退出"
  echo "exit"
  echo "exit"
  echo "第一个exit退出mysql"
  echo "第二个exit退出容器的bash"
  echo "远程连接提示'Public Key Retrieval is not allowed',allowPublicKeyRetrieval=true"  
fi

exit 0
