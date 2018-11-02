#!/bin/bash -e

CLR_VER=25860

my_dir=`dirname $0`

sudo rm -rf ~/mixer
mkdir ~/mixer
cd ~/mixer

mixer init --clear-version $CLR_VER --mix-version 10 --local-rpms
mixer versions
mixer bundle list

PUBLIC_IP=$(dig @resolver1.opendns.com -t A -4 myip.opendns.com +short)
echo "public ip: $PUBLIC_IP"

sed "s/CONTENTURL.*$/CONTENTURL = \"http:\/\/$PUBLIC_IP\"/g"  -i builder.conf
sed "s/VERSIONURL.*$/VERSIONURL = \"http:\/\/$PUBLIC_IP\"/g"  -i builder.conf

cp ~/rpms-save/helloclear*.rpm local-rpms
cp ~/rpms-save/joe*.rpm local-rpms

mixer add-rpms
mixer bundle list
mixer bundle remove kernel-native
mixer bundle add kernel-kvm

echo joe > local-bundles/joe-bundle
mixer bundle add joe-bundle 

mixer bundle add editors
sed "s/.*joe.*//g" -i upstream-bundles/clr-bundles-$CLR_VER/bundles/editors
mixer bundle list --tree

sudo mixer repo set-url clear https://cdn.download.clearlinux.org/releases/$CLR_VER/clear/x86_64/os/

#sudo mixer build bundles --native
#sudo mixer build update --native
sudo mixer build bundles
sudo mixer build update

curl -O https://raw.githubusercontent.com/bryteise/ister/master/release-image-config.json
sed "s/10G/5G/g" -i release-image-config.json
sed "s/kernel-native/kernel-kvm/g" -i release-image-config.json
#sudo mixer build image --native
sudo mixer build image

[ -e OVMF.fd ] || curl -O https://cdn.download.clearlinux.org/image/OVMF.fd 
if [ ! -e start_qemu.sh ]; then
	curl -O https://cdn.download.clearlinux.org/image/start_qemu.sh
	if [ ! -e /dev/kvm ]; then
		sed -i -e "s/-enable-kvm//g" -e "s/-cpu host/-cpu Haswell/g" -e "s/-smp sockets=.,cpus=.,cores=./-smp sockets=1,cpus=`nproc`,cores=`nproc`/g" start_qemu.sh
	fi
	chmod +x start_qemu.sh
fi

echo "run qemu: sudo ./start_qemu.sh release.img"
