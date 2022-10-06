FILE=random_seed
COGENT_PATH=../cogent
BUILD_DIR=build
AC_FILE=$(addsuffix .ac, $(FILE))
C_FILE=$(addsuffix .c, $(FILE))
COGENT_LIBGUM_DIR=$(COGENT_PATH)/cogent/lib


.PHONY: default clean
.SECONDARY:

default: all

all:
	mkdir -p $(BUILD_DIR)
	cogent "$(FILE).cogent" -A --dist-dir="$(BUILD_DIR)" -o"$(FILE)" \
		--root-dir="$(COGENT_PATH)" --entry-funcs=entrypoints.cfg \
		--infer-c-funcs="$(AC_FILE)" \
		--fake-header-dir="$(COGENT_LIBGUM_DIR)" \
		--cpp="$(CPP)" \
		--cpp-args="-x c \$$CPPIN -o \$$CPPOUT -E -P $(CFLAGS) -I$(BUILD_DIR) -I$(COGENT_LIBGUM_DIR)" 

clean:
	rm -rf $(BUILD_DIR)/* umm_types.txt
