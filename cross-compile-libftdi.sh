#!/bin/sh

# requires gcc-mingw32 package
# apt-get install gcc-mingw32

OUTPUT_DIR=/tmp/cross-compile/output
BUILD_DIR=/tmp/cross-compile/libftdi
LIBFTDI_VERSION=libftdi-0.19

if [ -d $BUILD_DIR ]; then
	rm -rf $BUILD_DIR
fi

if [ ! -d "$OUTPUT_DIR/include" ]; then
        mkdir -p $OUTPUT_DIR/include
else
        rm $OUTPUT_DIR/include/ftdi*
fi

if [ ! -d "$OUTPUT_DIR/lib" ]; then
        mkdir -p $OUTPUT_DIR/lib
else
        rm $OUTPUT_DIR/lib/libftdi*
fi

if [ ! -d "$OUTPUT_DIR/bin" ]; then
        mkdir -p $OUTPUT_DIR/bin
else
        rm $OUTPUT_DIR/bin/libftdi*
fi

mkdir -p $BUILD_DIR

cd $BUILD_DIR

wget http://www.intra2net.com/en/developer/libftdi/download/$LIBFTDI_VERSION.tar.gz

tar zxf $LIBFTDI_VERSION.tar.gz

cd $LIBFTDI_VERSION

mkdir build-win32

# modify Toolchain-mingw32.cmake to use i586-mingw32msvc cross compiler
sed -i 's/i386/i586/g' Toolchain-mingw32.cmake
#sed -i 's/i386/amd64/g' Toolchain-mingw32.cmake
sed -i 's/opt\/cross/usr/g' Toolchain-mingw32.cmake

cd build-win32

#cmake -DCMAKE_TOOLCHAIN_FILE=../Toolchain-mingw32.cmake -DCMAKE_BUILD_TYPE=MinSizeRel ..
cmake -DCMAKE_TOOLCHAIN_FILE=../Toolchain-mingw32.cmake -DCMAKE_BUILD_TYPE=MinSizeRel \
-DLIBUSB_INCLUDE_DIR=$OUTPUT_DIR/include \
-DLIBUSB_LIBRARIES=$OUTPUT_DIR/lib/libusb.a \
..

make all 

cp ../src/ftdi.h $OUTPUT_DIR/include
cp src/libftdi.a $OUTPUT_DIR/lib
cp src/libftdi.dll $OUTPUT_DIR/bin
