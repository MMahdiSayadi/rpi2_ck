# rpi2_ck
rpi2 custom kernel

## index 
Extra Details came in the rpi repo, and this is the summery of how you can build a custom kernel for rpi2.


# 1. Build a Cross Compiler

Here you have to options: 
  * 1. Build your own Cross-Compiler
  * 2. Download prebuild Cross-Compiler

## Build the Cross-Compiler

Steps: 
### 1. Make rpi directory<br />

`mkdir rpi2` 

### 2. Downlaod the Crosstool-ng (here we use release-1.25.0-rc1)<br />
```
cd rpi2
wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.25.0_rc1.tar.xz
tar -xf crosstool-ng-1.25.0_rc1.tar.xz
mv crosstool-ng-1.25.0_rc1.tar.xz crosstool-ng
```

### 3. Install Crosstool-ng dependencies <br />
you can see the requirements in the `Dockerfile` came in below<br />
```
cd crosstool-ng 
ls ../crosstool-ng/testing/docker/ubuntu21.10/Dockerfile
```
### 4. Build Crosstool-ng <br />
```
./bootstrap
./configure --enable-local
./make 
```
### 5. Build Cross Compiler using Crosstool-ng <br />
```
./ct-ng list-samples|grep rpi2
./ct-ng armv7-rpi2-linux-gnueabihf
./ct-ng menuconfig
```
> In the opened menucofnig in the `c-library` --> `Minimum Supported Kernel version` activate `let ./config decide`, and save changes.<br />
```
make -j12
```
> `-j` shows the number of jobs<br />
> If everything is ok you have to see the generated compilers in the following link
>> `~/x-tools/armv7-rpi2-linux-gnueabihf/bin`<br />
### 6. Test the installation<br />
you have to install `qemu`, `qemu` is an emulator which allows you to emulate your target using your host.
#### 6.1 install qemu
cd to rpi directory
```
cd ..
sudo apt update
sudo apt install qemu-user
```
#### 6.2 create some .c programm
```
gedit main.c
********* text inside *********
#include<sdtio.h>
int main()
{
 printf("hello world\n");
 return 0;
}
*******************************
```
#### 6.3 Compile it
for host<br />
```
gcc main.c -o app
```
for target<br />
```
export PATH=~/x-tools/armv7-rpi2-linux-gnueabihf/bin/:$PATH
```
type `armv` and hit `tab` and let your host autocomplete it. <br />
```
armv7-rpi2-linux-gnueabihf-gcc main.c -o app-arm --static
```
#### 6.4 Run Compiled Programms

for host `./app`<br />
for target `./app-arm` <br />

## Download prebuild Cross-Compiler

```
sudo apt-get update
sudo apt-get install gcc-arm-linux-gnueabihf
```
> All the processes for this part is similar to part one, except build it, and export path. <br />
> Here you do not need to export path because the compiler instslled on the default directory of you linux.<br />

 # 2. Build a Bootloader

### Download and install Bootloader
```
wget https://source.denx.de/u-boot/u-boot/-/archive/master/u-boot-master.tar.gz
tar -xf u-boot-master.tar.gz
mv u-boot-master u-boot
cd u-boot
ls configs|grep rpi \\here we use rpi2-defconfig
make rpi_2_defconfig
export PATH=~/x-tools/armv7-rpi2-linux-gnueabihf/bin/:$PATH
export CROSS_COMPILE=armv7-rpi2-linux-gnueabihf-
echo $CROSS_COMPILE \\ it should be equal to armv7-rpi2-linux-gnueabihf-
make menuconfig
make
```
> If everything is ok you have to see `u-boot` in the `./u-boot` directory <br />
> If you use from pre built cross compiler you do not need to add path.

## Prepare SD card for booting target 
```
cd ..
mkdir sdcard
cd sdcard
cp ../u-boot/u-boot.bin .
```
Download the Content of SD card in thid repo and paste them into the `sdcard` folder.<br />
now your folder content must be<br />
`bootcode.bin fixup.dat config.txt start.elf bcm2709-rpi-2-b.dtb u-boot.bin`

### Test bootloader Prepare SD card
here you have create a 50MiB Fat32 partition on the SD card and paste generated data on it. (here our SD card is `/dev/sdb`)<br />
```
\\ connect the sd card to your computer
sudo umount /dev/sdb*
sudo cfdisk /dev/sdb
\\ create 50M FAT32 partition which is also bootable
sudo mkfs.vfat /dev/sdb1
cd ..
mkdir mntp
sudo mount /dev/sdb1 mntp
sudo cp -r /sdcard/* mntp
sudo umount mntp
```
eject the SD card and connect it to board and turn on your board. 
you have to see the bootloader. 

### Some command for testing target
```
picocom -b 115200 /dev/ttyUSB0 \\ to see bootloader command in your terminal
setenv serverip 192.168.1.101
setenv netmask 255.255.255.0
setenv ipaddr 192.168.1.60
saveenv
printenv serverip
printsenv netmask
prinenv ipaddr
ping 192.168.1.101 \\ you have to see sever is alive
ls mmc 0:1
fatls mmc 0:1  \\ 0 shows device number, 1 shows partition number
res \\ to restart
```

# 3. Build Kernel












when you want ot make the kernel image, some times may you face with 
`sudo apt-get install libmpc-dev` after you type `make -j12` for example 
you have to install this package: 
`sudo apt-get install libmpc-dev`


