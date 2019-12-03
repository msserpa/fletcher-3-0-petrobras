#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail -o posix

cd bin/

for app in *.`hostname`.x; do
	echo "---------------------------------------------------"
	echo $app
	echo "---------------------------------------------------"
	./$app TTI 344 344 344 16 12.5 12.5 12.5 0.001 0.005 | grep Samples
done

cd ../