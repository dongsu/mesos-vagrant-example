# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# --------------------------------------------------------------
# Configuration
# --------------------------------------------------------------
masterRam = 2048               # VM memory in MB for the master node
slaveRam  = 1024               # VM memory in MB for each slave node
nodeCount = 1                  # Number of slave nodes to create
privateIP = "192.168.50.5"     # Starting IP address for private network


# --------------------------------------------------------------
# script / configuration
# --------------------------------------------------------------
privateSubnet     = privateIP.split(".")[0...3].join(".")
privateStartingIp = privateIP.split(".")[3].to_i

hosts = "#{privateIP} mesos-master mesos-master\n"
nodeCount.times do |i|
  id = i+1
  hosts << "#{privateSubnet}.#{privateStartingIp + id} mesos-slave-#{id} mesos-slave-#{id}\n"
end

$hosts_data = <<SCRIPT
#!/bin/bash
cat > /etc/hosts <<EOF
127.0.0.1       localhost
::1             localhost localhost.localdomain

#{hosts}
EOF

rpm -Uvh http://repos.mesosphere.io/el/6/noarch/RPMS/mesosphere-el-repo-6-2.noarch.rpm
yum -y install telnet vim unzip zip

SCRIPT


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "rafacas/centos63-plain"
  config.ssh.forward_agent = true

  config.vm.define "mesos-master" do |master|
    master.vm.network :private_network, ip: "#{privateIP}"
    master.vm.hostname = "mesos-master"

    master.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", "#{masterRam}"]
    end
    master.vm.provision :shell, :inline => $hosts_data
    master.vm.provision :shell, path: "init-master.sh"
  end

  nodeCount.times do |i|
    id = i+1
    config.vm.define "mesos-slave-#{id}" do |node|
      node.vm.network :private_network, ip: "#{privateSubnet}.#{privateStartingIp + id}"
      node.vm.hostname = "mesos-slave-#{id}"

      node.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--memory", "#{slaveRam}"]
      end
      node.vm.provision :shell, :inline => $hosts_data
      node.vm.provision :shell, path: "init-slave.sh"
    end
  end

end


