#!/bin/bash

echo "start on manual" > /etc/init/mesos-master.override 
echo "start on manual" > /etc/init/chronos.override 
echo "start on manual" > /etc/init/marathon.override 

yum -y install mesos
echo "zk://mesos-master:2181/mesos" > /etc/mesos/zk

start mesos-slave

