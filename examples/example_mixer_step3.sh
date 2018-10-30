#!/bin/bash -e
  
my_dir=`dirname $0`

cd ~/mixer

LAST_VER=`cat update/image/LAST_VER`
mixer versions update
NEW_VER=`cat mixversion`

echo helloclear > local-bundles/helloclear-bundle
mixer bundle add helloclear-bundle

mixer bundle list --tree

sudo mixer build bundles --native
sudo mixer build update --native

# this helps to reduce client update time
sudo mixer build delta-packs --from $LAST_VER --to $NEW_VER --native

if [ -e /dev/kvm ]; then
        echo "run qemu for update to new version: sudo ./start_qemu.sh release.img"
else
        echo "run qemu for update to new version: sudo ./start_qemu_nokvm.sh release.img"
fi
