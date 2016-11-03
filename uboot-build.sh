#!/bin/bash

#Builds uboot (v2016.11-rc1) and associated dependencies for the TK1

if [ $UID -ne 0 ]
then
    echo "Must be root to execute"
    exit 1
fi

#Add the debian cross-toolchain repository
apt-get install -y curl git
echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/crosstools.list
curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | sudo apt-key add -

#Install the cross-compiler architecture
sudo dpkg --add-architecture armhf
sudo apt-get update
apt-get install -y  crossbuild-essential-armhf

#Install the dependencies required:
apt-get install -y libxen-dev flex bison usbutils
apt-get install -y autoconf pkg-config libusb-1.0-0-dev libcrypto++-dev
#get all the stuff for uboot:https://blog.ramses-pyramidenbau.de/?p=342
mkdir -p /src/uboot
cd /src/uboot
# Get all the required stuff
git clone https://github.com/NVIDIA/tegra-uboot-flasher-scripts.git
git clone https://github.com/NVIDIA/tegrarcm.git
git clone https://github.com/NVIDIA/cbootimage.git
git clone https://github.com/NVIDIA/cbootimage-configs.git

git clone --depth 1 --branch "v2016.11-rc1" git://git.denx.de/u-boot.git u-boot
git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git

#patch jetson configs for u-boot to enable hyp mode
cat /src/build/hyp_enable >> /src/uboot/u-boot/configs/jetson-tk1_defconfig

# build tegrarcm
cd tegrarcm
./autogen.sh
make
cd ..

# build cbootimage
cd cbootimage
./autogen.sh
make
cd ..

#build dtc
cd dtc
make
cd ..

# build u-boot
echo 'export PATH=$PATH:/src/uboot/cbootimage/src:/src/uboot/tegrarcm/src:/src/uboot/dtc' >> ~/.profile && source ~/.profile
cd tegra-uboot-flasher-scripts
export CROSS_COMPILE=arm-linux-gnueabihf-
./build --socs tegra124 --boards jetson-tk1 build
if [ $? -ne 0 ]
then
    echo "uboot build unsuccessful"
    exit 1
fi


echo "Build complete. To continue, place the Jetson TK1 in recovery mode before proceeding"
echo "To flash uboot on the TK1, log in to the vagrant VM with 'vagrant halt && vagrant up && vagrant ssh'" 
echo "then sudo -i -> cd /src/uboot/tegra-uboot-flasher-scripts -> ./tegra-uboot-flasher flash jetson-tk1"
