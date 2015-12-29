#/bin/bash

rpm -Uvh https://yum.opennms.org/repofiles/opennms-repo-snapshot-rhel7.noarch.rpm
 
yum install postgresql postgresql-server
  
/sbin/service postgresql start
 
/sbin/service postgresql initdb

/sbin/service postgresql start
 
/sbin/chkconfig postgresql on

# Need to change from ident to trust on  pg_hba.conf file   
#local   all         all                               trust
#host    all         all         127.0.0.1/32          trust
#host    all         all         ::1/128               trust

 /sbin/service postgresql restart

yum install java-1.7.0-openjdk-devel

 yum -y install opennms

/opt/opennms/bin/runjava -S /usr/java/latest/bin/java

/opt/opennms/bin/install -dis

yum -y install iplike

firewall-cmd --permanent --add-port=8980/tcp
firewall-cmd --reload

systemctl start opennms
systemctl enable opennms



