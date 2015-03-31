INCLUDE=-I$(OBJC4)/include -I../CFNetwork/include
CLANG_OPTS=-fblocks -fobjc-runtime=macosx
EM_OPTS=-v -s TOTAL_MEMORY=100000000 -s ASSERTIONS=0 -s DEMANGLE_SUPPORT=1 -s ERROR_ON_UNDEFINED_SYMBOLS=0 -framework Foundation -framework CoreFoundation
CFLAGS=$(INCLUDE) $(CLANG_OPTS) $(EM_OPTS)
LFLAGS=-lobjc4 -lclosure -ldispatch

CC=emcc

all:	str.js

str.js:	str.m
	#EMCC_DEBUG=1 EMCC_DEBUG_SAVE=1 $(CC) $(CFLAGS) $< -o $@
	EMCC_DEBUG=1 EMCC_DEBUG_SAVE=1 $(CC) $(CFLAGS) $(LFLAGS) -o $@ $<

str.ll:	str.m
	$(CC) -emit-llvm -S -o $@ $(CLANG_OPTS) $(INCLUDE) $<

str:	str.m
	clang -framework Foundation -o $@ $<
