ROM_VERSION := 0060

AS := ca65
LD := ld65

SRCS     := $(wildcard */*.s) buildinfo.s
OBJS   	 := ${SRCS:.s=.o}
LISTINGS := ${SRCS:.s=.l}
TARGET   := jrcos.bin
MAPFILE  := jrcos.map

${TARGET}: ${OBJS}
	${LD} ${OBJS} ../stdlib/stdlib.bin -o ${TARGET} -C jrcos.cfg -m ${MAPFILE}

all: ${TARGET}

clean:
	rm -f buildinfo.s ${OBJS} ${LISTINGS} ${MAPFILE} ${TARGET}

buildinfo.s:
	echo ".segment \"BOOTROM\"" > buildinfo.s
	echo ".export jrcos_version" >> buildinfo.s
	echo ".export rom_date" >> buildinfo.s
	echo "jrcos_version: .word \$$${ROM_VERSION}" >> buildinfo.s
	date "+rom_date: .byte \"%Y-%m-%d\",0" >> buildinfo.s

%.o: %.s
	${AS} -I ../stdlib/include -I ./include --listing ${<:.s=.l} $<

.PHONY: dump buildinfo.s
