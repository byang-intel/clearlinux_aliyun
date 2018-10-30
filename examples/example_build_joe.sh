#!/bin/bash -e

if [ ! -e packages/joe ]; then
	echo Please run this command in \"clearlinux\" folder
	exit 1
fi

cd packages/joe
make build

mkdir -p ~/rpms-save

cp results/*.rpm ~/rpms-save
rm ~/rpms-save/joe-debuginfo* ~/rpms-save/joe-*.src.rpm

echo "Done successfully"

