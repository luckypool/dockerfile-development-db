FROM        ubuntu:trusty
MAINTAINER  luckypool luckypool314@gmail.com

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y monit
RUN apt-get install -y sudo
RUN apt-get install -y nginx
RUN apt-get install -y openssh-server
RUN apt-get install -y mysql-server
RUN apt-get install -y redis-server
RUN apt-get install -y memcached

# for monit configurations
ADD ./monit/monitrc /etc/monit/monitrc
RUN chmod 700 /etc/monit/monitrc
ADD ./monit/memcached.conf    /etc/monit/conf.d/memcached.conf
ADD ./monit/mysqld.conf       /etc/monit/conf.d/mysqld.conf
ADD ./monit/nginx.conf        /etc/monit/conf.d/nginx.conf
ADD ./monit/redis-server.conf /etc/monit/conf.d/redis-server.conf
ADD ./monit/sshd.conf         /etc/monit/conf.d/sshd.conf

# for user
RUN adduser --disabled-password --gecos "" luckypool && echo 'luckypool:luckypool' | chpasswd
RUN gpasswd -a luckypool sudo
RUN chsh -s /bin/bash luckypool

# for ssh key
RUN mkdir -p /home/luckypool/.ssh; chown luckypool /home/luckypool/.ssh; chmod 700 /home/luckypool/.ssh
ADD sshd/id_rsa.pub /home/luckypool/.ssh/authorized_keys
RUN chown luckypool /home/luckypool/.ssh/authorized_keys; chmod 600 /home/luckypool/.ssh/authorized_keys
RUN echo 'AuthorizedKeysFile %h/.ssh/authorized_keys' >> /etc/ssh/sshd_config

# for sshd
EXPOSE 22
RUN mkdir -p /var/run/sshd
CMD /usr/sbin/service ssh start

# for nginx
EXPOSE 80
RUN mkdir -p /var/run/nginx
CMD /usr/sbin/service nginx start

# for mysqld
EXPOSE 3306
RUN mkdir -p /var/run/mysqld
CMD /usr/sbin/service mysql start

# for memcached
EXPOSE 11211
RUN mkdir -p /var/run/memcached
CMD /usr/sbin/service memcached start

# for redis
EXPOSE 6379
RUN mkdir -p /var/run/redis
CMD /usr/sbin/service redis-server start

# for monit
EXPOSE 2812
CMD ["/usr/bin/monit", "-I", "-c", "/etc/monit/monitrc"]
