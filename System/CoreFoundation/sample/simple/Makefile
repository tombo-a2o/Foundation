all:	test.js

test.js:	test.c
	#emcc -O0 -s ASSERTIONS=0 -fblocks -framework Foundation -framework CoreFoundation -lobjc4 -lBlocksRuntime -ldispatch -o test.js test.c
	a2o -O0 -s ASSERTIONS=0 -o test.js test.c
