# docker部署apache+mysql+php dockerfile

#### 介绍
docker部署php+mysql+apache

#### 软件架构
基于apline linux系统搭建的docker镜像，在没有任何项目的情况下只有环境，镜像大小为377MB，可以通过其他系统 继续减小镜像大小，但会在安装过程更加麻烦。



#### 安装教程

1.  服务器安装git、docker  
2.  git clone 此文件  
3.  进入文件目录执行 docker build -t 镜像名称 .  
4.  docker run --privileged=true --name [容器名称] -d -p [宿主机端口号]:80 -p [宿主机mysql端口号]:3306 -v [宿主机项目目录]:/var/www/localhost/htdocs -v [宿主机mysql文件备份地址]:/var/lib/mysql [镜像名称:tag]

宿主机端口号：主要用于端口映射到容器内apache端口；  
宿主机mysql端口号：主要用于端口映射到容器内MySQL端口；  
宿主机项目目录：用于数据挂载，项目目录；  
宿主机mysql文件备份地址：用于数据挂载，MySQL数据和备份数据；  

示例：docker run --privileged=true --name sc-edu -d -p 8083:80 -p 3302:3306 -v /opt/docker_mysql_data/sc-edu6/www:/var/www/localhost/htdocs -v /opt/docker_mysql_data/sc-edu6/mysql:/var/lib/mysql zhangshuaiscedu/sc-edu:v3

5. 执行 docker exec -it 容器id sh 进入容器中 

5.5 若挂载了数据库目录，需要重新启动初始化mysql，若不挂载则此步骤不需要，执行：mysql_install_db --user=mysql --ldata=/var/lib/mysql
执行后在执行 rc-service mariadb start

7.mysql -u用户名 -p密码 进入mysql

开放外界链接权限：grant all privileges on *.* to 'root'@'%' identified by '123456';

FLUSH PRIVILEGES;

6.若使用容器内数据库，需要启动自动备份sql文件，这样保证容器挂掉时，下次开启容器能够快速恢复数据； 

cd /run/mysqld
sh mysql.sh
若有权限错误，需要添加权限  
chmod 777 mysql.sh
之后开启定时
crontab -e
00 02 * * *  sh /run/mysqld/mysql.sh >> /run/mysqld/mysql.log
crond 开启定时任务


#### 使用说明

1.  容器自带composer可进入容器内进行composer update；
2.  尽量不要使用容器内数据库；
3.  数据库备份期限为7天，超过7天的sql文件会自动删除，可自行修改文件；

#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
