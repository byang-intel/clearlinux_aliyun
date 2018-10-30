#!/bin/bash -e

my_dir=`dirname $0`

sudo rm -rf ~/mixer
mkdir ~/mixer
cd ~/mixer

mixer init --clear-version 25860 --mix-version 10 --local-rpms
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
sed "s/.*joe.*//g" -i upstream-bundles/clr-bundles-25860/bundles/editors
mixer bundle list --tree

sudo mixer build bundles --native
sudo mixer build update --native

curl -O https://raw.githubusercontent.com/bryteise/ister/master/release-image-config.json
sed "s/10G/5G/g" -i release-image-config.json
sed "s/kernel-native/kernel-kvm/g" -i release-image-config.json
sudo mixer build image --native

curl -O https://download.clearlinux.org/image/OVMF.fd 
cp -a $my_dir/start_qemu_nokvm.sh .
curl -O https://download.clearlinux.org/image/start_qemu.sh
chmod +x start_qemu.sh

if [ -e /dev/kvm ]; then
	echo "run qemu: sudo ./start_qemu.sh release.img"
else
	echo "run qemu: sudo ./start_qemu_nokvm.sh release.img"
fi
