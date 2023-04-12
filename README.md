# initrd-edit

So first things first, I have no Idea what I am doing.

This scripts works fine to extract and package the initrd file within a mounted ubuntu iso.

backround for the creation of this is that I have an ipxe server and needed to deploy Ubuntu 20 on laptops, the laptops a thin and has no 
ethernet ports, so they need an lan to usb-c adapter, ipxe have the support for that and gets so far as downloading the initrd and vmlinz 
from a mounted live server iso.
but when the laptop loads those files and tryes to "boot" from them it fails to detect network interfaces.(ubuntu 22 works)

I am trying to load the RTL8152 and RTL8153 .ko files in to the (with this script) extracted /lib/modules/version0.0.0.something/kernel/drivers/net/usb
by just placing the files there, and then again with this scripts package a new working initrd file, the initrd boots up and fails at 
detecting network card.
