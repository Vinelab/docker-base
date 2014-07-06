FROM centos:latest

MAINTAINER Abed Halawi <abed.halawi@vinelab.com>

# update packages
RUN yum -y update

# install basic software
RUN yum install -y vim
RUN yum install -y wget

# install openssh server
RUN yum -y install openssh-server

# install openssh clients
RUN yum -y install openssh-clients

# make ssh directories
RUN mkdir /root/.ssh
RUN mkdir /var/run/sshd

# create host keys
RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_key
RUN ssh-keygen -b 1024 -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -b 1024 -t dsa -f /etc/ssh/ssh_host_dsa_key

# move public key to enable ssh keys login
ADD docker_ssh.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys

# make the terminal prettier
RUN echo 'export PS1="[\u@docker] \W # "' >> /root/.bash_profile

# enable networking
RUN echo 'NETWORKING=yes' >> /etc/sysconfig/network

# install supervisord
RUN yum -y install http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install python-setuptools
RUN easy_install supervisor
RUN /usr/bin/echo_supervisord_conf > /etc/supervisord.conf
RUN mkdir -p /var/log/supervisord

# make supervisor run in foreground
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisord.conf

# make supervisor run the http server on 9001
RUN sed -i -e "s/^;\[inet_http_server\]/\[inet_http_server\]/" /etc/supervisord.conf
RUN sed -i -e "s/^;port=127.0.0.1:9001/port=0.0.0.0:9001/" /etc/supervisord.conf
RUN sed -i -e "s/^;username=user/username=vinelab/" /etc/supervisord.conf
RUN sed -i -e "s/^;password=123/password=vinelab/" /etc/supervisord.conf

# tell supervisor to include relative .ini files
RUN mkdir /etc/supervisord.d
RUN echo [include] >> /etc/supervisord.conf
RUN echo 'files = /etc/supervisord.d/*.ini' >> /etc/supervisord.conf

# add sshd program to supervisord config
RUN echo [program:sshd] >> /etc/supervisord.d/ssh.ini
RUN echo 'command=/usr/sbin/sshd -D' >> /etc/supervisord.d/ssh.ini
RUN echo  >> /etc/supervisord.d/ssh.ini

RUN yum clean all

EXPOSE 22
EXPOSE 9001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
