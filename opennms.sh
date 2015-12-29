#/bin/bash

 rpm -Uvh https://yum.opennms.org/repofiles/opennms-repo-RELEASE-DISTRIBUTION.noarch.rpm
 
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
