AS := ca65
LD := ld65

SRCS     := $(wildcard *.s)
OBJS   	 := ${SRCS:.s=.o}
LISTINGS := ${SRCS:.s=.l}
TARGET   := basic.bin
MAPFILE  := basic.map

all: ${TARGET}

${TARGET}: ${OBJS}
	${LD} ${OBJS} -o ${TARGET} -C basic.cfg -m ${MAPFILE}

all: ${TARGET}

clean:
	rm -f ${OBJS} ${LISTINGS} ${MAPFILE} ${TARGET}

%.o: %.s
	${AS} -I ../include --listing ${<:.s=.l} $<

.PHONY: all
