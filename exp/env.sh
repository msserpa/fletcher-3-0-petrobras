#!/usr/bin/env bash

# Choose gcc or icc

# gcc
# export GCC=gcc
# export OMP_FLAG=-fopenmp

# icc 
source /home/intel/oneapi/compiler/latest/env/vars.sh

export GCC=icc
export OMP_FLAG=-qopenmp

export OMP_NUM_THREADS=`lscpu | grep "^CPU(s):" | awk {'print $2'}`

# pgcc
export PGI=/home/pgi
export PGI_DIR=$PGI/linux86-64-llvm/2019
export PGI_CURR_CUDA_HOME=$PGI_DIR/cuda/
export LD_LIBRARY_PATH=$PGI_DIR/lib:$LD_LIBRARY_PATH
export MANPATH=$PGI_DIR/man:$MANPATH
export LM_LICENSE_FILE=$PGI/license.dat
export PATH=$PGI_DIR/bin:$PATH

# run OpenACC in multicore
export ACC_DEVICE_TYPE=host
export ACC_NUM_CORES=`lscpu | grep "^CPU(s):" | awk {'print $2'}`

# gpu versions and compute capabilities
# https://en.wikipedia.org/wiki/CUDA

# run OpenACC in GPUs
#export ACC_DEVICE_TYPE=nvidia

#export PGCC_GPU_SM=cc35 # NVIDIA K20m
#export PGCC_GPU_SM=cc37 # NVIDIA K80
export PGCC_GPU_SM=cc60 # NVIDIA P100
#export PGCC_GPU_SM=cc61 # NVIDIA GTX 1080Ti
#export PGCC_GPU_SM=cc75 # NVIDIA RTX 2080Ti

# cuda
export HOST_COMPILER=icc
export PATH=$PATH:/usr/local/cuda/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64

#export CUDA_GPU_SM=sm_35 # NVIDIA K20m
#export CUDA_GPU_SM=sm_37 # NVIDIA K80
export CUDA_GPU_SM=sm_60 # NVIDIA P100
#export CUDA_GPU_SM=sm_61 # NVIDIA GTX 1080Ti
#export CUDA_GPU_SM=sm_75 # NVIDIA RTX 2080Ti
