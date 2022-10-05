SRC=bitfields.cogent
TMP=$(SRC:.cogent=.tmp)
OUT=$(SRC:.cogent=.c)
BUILDDIR=build
COGENT_LIBGUM_DIR=../cogent/cogent/lib/

.PHONY: default cogent clean gen-anti test
.SECONDARY:

default: all

all:
	mkdir -p $(BUILDDIR)
	cogent $(SRC) -A --dist-dir=$(BUILDDIR) --root-dir=../cogent --entry-funcs=entrypoints.cfg --funused-dargent-accessors
	mv $(BUILDDIR)/$(OUT) $(BUILDDIR)/$(TMP)
	$(CPP) -x c -E -P $(BUILDDIR)/$(TMP) -o $(BUILDDIR)/$(OUT) -I $(COGENT_LIBGUM_DIR)

clean:
	rm -r -f $(BUILDDIR)
	rm -f umm_types.txt

