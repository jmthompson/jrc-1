ROOT_DIR	:= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
CC				:= cc65816
CFLAGS		:= --code-model=large --data-model=medium -l -O2 --speed -I $(ROOT_DIR)include
AS				:= as65816
ASFLAGS		:= --code-model=large --data-model=medium -l
LD				:= ln65816
LDFLAGS		:= --no-merge-raw-memories --no-auto-libraries --program-root sysreset --cstartup jrcos --rom-code --output-format raw --raw-multiple-memories -l
AR				:= nlib
ARFLAGS		:=
MV				:= mv -f
RM				:= rm -f
CHIP			:= W29C020C
MEMSIM2		:= /dev/memsim2

OBJS			= $(subst .c,.o,$(subst .s,.o,$(SRCS)))
LISTINGS	= $(OBJS:.o=.lst)

all: $(OBJS)

.PHONY: clean-subdir
clean-subdir:
	$(RM) $(TARGET) $(OBJS) $(LISTINGS)

%.d: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -M $< | \
	$(SED) 's,\($(notdir $*)\.o\) *:,$(dir $@)\1 $@: ,' > $@.tmp
	$(MV) $@.tmp $@
