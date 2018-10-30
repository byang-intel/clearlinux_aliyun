#!/bin/bash -e

my_dir=`dirname $0`

if [ ! -e packages/helloclear ]; then
	echo Please build helloclear first
	exit 1
fi

if [ ! -e clear.img ]; then
	curl -O https://download.clearlinux.org/image/OVMF.fd 
	curl -O https://download.clearlinux.org/image/start_qemu.sh
	chmod +x start_qemu.sh
	cp -a $my_dir/start_qemu_nokvm.sh .
	curl -o clear.img.xz https://download.clearlinux.org/image/clear-$(curl https://download.clearlinux.org/latest)-kvm.img.xz
	unxz -v clear.img.xz
fi

cd packages/helloclear
make install
cd -

if [ -e /dev/kvm ]; then
	echo "run qemu: sudo ./start_qemu.sh clear.img"
else
	echo "run qemu: sudo ./start_qemu_nokvm.sh clear.img"
fi

