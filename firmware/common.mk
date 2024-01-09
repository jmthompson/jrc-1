ROOT_DIR	:= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
CC				:= cc65816
CFLAGS		:= --code-model=large --data-model=medium -l -O2 --speed  -I $(ROOT_DIR)include
AS				:= as65816
ASFLAGS		:= --code-model=large --data-model=medium -l
LD				:= ln65816
LDFLAGS		:=
AR				:= nlib
ARFLAGS		:=
MV				:= mv -f
RM				:= rm -f
CHIP			:= W29C020C
MEMSIM2		:= /dev/memsim2

OBJS			= $(subst .c,.o,$(subst .s,.o,$(SRCS)))
LISTINGS	= $(OBJS:.o=.lst)

AUTOGEN_FILE := $(ROOT_DIR)/include/kernel/version.h
AUTOGEN_NEXT := $(shell expr $$(awk '/#define BUILD_NUMBER/' $(AUTOGEN_FILE) | tr -cd "[0-9]") + 1)

all: $(OBJS)

.PHONY: clean-subdir
clean-subdir:
	$(RM) $(TARGET) $(OBJS) $(LISTINGS)

%.d: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -M $< | \
	$(SED) 's,\($(notdir $*)\.o\) *:,$(dir $@)\1 $@: ,' > $@.tmp
	$(MV) $@.tmp $@
