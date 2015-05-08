Mesos Example VM
================

This example uses CentOS 6.3 as base image to validate whether Mesos/Marathon can run on old CentOS 6.3 boxes.


1. Prerequisite Softwares
-----------------------------

- Vagrant (https://www.vagrantup.com/)
- Virtualbox (https://www.virtualbox.org/)

To access each node from your host browser, add following to your host file 
/etc/hosts
```
192.168.50.5 mesos-master mesos-master
192.168.50.6 mesos-slave-1 mesos-slave-1
192.168.50.7 mesos-slave-2 mesos-slave-2
192.168.50.8 mesos-slave-3 mesos-slave-3
```


2. Start & Stop VMs
-----------------------------

To start VMs
```
vagrant up
```

To stop VMs
```
vagrant halt
```


3. Access VMs
-----------------------------

To access mesos master VM
```
vagrant ssh mesos-master
```

To access mesos slave VM
```
vagrant ssh mesos-slave-1
```


4. Web Consoles
-----------------------------

Mesos UI
```
http://192.168.50.5:5050
```

Marathon Console (for running apps)
```
http://192.168.50.5:8080
```

Chronos (for scheduler jobs)
```
http://192.168.50.5:4400
```


5. Run an Example Application
-----------------------------

### 5-1. Running a play application.
First, go to Marathon console and click [+New App] button.
Input following values and click [+Create] button to start application.
```
ID: hello
CPUs: 0.1
Memory(MB): 16
Instances: 1
Command: ./Hello-*/bin/hello -Dhttp.port=$PORT
URIs: http://downloads.mesosphere.io/tutorials/PlayHello.zip
```

or you can run the following curl command
```
curl -i -H "Content-Type: application/json" -X POST \
 --data '{
  "cmd": "./Hello-*/bin/hello -Dhttp.port=$PORT",
  "cpus": 0.1,
  "id": "hello",
  "instances": 1,
  "mem": 16,
  "uris": ["http://downloads.mesosphere.io/tutorials/PlayHello.zip"]
}' http://192.168.50.5:8080/v2/apps/

```

### 5-2. Scaling out
If you want to scale out, you can increase number of instances with below command:
```
curl -i -H "Content-Type: application/json" -X PUT \
 --data '{
  "cmd": "./Hello-*/bin/hello -Dhttp.port=$PORT",
  "cpus": 0.1,
  "id": "/hello",
  "instances": 3,
  "mem": 16,
  "disk": 0,
  "uris": ["http://downloads.mesosphere.io/tutorials/PlayHello.zip"]
}' http://192.168.50.5:8080/v2/apps/hello
```

curl -i -H "Content-Type: application/json" -X PUT \
 --data '{
  "instances": 2
}' http://192.168.50.5:8080/v2/apps/hello


### 5-3. Destroy instances
To destroy app:

```
curl -i -X DELETE http://192.168.50.5:8080/v2/apps/hello
```
