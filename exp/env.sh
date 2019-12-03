#!/usr/bin/env bash

# Choose gcc or icc

# gcc
# export GCC=gcc
# export OMP_FLAG=-fopenmp

# icc 
source /home/intel/bin/iccvars.sh intel64

export GCC=icc
export OMP_FLAG=-qopenmp

export OMP_NUM_THREADS=`lscpu | grep "^CPU(s):" | awk {'print $2'}`

# pgcc
export PGI=/home/pgi
export LD_LIBRARY_PATH=/home/pgi/linux86-64/19.10/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export MANPATH=$MANPATH:$PGI/linux86-64/19.10/man
export LM_LICENSE_FILE=$PGI/license.dat
export PATH=$PGI/linux86-64/19.10/bin:$PATH

export ACC_DEVICE_TYPE=host
export ACC_NUM_CORES=`lscpu | grep "^CPU(s):" | awk {'print $2'}`

export PGCC_GPU_SM=cc60 # change GPU capability

# cuda
export PATH=$PATH:/usr/local/cuda/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib

export CUDA_GPU_SM=sm_60 # change GPU capability