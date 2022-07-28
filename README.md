# rpi2_ck
rpi2 custom kernel

## index 
Extra Details came in the rpi repo, and this is the summery of how you can build a custom kernel for rpi2.


## 1. Buil a Cross Compiler

Here you have to options: 
  * 1. Build your own Cross-Compiler
  * 2. Download prebuild Cross-Compiler

### Build the Cross-Compiler

Steps: 
1. Make rpi directory

`mkdir rpi2` 

3. Downlaod the Crosstool-ng 

`wget https://crosstool-ng.github.io/2022/03/24/release-1.25.0-rc1.html`

3. Build CrossCompiler using Crosstool-ng 




when you want ot make the kernel image, some times may you face with 
`sudo apt-get install libmpc-dev` after you type `make -j12` for example 
you have to install this package: 
`sudo apt-get install libmpc-dev`


