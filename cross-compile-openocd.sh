#!/bin/bash

OUTPUT_DIR=/tmp/cross-compile/output
BUILD_DIR=/tmp/cross-compile/openocd-git
OPENOCD_VERSION=openocd-git

if [ -d $BUILD_DIR ]; then
	rm -rf $BUILD_DIR
fi

mkdir -p $BUILD_DIR

cd $BUILD_DIR

git clone git://openocd.git.sourceforge.net/gitroot/openocd/openocd $OPENOCD_VERSION

cd $OPENOCD_VERSION

./bootstrap

# cross compile with libftdi support
./configure --build=i686-pc-linux-gnu --host=i586-mingw32msvc \
--enable-maintainer-mode \
--prefix=$OUTPUT_DIR \
--disable-werror \
--disable-shared \
--enable-ft2232_libftdi \
--enable-usb_blaster_libftdi

make && make install
