SUBDIRS			:= src/boot src/lib src/core src/fs src/drivers src/monitor
ALL_OBJS		:= $(foreach subdir,$(SUBDIRS),$(subdir)/*.o)
LIBS        := clib-lc-md.a
LISTING			:= ln65816.lst
BUILDFILE   := aout.elf
TARGET			:= rom.bin

AUTOGEN_FILE = $(ROOT_DIR)/include/kernel/buildinfo.h
AUTOGEN_NEXT = $(shell expr $$(awk '/#define BUILD_NUMBER/' $(AUTOGEN_FILE) | tr -cd "[0-9]") + 1)

$(TARGET): buildinfo subdirs
	$(LD) $(LDFLAGS) jrc-1.scm $(ALL_OBJS) $(LIBS)
	@truncate -s 62k lorom.raw
	@truncate -s 192k hirom.raw
	@cat lorom.raw ln65816.raw hirom.raw > rom.bin
	@$(RM) lorom.raw ln65816.raw hirom.raw

.PHONY: subdirs $(SUBDIRS)
subdirs: $(SUBDIRS)

.PHONY: buildinfo
buildinfo:
	@rm -f $(AUTOGEN_FILE)
	echo "#define BUILD_NUMBER $(AUTOGEN_NEXT)" > $(AUTOGEN_FILE)
	echo "#define BUILD_DATE \"$$(date +'%Y-%m-%d')\"" >> $(AUTOGEN_FILE)

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
