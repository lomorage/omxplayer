#!/bin/bash
set -e

nowDate=$(date +"%Y%m%d")
commitHash=$(git rev-parse --short HEAD)
VERSION="$nowDate+$commitHash"
PACKAGE_NAME="omxplayer"
BUILD_NAME=$PACKAGE_NAME"_"$VERSION

if [ -d $BUILD_NAME ]; then
    rm -rf $BUILD_NAME
fi

mkdir $BUILD_NAME
mkdir $BUILD_NAME/DEBIAN

cp -R omxplayer-dist/* $BUILD_NAME/

cat << EOF > $BUILD_NAME/DEBIAN/control
Package: $PACKAGE_NAME
Version: $VERSION
Section: video
Priority: optional
Architecture: all
Depends: libasound2 (>= 1.0.16), libavcodec58 (>= 7:4.0), libavformat58 (>= 7:4.1), libavutil56 (>= 7:4.0), libc6 (>= 2.28), libdbus-1-3 (>= 1.9.14), libfreetype6 (>= 2.2.1), libgcc1 (>= 1:3.5), libpcre3, libstdc++6 (>= 5.2), libswresample3 (>= 7:4.0), zlib1g (>= 1:1.1.4), ca-certificates, dbus
Maintainer: Jeromy Fu<fuji246@gmail.com>
Description: omxplayer
EOF

chown root:root -R $BUILD_NAME
dpkg -b $BUILD_NAME
