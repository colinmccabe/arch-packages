#!/bin/sh

set -eu

NEW_VER=$1
BIN_FILE="firefox-$NEW_VER.tar.bz2"
ASC_FILE="$BIN_FILE.asc"

BASE_URL="https://ftp.mozilla.org/pub/firefox/releases/$NEW_VER/linux-x86_64/en-US"
curl -LO "$BASE_URL/$BIN_FILE"
curl -LO "$BASE_URL/$ASC_FILE"

sed -i "s/pkgver=.*/pkgver=$NEW_VER/g" PKGBUILD

OLD_BINSUM=$(grep -Eo '\w{64}' PKGBUILD | head -n 1)
OLD_ASCSUM=$(grep -Eo '\w{64}' PKGBUILD | head -n 2 | tail -n 1)
BINSUM=$(sha256sum "$BIN_FILE" | awk '{print $1}')
ASCSUM=$(sha256sum "$ASC_FILE" | awk '{print $1}')
sed -i "s/$OLD_BINSUM/$BINSUM/g" PKGBUILD
sed -i "s/$OLD_ASCSUM/$ASCSUM/g" PKGBUILD

makepkg -cirs --needed
