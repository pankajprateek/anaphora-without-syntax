
.PHONY: gizapp mkcls-v2

all: gizapp mkcls-v2
	mkdir -p GIZAppv2
	cp GIZA++-v2/*.out GIZAppv2
	cp GIZA++-v2/GIZA++ GIZAppv2

gizapp:
	$(MAKE) -C GIZA++-v2

mkcls-v2:
	$(MAKE) -C mkcls-v2

clean:
	$(MAKE) -C GIZA++-v2 clean
	$(MAKE) -C mkcls-v2 clean
