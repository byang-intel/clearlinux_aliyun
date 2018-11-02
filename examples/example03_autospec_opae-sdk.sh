#!/bin/bash -e

if [ ! -e packages/common ]; then
	echo Please run this command in \"clearlinux\" folder
	exit 1
fi

if [ -e packages/opae-sdk]; then
	echo Please delete opae-sdk in \"packages\" folder
	exit 1
fi

make autospecnew \
	URL="https://github.com/OPAE/opae-sdk/archive/0.13.0.tar.gz" \
	NAME="opae-sdk" || true

cd packages/opae-sdk
echo "MIT" > opae-sdk.license
make autospec || true

echo "json-c-dev" >> buildreq_add
echo "util-linux-dev" >> buildreq_add
make autospec

cp results/*.rpm ~/rpms-save
rm ~/rpms-save/opae-sdk-debuginfo* ~/rpms-save/opae-sdk-*.src.rpm

echo "Done successfully"

