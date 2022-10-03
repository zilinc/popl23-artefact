NAME=crude

SRC=Crude.cogent
OUTPUT=generated # $(SRC:.cogent=-gen)
COUTPUT=$(addsuffix .c, $(OUTPUT))
HOUTPUT=$(addsuffix .h, $(OUTPUT))

LIBGUM=$(shell cogent --libgum-dir)
PLATLIBGUM=../plat/console/libgum

#AHFILES=$(LIBGUM)/gum/anti/abstract/WordArray.ah
ACFILES=main.ac

PP=$(ACFILES:.ac=_pp.ac)
PPINFER=$(ACFILES:.ac=_pp_inferred.c)

ABSDIR=./abstract

OBJ=$(PPINFER:.c=.o)

CFLAGS+=-g -I. -I../plat/console -I$(LIBGUM) -I$(LIBGUM)/gum/anti -std=gnu99

.PHONY: default cogent clean gen-anti test
.SECONDARY:

default: all

all: gen-anti # $(OBJ)
	# $(CC) -o $(NAME) $(OBJ)

test: gen-anti $(OBJ)

$(OBJ): $(PPINFER)

simpl:
	cogent $(SRC) -A -g -Od -ogenerated --fno-fncall-as-macro --ffunc-purity-attr \
		--entry-funcs=entrypoints.cfg \
		--funused-dargent-accessors 

gen-anti:
	mkdir -p $(ABSDIR)
	cogent $(SRC) -A -g -Od -ogenerated --fno-fncall-as-macro --ffunc-purity-attr \
		--entry-funcs=entrypoints.cfg \
		--funused-dargent-accessors \
		--fno-simplify-shallow-tuples \
		--Wno-warn --infer-c-funcs="$(ACFILES)"  \
		--ext-types=types.cfg  \
		--infer-c-types="$(AHFILES)"  \
		--cpp="$(CPP)" \
		--cpp-args="-x c \$$CPPIN -o \$$CPPOUT -E -P $(CFLAGS)" 
	cp main_pp_inferred.c generated.c
	# replace the dargent generated struct with the C struct we want
	python3 rep.py

clean:
	rm -f $(COUTPUT) $(HOUTPUT) $(PP) $(PPINFER) $(OBJ)
	@# rm -f *-gen.*
	rm -f $(ABSDIR)/*.h
	rm -f $(NAME)
	rm -f Generated*.thy generated.table generated.table.new ROOT BUILD_INFO
