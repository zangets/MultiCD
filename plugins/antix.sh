#!/bin/sh
set -e
#antiX Linux plugin for multicd.sh
#version 5.0
#Copyright (c) 2009 maybeway36
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
if [ $1 = scan ];then
	if [ -f antix.iso ];then
		echo "AntiX"
	fi
elif [ $1 = copy ];then
	if [ -f antix.iso ];then
		if [ ! -d antix ];then
			mkdir antix
		fi
		if grep -q "`pwd`/antix" /etc/mtab ; then
			umount antix
		fi
		mount -o loop antix.iso antix/
		cp -r antix/mepis multicd-working/ #Everything in antiX but the kernel and initrd
		mkdir -p multicd-working/boot/antix
		cp antix/boot/vmlinuz multicd-working/boot/antix/vmlinuz #Kernel
		cp antix/boot/initrd.gz multicd-working/boot/antix/initrd.gz #Initrd
		umount antix
		rmdir antix
	fi
elif [ $1 = writecfg ];then
if [ -f antix.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label anitX
menu label ^antiX
com32 menu.c32
append antix.menu
EOF
cat > multicd-working/boot/isolinux/antix.menu << "EOF"
DEFAULT menu.c32
TIMEOUT 0
PROMPT 0
menu title AntiX Options

label  antiX-Default
menu label ^antiX-Default
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init quiet nosplash vga=791 aufs  initrd=/boot/antix/initrd.gz

label  antiX-Lite-noNet
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init quiet nosplash vga=791 aufs mean lean initrd=/boot/antix/initrd.gz

label  antiX-Vesa
menu label antiX-Vesa (display problem or virtualbox)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init vga=normal quiet nosplash drvr=vesa aufs lean initrd=/boot/antix/initrd.gz

label  antiX-UltraLite-Vesa
menu label antiX-UltraLite-Vesa (Fast boot)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init vga=normal quiet nosplash drvr=vesa aufs lean Xtralean initrd=/boot/antix/initrd.gz

label  antiX-Failsafe
menu label antiX-Failsafe (minimum options, small display)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init quiet nosplash vga=normal nosound noapic noscsi nodma noapm nousb nopcmcia nofirewire noagp nomce nodhcp nodbus nocpufreq nobluetooth drvr=fbdev aufs res=800x600v initrd=/boot/antix/initrd.gz

label  antiX-60Hz
menu label antiX-60Hz (force monitor to 58-62 Hz)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init vga=791 quiet nosplash vsync=58-62 aufs initrd=/boot/antix/initrd.gz

label  antiX-75Hz
menu label antiX-75Hz (force monitor to 73-77 Hz)
kernel /boot/antix/vmlinuz
append SELINUX_INIT=NO init=/etc/init vga=791 quiet nosplash vsync=73-77 aufs initrd=/boot/antix/initrd.gz

label back
menu label ^Back to main menu
com32 menu.c32
append isolinux.cfg
EOF
fi
else
	echo "Usage: $0 {scan|copy|writecfg}"
	echo "Use only from within multicd.sh or a compatible script!"
	echo "Don't use this plugin script on its own!"
fi
