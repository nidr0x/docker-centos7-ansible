FROM centos:7

MAINTAINER Carlos Rodríguez <nidr0x@gmail.com>

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum clean all && \
    yum --disableplugin=fastestmirror install -y \
        epel-release ansible initscripts sudo cronie \
    yum -y update && \
    rm -rf /var/cache/yum && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

RUN sed -i 's/Defaults    requiretty/Defaults    !requiretty/g' /etc/sudoers

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]    