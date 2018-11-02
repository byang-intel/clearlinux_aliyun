#!/bin/bash -e

if [ ! -e packages/joe ]; then
	echo Please run this command in \"clearlinux\" folder
	exit 1
fi

cd packages/joe
make build

mkdir -p ~/rpms-save
cp results/joe-4.6-31.x86_64.rpm ~/rpms-save
cp results/joe-bin-4.6-31.x86_64.rpm ~/rpms-save
cp results/joe-data-4.6-31.x86_64.rpm ~/rpms-save
cp results/joe-doc-4.6-31.x86_64.rpm ~/rpms-save
cp results/joe-extras-4.6-31.x86_64.rpm ~/rpms-save

echo "Done successfully"

