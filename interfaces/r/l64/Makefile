Q=~/q/l64
INCLUDES=-I. -I/usr/share/R/include
LIBS=-lpthread -L/usr/lib/R/lib/ -lR

CC=gcc
CFLAGS=-g -O -fPIC -m64 -shared

SRC=../kdbplus.c c.o
TARGET=kdbplus.so

all:
	${CC} ${CFLAGS} ${INCLUDES} ${SRC} ${LIBS} -o ${TARGET}

install:
	cp ${TARGET} ${Q}
