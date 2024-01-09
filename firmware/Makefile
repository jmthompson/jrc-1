SUBDIRS			:= src/boot src/lib src/core src/fs src/drivers src/monitor
ALL_OBJS		:= $(foreach subdir,$(SUBDIRS),$(subdir)/*.o)
LISTING			:= ln65816.lst
BUILDFILE   := aout.elf
TARGET			:= rom.bin

AUTOGEN_FILE = $(ROOT_DIR)/include/kernel/build.h
AUTOGEN_NEXT = $(shell expr $$(awk '/#define BUILD_NUMBER/' $(AUTOGEN_FILE) | tr -cd "[0-9]") + 1)

$(TARGET): buildinfo subdirs
	$(LD) $(LDFLAGS) --program-root sysreset --cstartup jrcos --rom-code --output-format raw --raw-multiple-memories -l jrc-1.scm $(ALL_OBJS)
	@truncate -s 62k lorom.raw
	@truncate -s 192k hirom.raw
	@cat lorom.raw bank0rom.raw hirom.raw > rom.bin
	@$(RM) lorom.raw bank0rom.raw hirom.raw

.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)

.PHONY: buildinfo
buildinfo:
	sed -i "s/#define BUILD_NUMBER .*/#define BUILD_NUMBER \"$(AUTOGEN_NEXT)\"/" $(AUTOGEN_FILE)
	sed -i "s/#define BUILD_DATE.*/#define BUILD_DATE \"$$(date +'%Y-%m-%d')\"/" $(AUTOGEN_FILE)

$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: clean
clean:
	@for i in $(SUBDIRS); do $(MAKE) -C $$i clean-subdir; done;
	$(RM) $(TARGET) $(LISTING) $(BUILDFILE)

.PHONY: prog
prog: target
	minipro -p $(CHIP) -w $(TARGET)

.PHONY: upload
upload: $(TARGET)
	memsim2 -d $(MEMSIM2) -m 27020 -r -1 $(TARGET)

include common.mk
