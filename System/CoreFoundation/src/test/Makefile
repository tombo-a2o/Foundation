all:	test.js

test.js:	test.c
	emcc -fblocks -I../CF-Objects/normal -I../../objc4/lib/libclosure-65 -I../../libdispatch-442.1.4 ../CF-Objects/normal/CoreFoundation_normal.bc ../../objc4/lib/libclosure-65/libclosure.bc -o test.js test.c
