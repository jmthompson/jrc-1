ROM_VERSION := 0060

AS := ca65
AR := ar65

SRCS     := $(wildcard *.s)
OBJS   	 := ${SRCS:.s=.o}
LISTINGS := ${SRCS:.s=.l}
TARGET   := stdlib.bin

${TARGET}: ${OBJS}
	${AR} r ${TARGET} ${OBJS}

all: ${TARGET}

clean:
	rm -f ${OBJS} ${LISTINGS} ${TARGET}

%.o: %.s
	${AS} -I ./include --listing ${<:.s=.l} $<

.PHONY: all clean
