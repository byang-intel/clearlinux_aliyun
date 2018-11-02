#!/bin/bash -e

if [ ! -e packages/common ]; then
	echo Please run this command in \"clearlinux\" folder
	exit 1
fi

if [ -e packages/helloclear ]; then
	echo Please delete helloclear in \"packages\" folder
	exit 1
fi

make autospecnew \
	URL="https://github.com/clearlinux/helloclear/archive/helloclear-v1.0.tar.gz" \
	NAME="helloclear"

cp packages/helloclear/results/helloclear-v1.0-1.x86_64.rpm ~/rpms-save
cp packages/helloclear/results/helloclear-bin-v1.0-1.x86_64.rpm ~/rpms-save

echo "Done successfully"
