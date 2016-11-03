#uboot-TK1

Builds and deploys uboot onto the Jetson-TK1. Necessary for enabling HYP mode on the TK1.
Can be used in conjunction with https://github.com/CodethinkLabs/jailhouse-tk1

Based on guide described here: https://blog.ramses-pyramidenbau.de/?p=342

##Usage
Runs in 4 phases:
- Build uboot using Vagrant box
- Put Jetson TK1 into recovery mode (http://elinux.org/Tegra/Boards/NVIDIA_Jetson_TK1#Entering_USB_Recovery_Mode)
- Deploy uboot to TK1 using supplied scripts
- If required, set the require env variable to enable HYP mode

``` shell
#To run uboot-build.sh
vagrant up

#Restart VM to detect Jetson-TK1 being put into recovery mode
vagrant halt && vagrant up && vagrant ssh

#Within VM
sudo -i 
cd /src/uboot/tegra-uboot-flasher-scripts
./tegra-uboot-flasher flash jetson-tk1
```

Then within uboot (before bootloader is triggered) set the following env variable to enable HYP mode

```shell
setenv bootm_boot_mode nonsec
saveenv
```
- 
