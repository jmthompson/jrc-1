ROM_VERSION := 0060

AS := ca65
LD := ld65

TARGET  := rom.bin
SUBDIRS := jrcos basic
CHIP    := W29C020C
SIZE	  := 256K
MEMSIM2	:= /dev/memsim2

all: ${TARGET}

${TARGET}: ${SUBDIRS}
	rm -f ${TARGET}
	for piece in ${SUBDIRS}; do \
    cat $$piece/$$piece.bin >> ${TARGET}; \
  done
	truncate -s ${SIZE} ${TARGET}

prog: ${TARGET}
	minipro -p ${CHIP} -w ${TARGET}

upload: ${TARGET}
	memsim2 -d ${MEMSIM2} -m 27020 -r -1 ${TARGET}

clean:
	for dir in ${SUBDIRS}; do \
		make -C $$dir clean; \
	done
	rm -f ${TARGET}

${SUBDIRS}:
	$(MAKE) -C $@

.PHONY: all ${SUBDIRS}
