#!/bin/bash -e 
#
# Build for Mdm for statsd
#

# Generate configure
./build.sh 

# Configure with mdm suffix
#./configure --program-suffix=mdm --without-java --without-libl
./configure --program-suffix=mdm --disable-all-plugins --enable-statsd --enable-write_log --enable-syslog --enable-logfile

# Build
make

BUILD_DIR=${PWD}/build.collectd.mdm
# Install executables we need
if [ -d ${BUILD_DIR} ]; then
    rm -rf ${BUILD_DIR}
fi

mkdir ${BUILD_DIR}
make install-exec DESTDIR=${BUILD_DIR}

