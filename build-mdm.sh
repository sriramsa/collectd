#!/bin/bash -e 
#
# Build for Mdm for statsd with JSON support
#

if [ -z "$1" ]; then
    echo "Error: Release version not supplied"
    echo "Usage: ./build-mdm.sh <RELEASE-VER>"
    exit 1
fi

# Generate configure
./build.sh 

# Configure with mdm suffix
./configure --program-suffix=mdm --disable-all-plugins --enable-statsd --enable-write_log --enable-syslog --enable-logfile --enable-debug

# Build
make CFLAGS=-DWRITE_MDM_JSON_SUPPORT

REL_VER=$1

BUILD_DIR=${PWD}/build.collectd.mdm
SOURCE_DIR=${PWD}/src
HEADER_DIR=${BUILD_DIR}/usr/include/collectdmdm
MDM_REL_NAME=mdmstatsd-${REL_VER}
TARGET_GZ=${MDM_REL_NAME}.tar.gz

if [ -d ${BUILD_DIR} ]; then
    rm -rf ${BUILD_DIR}
fi

# Install the binaries in target dir
mkdir -p ${BUILD_DIR} || /bin/true

make install-exec DESTDIR=${BUILD_DIR}

# Copy Headers
mkdir -p ${HEADER_DIR}
find ./src -name '*.h' -exec cp --parents \{\} ${HEADER_DIR} \;

# Generate a release .tgz package
tar czf ${TARGET_GZ} ./build.collectd.mdm --transform s/build\.collectd\.mdm/${MDM_REL_NAME}/
echo ${TARGET_GZ} generated...
