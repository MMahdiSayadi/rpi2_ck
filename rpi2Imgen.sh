#!/bin/bash 

varpath=~/Project/EL/el
foldername=$1
varpath1=$varpath/$foldername

echo $varpath
echo $varpath1
echo $foldername
sleep 1

# create the required files 
sudo mkdir $varpath1 -p
sudo mkdir $varpath1/finalsdcard $varpath1/mntp $varpath1/apps $varpath1/sdcard


# Download the content inside of the sdcard 
sudo wget https://github.com/mohammadmahdisayadi1374/rpi2_ck/blob/main/sdcard/bcm2709-rpi-2-b.dtb -P $varpath1/sdcard
sudo wget https://github.com/mohammadmahdisayadi1374/rpi2_ck/blob/main/sdcard/bootcode.bin -P $varpath1/sdcard
sudo wget https://github.com/mohammadmahdisayadi1374/rpi2_ck/blob/main/sdcard/config.txt -P $varpath1/sdcard
sudo wget https://github.com/mohammadmahdisayadi1374/rpi2_ck/blob/main/sdcard/fixup.dat -P $varpath1/sdcard
sudo wget https://github.com/mohammadmahdisayadi1374/rpi2_ck/blob/main/sdcard/start.elf -P $varpath1/sdcard

#download the crosstool-ng without make it 
sudo wget wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.25.0_rc1.tar.xz -P $varpath1
sudo tar -xf $varpath1/crosstool-ng-1.25.0_rc1.tar.xz --directory $varpath1
sudo mv $varpath1/crosstool-ng-1.25.0_rc1 $varpath1/crosstool-ng
sudo rm -r $varpath1/crosstool-ng-1.25.0_rc1.tar.xz

# install qemu-user
sudo apt update
sudo apt install qemu-user


#create C files 
sudo wget https://github.com/mohammadmahdisayadi1374/Embedded_Courses/blob/main/embedded1/main.c -P $varpath1/apps 

# Native compiling the programs 
gcc $varpath1/apps/main.c -o app 

# Download the u-boot without installing it 
sudo wget https://source.denx.de/u-boot/u-boot/-/archive/master/u-boot-master.tar.gz -P $varpath1
sudo tar -xf $varpath1/u-boot-master.tar.gz --directory $varpath1
sudo mv $varpath1/u-boot-master $varpath1/u-boot
sudo rm -r $varpath1/u-boot-master.tar.gz

# Download the sdcard requirements 
sudo wget https://github.com/mohammadmahdisayadi1374/rpi2_ck/tree/main/sdcard -P $varpath1

sleep 2
echo "Note that for the rpi2 you Need to zImage instead of Image compared to rpi4"
sleep 2

# Download linux image for rpi2
echo "Download linux image for the rpi2"
sudo wget https://github.com/raspberrypi/linux/archive/refs/heads/rpi-5.15.y.zip -P $varpath1
sudo unzip $varpath1/rpi-5.15.y.zip -d $varpath1
sudo mv $varpath1/linux-rpi-5.15.y $varpath1/linux
sudo rm -r $varpath1/rpi-5.15.y.zip
# Download and prepare BusyBox 
sleep 2
echo "You can use nginx instead of Busybox"
sudo wget https://github.com/mirror/busybox/archive/refs/heads/master.zip -P $varpath1
sudo unzip $varpath1/master.zip -d $varpath1/
sudo mv $varpath1/busybox-master $varpath1/busybox 
sudo rm -r $varpath1/master.zip

sleep 2
echo "Your file preperation is completed"
sleep 1





