# rpi2_ck
rpi2 custom kernel

## index 
Extra Details came in the rpi repo, and this is the summery of how you can build a custom kernel for rpi2.


## 1. Build a Cross Compiler

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



when you want ot make the kernel image, some times may you face with 
`sudo apt-get install libmpc-dev` after you type `make -j12` for example 
you have to install this package: 
`sudo apt-get install libmpc-dev`


