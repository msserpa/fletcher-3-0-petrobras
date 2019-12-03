CC=$(PGCC)
CFLAGS=-O3 -acc -ta=tesla:cc60,cc35,multicore
LIBS=$(PGCC_LIBS)
