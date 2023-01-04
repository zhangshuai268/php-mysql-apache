FROM alpine:latest

# 将配置文件传入容器中
COPY file /tmp

WORKDIR /root

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories &&\ 
   apk update &&\ 
   apk add --no-cache apache2 php7 php7-ctype php7-curl php7-dom php7-fpm php7-iconv php7-gd \
   php7-json php7-mysqli php7-openssl php7-pdo php7-pdo_sqlite php7-sqlite3 php7-xml php7-xmlreader \ 
   php7-zlib php7-phar php7-posix php7-apache2 php7-pdo_mysql php7-simplexml php7-xmlwriter composer mariadb mariadb-client openrc &&\ 
   #apache配置文件
   mv /tmp/httpd.conf /etc/apache2 &&\ 
   mv /tmp/lumen.conf /etc/apache2/conf.d &&\
   #mysql配置
   mv /tmp/my.cnf /etc &&\
   mv /tmp/mariadb-server.cnf /etc/my.cnf.d &&\
   mkdir -p /run/mysqld &&\ 
   chown -R mysql:mysql /run/mysqld &&\ 
   chown -R mysql:mysql /var/lib/mysql &&\ 
   mysql_install_db --user=mysql --ldata=/var/lib/mysql &&\
   #openrc设置 
   #执行service nginx status 会提示要创建该文件
   sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf &&\
   #告诉openrc 网络已经可以工作了，因为环回口不会down，它就会觉得网络一直可用
   echo 'rc_provide="loopback net"' >> /etc/rc.conf &&\ 
   #不记录日志
   sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf &&\ 
   #不尝试获取tty 设备，否则运行容器时执行/sbin/init 会一直报tty 错误
   sed -i '/tty/d' /etc/inittab &&\ 
   #不设置主机名，注释掉对应设置
   sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname &&\ 
   #不加载tmpfs
   sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh &&\ 
   # 不运行cgroup，避免service start xxxxx 时read only 错误
   sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh &&\ 
   echo 'rc_provide="loopback net"' >> /etc/rc.conf &&\
   #加载依赖   
   /sbin/openrc &&\
   # 执行service nginx status 会提示要创建该文件
   touch /run/openrc/softlevel &&\ 
   #将所需要的服务加入开机启动
   rc-update add apache2 default &&\
   rc-update add php-fpm7 default &&\
   rc-update add mariadb default &&\
   # SET MYSQL ROOT PASSWORD
   service mariadb start &&\
   mysqladmin -u root password "123456" &&\
   # CLEANUP
   mv /tmp/mysql.sh /run/mysqld &&\
   rm -rf /var/cache/apk/* &&\
   rm -rf /tmp/*

ENTRYPOINT ["/sbin/init"]
   
   

