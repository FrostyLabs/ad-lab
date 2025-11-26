# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.provider "vmware_desktop" do |v|
    v.gui = true
    v.memory = 3072
    v.cpus = 2
  end

  # disable SSH forwarded port

  # Disable default shared folder:
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Configure a Shared Folder:
  config.vm.synced_folder "E:/VMWare_Storage/Virtual Machines/Shared-Folder",
                          "C:/Shared-Folder"


  config.vm.define "win-dc01" do |dc|
    dc.vm.guest = :windows
    dc.vm.communicator = "winrm"
    dc.vm.boot_timeout = 300
    dc.vm.graceful_halt_timeout = 300
    dc.winrm.retry_limit = 30
    dc.winrm.retry_delay = 10
    dc.vm.box = "StefanScherer/windows_2019"
    dc.vm.network "private_network", ip: "192.168.139.10"

    # Disable default port forwards
    dc.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", disabled: true
    dc.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm-default", disabled: true
    dc.vm.network :forwarded_port, guest: 5986, host: 5986, id: "winrm-ssl", disabled: true
    dc.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true

    # Port forward
    dc.vm.network :forwarded_port, guest: 3389, host: 23389, id: "msrdp"
    dc.vm.network :forwarded_port, guest: 5985, host: 25985, id: "winrm"

    # Provision Ansible remoting
    dc.vm.provision "ansibleRemoting", type: "shell",
      path: "./Shared-Folder/ps1/ConfigureRemotingForAnsible.ps1"


end

  config.vm.define "win-srv01" do |winsrv1|
    winsrv1.vm.guest = :windows
    winsrv1.vm.communicator = "winrm"
    winsrv1.vm.boot_timeout = 600
    winsrv1.vm.graceful_halt_timeout = 600
    winsrv1.winrm.retry_limit = 30
    winsrv1.winrm.retry_delay = 10
    winsrv1.vm.box = "StefanScherer/windows_2019"
    winsrv1.vm.network "private_network", ip: "192.168.139.11"

    # Disable default port forwards
    winsrv1.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", disabled: true
    winsrv1.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm-default", disabled: true
    winsrv1.vm.network :forwarded_port, guest: 5986, host: 5986, id: "winrm-ssl", disabled: true
    winsrv1.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true

    # Port forward
    winsrv1.vm.network :forwarded_port, guest: 3389, host: 33389, id: "msrdp"
    winsrv1.vm.network :forwarded_port, guest: 5985, host: 35985, id: "winrm"

    winsrv1.vm.provision "ansibleRemoting", type: "shell",
      path: "./Shared-Folder/ps1/ConfigureRemotingForAnsible.ps1"
  end

  config.vm.define "win-srv02" do |winsrv2|
    winsrv2.vm.guest = :windows
    winsrv2.vm.communicator = "winrm"
    winsrv2.vm.boot_timeout = 600
    winsrv2.vm.graceful_halt_timeout = 600
    winsrv2.winrm.retry_limit = 30
    winsrv2.winrm.retry_delay = 10
    winsrv2.vm.box = "StefanScherer/windows_2019"
    winsrv2.vm.network "private_network", ip: "192.168.139.12"

    # Disable default port forwards
    winsrv2.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", disabled: true
    winsrv2.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm-default", disabled: true
    winsrv2.vm.network :forwarded_port, guest: 5986, host: 5986, id: "winrm-ssl", disabled: true
    winsrv2.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true

    # Port forward
    winsrv2.vm.network :forwarded_port, guest: 3389, host: 43389, id: "msrdp"
    winsrv2.vm.network :forwarded_port, guest: 5985, host: 45985, id: "winrm"

    winsrv2.vm.provision "ansibleRemoting", type: "shell",
      path: "./Shared-Folder/ps1/ConfigureRemotingForAnsible.ps1"
  end

  config.vm.define "win-client01" do |client|
    client.vm.guest = :windows
    client.vm.communicator = "winrm"
    client.vm.boot_timeout = 600
    client.vm.graceful_halt_timeout = 600
    client.winrm.retry_limit = 30
    client.winrm.retry_delay = 10
    client.vm.box = "StefanScherer/windows_10"
    client.vm.network "private_network", ip: "192.168.139.13"

    # Disable default port forwards
    client.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", disabled: true
    client.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm-default", disabled: true
    client.vm.network :forwarded_port, guest: 5986, host: 5986, id: "winrm-ssl", disabled: true
    client.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true

    # Port forward
    client.vm.network :forwarded_port, guest: 3389, host: 53389, id: "msrdp"
    client.vm.network :forwarded_port, guest: 5985, host: 55985, id: "winrm"

    client.vm.provision "ansibleRemoting", type: "shell",
      path: "./Shared-Folder/ps1/ConfigureRemotingForAnsible.ps1"
  end

  config.vm.define "linux-srv01" do |linsrv1|
    linsrv1.vm.box = "bento/ubuntu-24.04"
    linsrv1.vm.network "private_network", ip: "192.168.139.14"

    # Disable default ssh forwarding port
    linsrv1.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true
    linsrv1.vm.network :forwarded_port, guest: 22, host: 6222, id: "msrdp"

    # Adjust the shared-folder:
    linsrv1.vm.synced_folder "E:/VMWare_Storage/Virtual Machines/Shared-Folder",
                          "C:/Shared-Folder", disabled: true
    # linsrv1.vm.synced_folder "E:/VMWare_Storage/Virtual Machines/Shared-Folder",
    #                        "/home/vagrant/Shared-Folder"
  end

end

