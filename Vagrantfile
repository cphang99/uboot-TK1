Vagrant.configure(2) do |config|
  config.vm.box = "debian/contrib-jessie64"
  config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder ".", "/src/build"
  config.vm.provider "virtualbox" do |vb|
    # Customize the VM:
    vb.memory = "1024"
    vb.cpus = "1"
    vb.customize ["usbfilter", "add", "0", 
    "--target", :id, 
    "--name", "tegra-tx1",
    "--manufacturer", "NVIDIA Corp.",
    "--product", "APX"]
    vb.customize ["modifyvm", :id, "--usb", "on", "--usbehci", "on"]
  end

  config.vm.provision "shell", inline: <<-SHELL
     sudo -i
     ./uboot-build.sh
  SHELL

  
end