#!/bin/sh
set -e
#Endian Firewall Community Edition plugin for multicd.sh
#version 5.0
#Copyright (c) 2010 PsynoKhi0
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
	if [ -f efw.iso ];then
		echo "Endian Firewall"
	fi
elif [ $1 = copy ];then
	if [ -f efw.iso ];then
		echo "Copying Endian Firewall..."
		if [ ! -d endian ];then
			mkdir endian
		fi
		if grep -q "`pwd`/endian" /etc/mtab ; then
			umount endian
		fi
		mount -o loop efw.iso endian/
		mkdir -p multicd-working/boot/endian/
		cp endian/boot/isolinux/vmlinuz multicd-working/boot/endian/ #Kernel
		cp endian/boot/isolinux/instroot.gz multicd-working/boot/endian/ #Filesystem
		cp -r endian/data multicd-working/data #data and rpms folders are located
		cp -r endian/rpms multicd-working/rmps #at the root of the original CD
		cp endian/LICENSE.txt multicd-working/EFW-LICENSE.txt #License terms
		cp endian/README.txt multicd-working/EFW-README.txt
		umount endian
		rmdir endian
	fi
elif [ $1 = writecfg ];then
if [ -f efw.iso ];then
cat >> multicd-working/boot/isolinux/isolinux.cfg << "EOF"
label endianfirewall
	menu label ^Endian Firewall - Default
	kernel /boot/endian/vmlinuz 
	append initrd=/boot/endian/instroot.gz root=/dev/ram0 rw
label endianfirewall_unattended 
	menu label ^Endian Firewall - Unattended
	kernel /boot/endian/vmlinuz
	append initrd=/boot/endian/instroot.gz root=/dev/ram0 rw unattended
label endianfirewall_nopcmcia 
	menu label ^Endian Firewall - No PCMCIA
	kernel /boot/endian/vmlinuz
	append ide=nodma initrd=/boot/endian/instroot.gz root=/dev/ram0 rw nopcmcia
label endianfirewall_nousb
	menu label ^Endian Firewall - No USB
	kernel /boot/endian/vmlinuz
	append ide=nodma initrd=/boot/endian/instroot.gz root=/dev/ram0 rw nousb
label endianfirewall_nousborpcmcia
	menu label ^Endian Firewall - No USB nor PCMCIA
	kernel /boot/endian/vmlinuz
	append ide=nodma initrd=/boot/endian/instroot.gz root=/dev/ram0 rw nousb nopcmcia
EOF
fi
else
	echo "Usage: $0 {scan|copy|writecfg}"
	echo "Use only from within multicd.sh or a compatible script!"
	echo "Don't use this plugin script on its own!"
fi
