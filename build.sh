#!/bin/bash

# install required packages
sudo apt-get install build-essential gcc-mingw32 cmake automake zip libtool

# apply winbase.h patch
sudo patch -N -u -s /usr/i586-mingw32msvc/include/winbase.h winbase.h.patch

CWD=`pwd`
TMP_CROSS_COMPILE_DIR=/tmp/cross-compile
OUTPUT_ZIP_DATE=`date +%Y-%m-%d_%H%M`
OUTPUT_ZIP=$CWD/openocd-0.6.0-dev-mingw32-$OUTPUT_ZIP_DATE.zip

if [ -d "$TMP_CROSS_COMPILE_DIR" ]; then
    rm -rf $TMP_CROSS_COMPILE_DIR
fi

mkdir -p $TMP_CROSS_COMPILE_DIR

./cross-compile-libusb-win32.sh
./cross-compile-libftdi.sh
./cross-compile-openocd.sh

if [ -f "$OUTPUT_ZIP" ]; then
    rm $OUTPUT_ZIP
fi

cd $TMP_CROSS_COMPILE_DIR/output
zip -q -r $OUTPUT_ZIP . && cd $CWD
echo '*** DONE! ***'
