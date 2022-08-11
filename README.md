# rpi2_ck
rpi2 custom kernel

## index 
Extra Details came in the rpi4 repo, and this is the summery of how you can build a custom kernel for rpi2.

## total steps 

total steps of creating custom kernel list in below: 
 *  first you need to build the cross-compiler
 *  as the second step you have to build and prepare the bootloader.
 *  build and prepare the kernel image 
 *  build and install busy box and the kernel init file 
 *  run the kernel <br />
Note that you have to download `rpi2Imgen.sh` from this repo and run it. this .sh file build all the needed file for you, and after that you only need to build the mentioned tools.

# Download and run `rpi2Imgen.sh`
> Hint : using `chmod` command you give the executable permission to your application
```
wget https://github.com/MMahdiSayadi/rpi2_ck/blob/main/rpi2Imgen.sh
sudo chmode +x rpi2Imgen.sh 
./rpi2Imgen.sh rpi2scr
```
after run the rpi2Imgen the following subfolder is created: 

.<br />
└── rpi2scr <br />
├── apps<br />
├── busybox<br />
├── crosstool-ng<br />
├── finalsdcard<br />
├── linux<br />
├── mntp<br />
├── sdcard<br />
└── u-boot<br />

    
above files created by the `rp2Imgen.sh` file. these files are created in the following directory of your PC:
`~/Project/EL/el/`

# 1. Build a Cross Compiler

Here you have to options: 
  * 1. Build your own Cross-Compiler
  * 2. Download prebuild Cross-Compiler

## Build the Cross-Compiler

Steps: 

Go to the crosstool-ng folder which created by `rpi1Imgen.sh` 

### 1. Install Crosstool-ng dependencies <br />
you can see the requirements in the `Dockerfile` came in below<br />
```
cd crosstool-ng 
ls ../crosstool-ng/testing/docker/ubuntu21.10/Dockerfile
sudo apt install <crosstool-ng_DEPfiles>
```
### 2. Build Crosstool-ng <br />
```
./bootstrap
./configure --enable-local
./make 
```
### 3. Build Cross Compiler using Crosstool-ng <br />
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

#### 6.3 Compile the main program
go to the app folder
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
go to the u-boot folder
```
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
cd ../sdcard
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
go to linux folder (for generating your own linux kernel) <br />
```
export ARCH=arm
\\ if you use from your compiler
export PATH=~/x-tools/armv7-rpi2-linux-gnueabihf/bin/:$PATH
export CROSS_COMPILE=armv7-rpi2-linux-gnueabihf-
\\ if you use from prebuilt compiler
export CROSS_COMPILE=arm-linux-gnueabihf-
ls /arch/arm/configs|grep bcm \\here we use from bcm2709
make bcm2709_defconfig
make menuconfig
make -j12
```

> when you want ot make the kernel image, some times may you face with <br />
> `lib mpc.h not found` after you type `make -j12`<br />
> you have to install this package: <br />
> `sudo apt-get install libmpc-dev`

your generated kernel image is in `/arch/arm/boot`
>> Note that for rpi2 you have to use from `zImage`.

### Loading Kernel
Connect your SD card to your host
```
cd sdcard 
sudo cp -r ../linux-rpi-5.15.y/arch/arm/boot/zImage .
sudo umount /dev/sdb*
cd ..
sudo mount /dev/sdb1 mntp
sudo cp sdcard/Image mntp
sudo umount mntp
```
Eject SD card and connect it to the target 
#### target part
for booting rpi2 your have to use `bootz`, while for rpi4 `booti` should be used.
```
sudo picocom -b 115200 /dev/ttyUSB0
setenv serverip 192.168.1.101
setenv netmask 255.255.255.0
setenv ipaddr 192.168.1.60
setenv bootcmd 'fatload mmc 0:1 ${kernel_addr_r} zImage; load mmc 0:1 ${fdt_addr_r} bcm2711-rpi-4-b.dtb; bootz ${kernel_addr_r} - ${fdt_addr}'
setenv bootargs console=ttyS0,115200 8250.nr_uarts=1 swiotlb=128 root=/dev/nfs ip=192.168.1.60 nfsroot=192.168.1.101:/mnt/rootfs,nfsvers=3,tcp init=/myinit rw
saveenv 
res
```
if everythis is ok you have to see `kernel panic error`.

# 4. Busybox as init file
go to the busybox folder:
```
cd ../busybox
export PATH=~/x-tools/armv7-rpi2-linux-gnueabihf/bin/:$PATH
export CROSS_COMPILE=armv7-rpi2-linux-gnueabihf-
\\ if you use from prebuilt compiler
export CROSS_COMPILE=arm-linux-gnueabihf-
sudo make defconfig
sudo make menuconfig
```
in the `menuconfig` you have to apply below changes: 

 1. in the `Setting` activate `Build static binary (no shared libs)`
 2. in the `Destination path for make install` type `../rootfs`

```
make -j12
make install
ls ../rootfs
```

> generate `linuxrc` is the `init` file.









