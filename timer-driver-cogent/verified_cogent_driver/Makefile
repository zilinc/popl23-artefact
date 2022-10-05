
all:
	cogent driver.cogent  \
	      --root-dir=../../cogent \
	      --fake-header-dir=../../cogent/cogent/lib  \
	      -g  \
	      --dist-dir=generated  \
	      -o driver  \
	      -A  \
	      --entry-funcs=entrypoints.cfg  \
	      --funused-dargent-accessors

clean:
	rm -f generated/*
