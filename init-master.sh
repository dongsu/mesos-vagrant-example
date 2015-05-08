#!/bin/bash

echo "start on manual" > /etc/init/mesos-slave.override 


rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
yum -y install zookeeper mesos marathon chronos

echo "zk://mesos-master:2181/mesos" > /etc/mesos/zk

zookeeper-server-initialize --myid=1
/usr/bin/zookeeper-server start


cat > /etc/init/zookeeper.conf <<EOF
description "zookeeper server"

start on stopped rc RUNLEVEL=[2345]
respawn

exec /usr/bin/zookeeper-server start-foreground

EOF


start zookeeper
start mesos-master
start mesos-slave
start marathon
start chronos
