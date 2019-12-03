CC=$(GCC)
CFLAGS=-O3
GPUCC=$(NVCC)
#GPUCFLAGS=-Xptxas="-v" --maxrregcount 127 --gpu-architecture sm_60
#GPUCFLAGS=-Xptxas="-v" --maxrregcount 127 --gpu-architecture sm_35
GPUCFLAGS=-Xptxas="-v" --gpu-architecture sm_37
LIBS=-L/usr/local/cuda/lib64 -lcudart -lstdc++ $(GCC_LIBS)
