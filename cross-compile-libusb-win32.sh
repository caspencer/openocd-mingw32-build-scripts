#!/bin/sh

# requires gcc-mingw32 package
# apt-get install gcc-mingw32
# NOTE: must patch /usr/i586-mingw32msvc/include/winbase.h to include CheckTokenMembership declaration because packaged version of winbase.h is lame apparently

BUILD_DIR=/tmp/cross-compile/libusb-win32
OUTPUT_DIR=/tmp/cross-compile/output
RELEASE_NAME=libusb-win32-src-1.2.5.0
RELEASE_VERSION=1.2.5.0

if [ -d $BUILD_DIR ]; then
	rm -rf $BUILD_DIR
fi

if [ ! -d "$OUTPUT_DIR/include" ]; then
	mkdir -p $OUTPUT_DIR/include
else
	rm $OUTPUT_DIR/include/*usb.h
fi

if [ ! -d "$OUTPUT_DIR/lib" ]; then
	mkdir -p $OUTPUT_DIR/lib
else
	rm $OUTPUT_DIR/lib/libusb*
fi

if [ ! -d "$OUTPUT_DIR/bin" ]; then
	mkdir -p $OUTPUT_DIR/bin
else
	rm $OUTPUT_DIR/bin/libusb*
fi

mkdir -p $BUILD_DIR
cd $BUILD_DIR
wget http://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/$RELEASE_VERSION/$RELEASE_NAME.zip

unzip -q $RELEASE_NAME.zip

cd $RELEASE_NAME 

make host_prefix=i586-mingw32msvc all

cp src/lusb0_usb.h $OUTPUT_DIR/include
ln -s $OUTPUT_DIR/include/lusb0_usb.h $OUTPUT_DIR/include/usb.h
cp *.a $OUTPUT_DIR/lib
cp *.dll $OUTPUT_DIR/bin
