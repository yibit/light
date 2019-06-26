#!/bin/sh

set -e

usage()
{
    echo ""
    echo "Usage:                              "
    echo "      $0 < luarocks version >       "
    echo "                                    "
    echo "      $0 3.0.4                      "
    echo "                                    "

    return 0
}

version="$1"
NAME=luarocks-"$version".tar.gz

if test ! -f $NAME; then
    wget https://luarocks.org/releases/$NAME
if

if test ! -f $NAME;
    echo "install $NAME failed."
    exit 1
fi

tar zxpf $NAME
cd luarocks-"$version"
./configure
sudo make bootstrap
sudo luarocks install luasocket

echo "install $NAME successfully."
