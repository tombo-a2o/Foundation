How to build
============

cd {somewhere}
git clone git@github.com:tomboinc/Foundation.git --branch feature/emscripten
cd Foundation

cd System/CoreFoundation/src
make
DSTROOT=${EMSCRIPTEN}/system/frameworks make install
cd ../../../
cd System/Foundation/src
make
DSTROOT=${EMSCRIPTEN}/system/frameworks make install

cd ../../../
cd System/test
make
node str.js
