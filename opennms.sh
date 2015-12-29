#!/bin/bash
# opennms installation on centos7
 set -x
 
 if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

which curl >/dev/null 2>&1
if  [ $? != 0 ]; then
 yum -y install curl >/dev/null 2>&1
fi

# Install wget if not already installed 
which wget >/dev/null 2>&1
if  [ $? != 0 ]; then
 yum -y install wget >/dev/null 2>&1
fi

yum_makecache_retry() {
  tries=0
  until [ $tries -ge 5 ]
  do
    yum makecache && break
    let tries++
    sleep 1
  done
}

echo " Adding opennms repo "

rpm -Uvh https://yum.opennms.org/repofiles/opennms-repo-snapshot-rhel7.noarch.rpm

echo " Install postgresql"

yum -y install postgresql postgresql-server
 
/sbin/service postgresql start
 
/sbin/service postgresql initdb

/sbin/service postgresql start
 
/sbin/chkconfig postgresql on

echo " Changing ident to trust "

echo 'local   all         all                               trust
host    all         all         127.0.0.1/32          trust
host    all         all         ::1/128               trust' | tee /var/lib/pgsql/data/pg_hba.conf

echo " restarting postgresql"

/sbin/service postgresql restart

echo " installing java 1.7 "

yum -y install java-1.7.0-openjdk-devel

echo " Installing opennms "

yum -y install opennms

/opt/opennms/bin/runjava -S /usr/java/latest/bin/java

/opt/opennms/bin/install -dis

echo " installing iplike "
yum -y install iplike

echo " adding firewall rule "

firewall-cmd --permanent --add-port=8980/tcp

firewall-cmd --reload

echo " Starting opennms "

systemctl start opennms

systemctl enable opennms

sleep 5

curl -i localhost:8980


