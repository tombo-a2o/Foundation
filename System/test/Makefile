OBJC4=../../../../objc4

OBJS=$(OBJC4)/libobjc4.bc $(OBJC4)/lib/libclosure-65/libclosure.bc

INCLUDE=-I$(OBJC4)/include -F../Foundation/NS-Root -F../CoreFoundation/CF-Root -I../CFNetwork/include -I$(OBJC4)/lib/libclosure-65 -I../../../../libdispatch-442.1.4
CLANG_OPTS=-fblocks -fobjc-runtime=macosx
EM_OPTS=-v -s TOTAL_MEMORY=100000000 -s ASSERTIONS=0 -s DEMANGLE_SUPPORT=1 -s ERROR_ON_UNDEFINED_SYMBOLS=0 --js-library $(OBJC4)/runtime/lib.js -framework Foundation -framework CoreFoundation --embed-file res@/
CFLAGS=$(INCLUDE) $(CLANG_OPTS) $(EM_OPTS)

CC=emcc

all:	str.js

str.js:	str.m
	#EMCC_DEBUG=1 EMCC_DEBUG_SAVE=1 $(CC) $(CFLAGS) $< -o $@ $(OBJS)
	EMCC_DEBUG=1 EMCC_DEBUG_SAVE=1 $(CC) $(CFLAGS) -o $@ $(OBJS) $<

str.ll:	str.m
	$(CC) -emit-llvm -S -o $@ $(CLANG_OPTS) $(INCLUDE) $<
