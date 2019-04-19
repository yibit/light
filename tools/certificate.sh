#!/bin/sh

set -e

usage() {
    echo "Usage:                     "
    echo "      $0 <PASSPHRASE>      "
    echo "  e.g $0 '3edc!@#$'        "
    echo "                           "

    return 0
}

if test $# -ne 1; then
    usage
    exit 0
fi

passwd="$1"

UNAME=`uname -s`

if test "x$UNAME" = "xDarwin"; then
    sed -i '' "s/PASSPHRASE/$passwd/g" conf/light_cert.ini
else
    sed -i "s/PASSPHRASE/$passwd/g" conf/light_cert.ini
fi

openssl genrsa -des3 -out conf/light_cert.key -passout pass:$passwd 2048
openssl req -new -config conf/light_cert.ini -key conf/light_cert.key -passin pass:$passwd -out conf/light_cert.csr
openssl rsa -in conf/light_cert.key -passin pass:$passwd -out conf/light_cert.key
openssl x509 -req -days 365 -in conf/light_cert.csr -signkey conf/light_cert.key -out conf/light_cert.crt

if test "x$UNAME" = "xDarwin"; then
    sed -i '' "s/input_password =.*/input_password = 'PASSPHRASE'/g" conf/light_cert.ini
else
    sed -i "s/input_password =.*/input_password = 'PASSPHRASE'/g" conf/light_cert.ini
fi
