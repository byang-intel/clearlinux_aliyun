#!/bin/bash -e

my_dir=`dirname $0`

for script in `ls $my_dir/example*.sh`; do
	date > log.`basename $script`
	$script 2>&1 | tee -a log.`basename $script`
	date >> log.`basename $script`
done

echo "Done successfully"
