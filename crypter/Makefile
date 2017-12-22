CC=gcc
ENCRYPT_NAME=encrypt
CCFLAGS= -Wall -Werror

debug: CCFLAGS += -g
debug: crypto

crypto: crypto.c crypto.h
	$(CC) -o $(ENCRYPT_NAME) crypto.c crypto.h $(CCFLAGS)
