#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail -o posix

mkdir -p bin/
cd ../

for version in der1der1hm der1der1lm der1der1 original; do
	cd $version
	for backend in OpenMP CUDA OpenACC; do
		make backend=$backend
		mv ModelagemFletcher.exe ../exp/bin/$version.$backend.`hostname`.x
		make clean backend=$backend
	done
	cd ..
done
