#!/bin/sh
set -e
#Arch Linux installer plugin for multicd.sh
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
	if [ -f arch.iso ];then
		echo "Arch Linux"
	fi
elif [ $1 = copy ];then
	if [ -f arch.iso ];then
		echo "Copying Arch Linux..."
		if [ ! -d arch ];then
			mkdir arch
		fi
		if grep -q "`pwd`/arch" /etc/mtab ; then
			umount arch
		fi
		mount -o loop arch.iso arch/
		mkdir multicd-working/boot/arch
		cp arch/boot/vmlinuz26 multicd-working/boot/arch/vmlinuz26 #Kernel
		cp arch/boot/archiso_pata.img multicd-working/boot/arch/archiso_pata.img #initrd
		cp arch/boot/archiso_ide.img multicd-working/boot/arch/archiso_ide.img #Another initrd
		cp arch/*.sqfs multicd-working/ #Compressed filesystems
		cp arch/isomounts multicd-working/ #Text file
		umount arch
		rmdir arch
	fi
elif [ $1 = writecfg ];then
if [ -f arch.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label arch
menu label Boot ^ArchLive
kernel /boot/arch/vmlinuz26
append lang=en locale=en_US.UTF-8 usbdelay=5 ramdisk_size=75% initrd=/boot/arch/archiso_pata.img

label arch-ide
menu label Boot ArchLive [legacy IDE]
kernel /boot/arch/vmlinuz26
append lang=en locale=en_US.UTF-8 usbdelay=5 ramdisk_size=75% ide-legacy initrd=/boot/arch/archiso_ide.img
EOF
fi
else
	echo "Usage: $0 {scan|copy|writecfg}"
	echo "Use only from within multicd.sh or a compatible script!"
	echo "Don't use this plugin script on its own!"
fi
