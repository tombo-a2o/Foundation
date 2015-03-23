all:	test.js

test.js:	test.c
	emcc -v -fblocks -F../.. -framework CoreFoundation -I../../objc4/lib/libclosure-65 -I../../libdispatch-442.1.4 ../../objc4/lib/libclosure-65/libclosure.bc -o test.js test.c
