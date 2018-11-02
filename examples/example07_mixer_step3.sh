#!/bin/bash -e
  
my_dir=`dirname $0`

cd ~/mixer

LAST_VER=`cat update/image/LAST_VER`
mixer versions update
NEW_VER=`cat mixversion`

# Add the upstream curl bundle to the mix
mixer bundle add curl

echo helloclear > local-bundles/helloclear-bundle
mixer bundle add helloclear-bundle

mixer bundle list --tree

#sudo mixer build bundles --native
#sudo mixer build update --native
sudo mixer build bundles
sudo mixer build update

# this helps to reduce client update time
#sudo mixer build delta-packs --from $LAST_VER --to $NEW_VER --native
sudo mixer build delta-packs --from $LAST_VER --to $NEW_VER

echo "run qemu for update to new version: sudo ./start_qemu.sh release.img"
