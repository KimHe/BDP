
CC = gcc
CFLAGS = -g -Wall

bdp: bdp.c
	$(CC) $(CFLAGS) bdp.c -o bdp

clean: 
	rm -r bdp

install: 
	sudo mv bdp /usr/local/bin/
