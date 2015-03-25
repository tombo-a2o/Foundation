How to build
============

cd {somewhere}
git clone git@github.com:tomboinc/Foundation.git
cd Foundation

cd System/CoreFoundation/src
make
make install
cd ../../../
cd System/Foundation/src
make
make install

cd ../../../
cd System/test
make
node str.js
