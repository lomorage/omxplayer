#!/bin/bash
set -e

case "$1" in
        jessie)
		DEPS="libasound2 (>= 1.0.16), libavcodec57 (>= 7:3.2.14) | libavcodec-extra57 (>= 7:3.2.14), libavformat57 (>= 7:3.2.14), libavutil55 (>= 7:3.2.14), libc6 (>= 2.4), libdbus-1-3 (>= 1.9.14), libfreetype6 (>= 2.2.1), libgcc1 (>= 1:3.5), libpcre3, libstdc++6 (>= 5.2), libswresample2 (>= 7:3.2.14), zlib1g (>= 1:1.1.4), ca-certificates, dbus"
		;;
	buster)
		DEPS="libasound2 (>= 1.0.16), libavcodec58 (>= 7:4.0), libavformat58 (>= 7:4.1), libavutil56 (>= 7:4.0), libc6 (>= 2.28), libdbus-1-3 (>= 1.9.14), libfreetype6 (>= 2.2.1), libgcc1 (>= 1:3.5), libpcre3, libstdc++6 (>= 5.2), libswresample3 (>= 7:4.0), zlib1g (>= 1:1.1.4), ca-certificates, dbus"
		;;
	*)
		echo "Usage: $0 {buster|jessie}" >&2
		exit 3
		;;
esac

nowDate=$(date +"%Y%m%d")
commitHash=$(git rev-parse --short HEAD)
VERSION="$nowDate+$commitHash"
PACKAGE_NAME="lomo-omxplayer"
BUILD_NAME=$PACKAGE_NAME"_"$VERSION"_"$1

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
Architecture: armhf
Depends: $DEPS
Maintainer: Jeromy Fu<fuji246@gmail.com>
Description: omxplayer
EOF

chown root:root -R $BUILD_NAME
dpkg -b $BUILD_NAME
