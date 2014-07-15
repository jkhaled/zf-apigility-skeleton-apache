Vagrant.configure("2") do |config|

    config.vm.provision :shell, :path => ".devops/image_bootstrap.sh", :args => "/vagrant" #pass root folder as param
    config.vm.provision :shell, :path => ".devops/apigility_bootstrap.sh"

    config.vm.box = "netsensia/ubuntu-trusty64"

    config.vm.network :forwarded_port, guest: 8888, host: 8888
    config.vm.network :private_network, ip: "192.168.56.101"

    config.ssh.forward_agent = true

    config.vm.provider :virtualbox do |v, override|
        host = RbConfig::CONFIG['host_os']

        # Give VM access to all cpu cores on the host
        if host =~ /darwin/
            cpus = `sysctl -n hw.ncpu`.to_i
        elsif host =~ /linux/
            cpus = `nproc`.to_i
        end

        v.customize ["modifyvm", :id, "--cpus", cpus]
        v.customize ["modifyvm", :id, "--memory", "1024"]
        v.gui = true #to debug
        #v.gui = false
    end

    config.vm.provider :vmware_workstation do |v, override|
        v.vmx["memsize"] = "1024"
    end

      config.vm.provider :vmware_fusion do |v|
        v.vmx["memsize"] = "1024"
        v.gui = true #to debug
        #v.gui = false
      end
    
    config.vm.synced_folder ".", "/vagrant", nfs: true
    config.vm.provision :shell, :inline => "if [[ ! -f /apt-get-run ]]; then sudo apt-get update && sudo touch /apt-get-run; fi"

end
